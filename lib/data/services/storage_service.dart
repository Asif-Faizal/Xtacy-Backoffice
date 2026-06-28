import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xtacy_backoffice/core/constants/supabase_constants.dart';
import 'package:xtacy_backoffice/core/errors/failures.dart';
import 'package:xtacy_backoffice/core/utils/image_compressor.dart';

/// Uploads product images to Supabase Storage (free tier — no Firebase Blaze needed).
class StorageService {
  StorageService({SupabaseClient? client}) : _clientOverride = client;

  final SupabaseClient? _clientOverride;

  String get _bucket => SupabaseConstants.productImagesBucket;

  /// Lazily resolves the client — never touches [Supabase.instance] at construction.
  SupabaseClient _requireClient() {
    if (_clientOverride != null) return _clientOverride;
    if (!SupabaseConstants.isConfigured) {
      throw const StorageFailure(
        'Supabase is not configured. Set url and anonKey in supabase_constants.dart',
      );
    }
    return Supabase.instance.client;
  }

  Future<String> uploadProductImage({
    required String productId,
    required File imageFile,
  }) async {
    final client = _requireClient();

    try {
      final compressed = await ImageCompressor.compress(imageFile);
      final fileToUpload = compressed ?? imageFile;
      final path = '$productId.jpg';

      await client.storage.from(_bucket).upload(
            path,
            fileToUpload,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      return client.storage.from(_bucket).getPublicUrl(path);
    } on StorageException catch (e) {
      throw StorageFailure(e.message);
    } catch (e) {
      throw StorageFailure(e.toString());
    }
  }

  Future<void> deleteProductImage(String productId) async {
    if (!SupabaseConstants.isConfigured) return;

    try {
      final client = _requireClient();
      await client.storage.from(_bucket).remove(['$productId.jpg']);
    } on StorageFailure {
      return;
    } on StorageException catch (e) {
      if (e.statusCode != '404') {
        throw StorageFailure(e.message);
      }
    }
  }
}
