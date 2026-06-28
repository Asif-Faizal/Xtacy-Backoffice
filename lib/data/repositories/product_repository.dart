import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:xtacy_backoffice/core/constants/app_constants.dart';
import 'package:xtacy_backoffice/core/constants/category_constants.dart';
import 'package:xtacy_backoffice/data/models/inventory_filter.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';
import 'package:xtacy_backoffice/data/repositories/storage_repository.dart';
import 'package:xtacy_backoffice/data/services/firestore_service.dart';
import 'package:xtacy_backoffice/data/services/product_code_service.dart';

/// Repository for product CRUD and inventory operations.
class ProductRepository {
  ProductRepository({
    FirestoreService? firestoreService,
    ProductCodeService? productCodeService,
    StorageRepository? storageRepository,
    Uuid? uuid,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _productCodeService = productCodeService ?? ProductCodeService(),
        _storageRepository = storageRepository ?? StorageRepository(),
        _uuid = uuid ?? const Uuid();

  final FirestoreService _firestoreService;
  final ProductCodeService _productCodeService;
  final StorageRepository _storageRepository;
  final Uuid _uuid;

  Future<List<ProductModel>> getAllProducts() =>
      _firestoreService.getAllProducts();

  Future<ProductModel?> getProduct(String id) =>
      _firestoreService.getProduct(id);

  List<ProductModel> applyFilter(
    List<ProductModel> products,
    InventoryFilter filter,
  ) =>
      _firestoreService.applyFilter(products, filter);

  Future<ProductModel> createProduct({
    required String productName,
    required String category,
    required String colour,
    required String size,
    String? sleeveType,
    required DateTime purchaseDate,
    required double purchasePrice,
    double? sellingPrice,
    String? notes,
    required String merchantName,
    required String userId,
    File? imageFile,
    String gender = AppConstants.defaultGender,
  }) async {
    final productId = _uuid.v4();
    final productCode = await _productCodeService.generateNextCode();
    final now = DateTime.now();

    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _storageRepository.uploadProductImage(
        productId: productId,
        imageFile: imageFile,
      );
    }

    final product = ProductModel(
      id: productId,
      createdAt: now,
      updatedAt: now,
      createdBy: userId,
      updatedBy: userId,
      productCode: productCode,
      productName: productName,
      category: category,
      gender: gender,
      purchaseDate: purchaseDate,
      merchantName: merchantName,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      isSold: false,
      imageUrl: imageUrl,
      sleeveType: CategoryConstants.requiresSleeveType(category)
          ? sleeveType
          : null,
      colour: colour,
      size: size,
      quantity: AppConstants.defaultQuantity,
      notes: notes,
    );

    return _firestoreService.createProduct(product);
  }

  Future<ProductModel> updateProduct({
    required ProductModel product,
    required String userId,
    String? productName,
    String? category,
    String? colour,
    String? size,
    String? sleeveType,
    double? purchasePrice,
    double? sellingPrice,
    String? notes,
    File? imageFile,
    bool clearSleeveType = false,
  }) async {
    String? imageUrl = product.imageUrl;
    if (imageFile != null) {
      imageUrl = await _storageRepository.uploadProductImage(
        productId: product.id,
        imageFile: imageFile,
      );
    }

    final updatedCategory = category ?? product.category;
    final requiresSleeve = CategoryConstants.requiresSleeveType(updatedCategory);

    final updated = product.copyWith(
      updatedAt: DateTime.now(),
      updatedBy: userId,
      productName: productName,
      category: category,
      colour: colour,
      size: size,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      notes: notes,
      imageUrl: imageUrl,
      sleeveType: requiresSleeve
          ? (clearSleeveType ? null : sleeveType ?? product.sleeveType)
          : null,
      clearSleeveType: !requiresSleeve,
    );

    return _firestoreService.updateProduct(updated);
  }

  Future<ProductModel> markAsSold({
    required ProductModel product,
    required String userId,
    required String customerName,
    required String customerPhone,
    required double soldPrice,
    required DateTime soldDate,
    String? notes,
  }) async {
    final updated = product.copyWith(
      updatedAt: DateTime.now(),
      updatedBy: userId,
      isSold: true,
      soldPrice: soldPrice,
      soldDate: soldDate,
      customerName: customerName,
      customerPhone: customerPhone,
      notes: notes ?? product.notes,
    );

    return _firestoreService.updateProduct(updated);
  }

  Future<void> deleteProduct(String productId) async {
    await _firestoreService.deleteProduct(productId);
    await _storageRepository.deleteProductImage(productId);
  }
}
