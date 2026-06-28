import 'dart:io';

import 'package:xtacy_backoffice/data/services/storage_service.dart';

/// Repository for Supabase Storage image operations.
class StorageRepository {
  StorageRepository({
    StorageService? storageService,
  }) : _storageService = storageService ?? StorageService();

  final StorageService _storageService;

  Future<String> uploadProductImage({
    required String productId,
    required File imageFile,
  }) {
    return _storageService.uploadProductImage(
      productId: productId,
      imageFile: imageFile,
    );
  }

  Future<void> deleteProductImage(String productId) {
    return _storageService.deleteProductImage(productId);
  }
}
