import 'package:hive_flutter/hive_flutter.dart';
import 'package:xtacy_backoffice/core/constants/app_constants.dart';
import 'package:xtacy_backoffice/core/errors/failures.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';

/// Local cache layer using Hive for offline product access.
class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  Box<dynamic>? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(AppConstants.hiveBoxName);
  }

  Box<dynamic> get box {
    if (_box == null) {
      throw const CacheFailure('Hive not initialized');
    }
    return _box!;
  }

  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final jsonList = products.map((p) => p.toJson()).toList();
      await box.put(AppConstants.hiveProductsKey, jsonList);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  List<ProductModel> getCachedProducts() {
    try {
      final data = box.get(AppConstants.hiveProductsKey);
      if (data == null) return [];
      final list = data as List;
      return list
          .map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearCache() async {
    await box.clear();
  }
}
