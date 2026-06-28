import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:xtacy_backoffice/core/errors/failures.dart';
import 'package:xtacy_backoffice/core/utils/image_compressor.dart';

/// Handles image uploads to Firebase Storage with compression.
class StorageService {
  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadProductImage({
    required String productId,
    required File imageFile,
  }) async {
    try {
      final compressed = await ImageCompressor.compress(imageFile);
      final fileToUpload = compressed ?? imageFile;

      final ref = _storage.ref().child('products/$productId.jpg');
      await ref.putFile(
        fileToUpload,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw StorageFailure(e.message ?? 'Failed to upload image');
    } catch (e) {
      throw StorageFailure(e.toString());
    }
  }

  Future<void> deleteProductImage(String productId) async {
    try {
      final ref = _storage.ref().child('products/$productId.jpg');
      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') {
        throw StorageFailure(e.message ?? 'Failed to delete image');
      }
    }
  }
}
