import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:xtacy_backoffice/core/constants/app_constants.dart';
import 'package:xtacy_backoffice/core/constants/category_constants.dart';
import 'package:xtacy_backoffice/core/errors/failures.dart';
import 'package:xtacy_backoffice/data/models/inventory_filter.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';
import 'package:xtacy_backoffice/data/services/hive_service.dart';

/// Firestore data access for products with offline persistence and pagination.
class FirestoreService {
  FirestoreService({
    FirebaseFirestore? firestore,
    HiveService? hiveService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _hiveService = hiveService ?? HiveService.instance;

  final FirebaseFirestore _firestore;
  final HiveService _hiveService;

  CollectionReference<Map<String, dynamic>> get _productsRef =>
      _firestore.collection(AppConstants.productsCollection);

  /// Waits for Firebase Auth token before Firestore reads (avoids race after sign-in).
  Future<void> _ensureAuthReady() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.getIdToken();
    }
  }

  ProductModel? _parseProductDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      return ProductModel.fromFirestore(doc);
    } catch (e, stack) {
      debugPrint('Skipping invalid product ${doc.id}: $e\n$stack');
      return null;
    }
  }

  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    try {
      await _firestore.collection(AppConstants.usersCollection).doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to save user');
    }
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      await _productsRef.doc(product.id).set(product.toJson());
      return product;
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to create product');
    }
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      await _productsRef.doc(product.id).update(product.toJson());
      return product;
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to update product');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _productsRef.doc(productId).delete();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to delete product');
    }
  }

  Future<ProductModel?> getProduct(String productId) async {
    try {
      final doc = await _productsRef.doc(productId).get();
      if (!doc.exists) return null;
      return ProductModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to fetch product');
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      await _ensureAuthReady();
      final snapshot = await _productsRef
          .orderBy('createdAt', descending: true)
          .get();
      final products = snapshot.docs
          .map(_parseProductDoc)
          .whereType<ProductModel>()
          .toList();
      try {
        await _hiveService.cacheProducts(products);
      } catch (e) {
        debugPrint('Hive cache write failed (non-fatal): $e');
      }
      return products;
    } on FirebaseException catch (e) {
      debugPrint('Firestore getAllProducts failed: ${e.code} ${e.message}');
      final cached = _hiveService.getCachedProducts();
      if (cached.isNotEmpty) return cached;
      throw ServerFailure(e.message ?? 'Failed to fetch products');
    } catch (e) {
      debugPrint('getAllProducts unexpected error: $e');
      final cached = _hiveService.getCachedProducts();
      if (cached.isNotEmpty) return cached;
      throw ServerFailure(e.toString());
    }
  }

  Future<List<ProductModel>> getProductsPage({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _productsRef
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();
      return snapshot.docs.map(ProductModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to fetch products');
    }
  }

  List<ProductModel> applyFilter(
    List<ProductModel> products,
    InventoryFilter filter,
  ) {
    var filtered = products;

    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return p.productName.toLowerCase().contains(query) ||
            p.productCode.toLowerCase().contains(query) ||
            p.colour.toLowerCase().contains(query);
      }).toList();
    }

    if (filter.category != null) {
      filtered = filtered.where((p) => p.category == filter.category).toList();
    }

    switch (filter.soldFilter) {
      case SoldFilter.sold:
        filtered = filtered.where((p) => p.isSold).toList();
      case SoldFilter.unsold:
        filtered = filtered.where((p) => !p.isSold).toList();
      case SoldFilter.all:
        break;
    }

    if (filter.wearGroup != null) {
      filtered = filtered.where((p) {
        return CategoryConstants.getWearGroup(p.category) == filter.wearGroup;
      }).toList();
    }

    if (filter.purchaseDateFrom != null) {
      filtered = filtered.where((p) {
        return p.purchaseDate.isAfter(filter.purchaseDateFrom!) ||
            p.purchaseDate.isAtSameMomentAs(filter.purchaseDateFrom!);
      }).toList();
    }

    if (filter.purchaseDateTo != null) {
      final endOfDay = DateTime(
        filter.purchaseDateTo!.year,
        filter.purchaseDateTo!.month,
        filter.purchaseDateTo!.day,
        23,
        59,
        59,
      );
      filtered = filtered.where((p) => p.purchaseDate.isBefore(endOfDay)).toList();
    }

    if (filter.minPrice != null) {
      filtered =
          filtered.where((p) => p.purchasePrice >= filter.minPrice!).toList();
    }

    if (filter.maxPrice != null) {
      filtered =
          filtered.where((p) => p.purchasePrice <= filter.maxPrice!).toList();
    }

    switch (filter.sortOrder) {
      case SortOrder.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SortOrder.oldest:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return filtered;
  }
}
