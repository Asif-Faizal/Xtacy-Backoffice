import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// Compresses images before uploading to Firebase Storage.
class ImageCompressor {
  ImageCompressor._();

  static Future<File?> compress(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 75,
      minWidth: 1200,
      minHeight: 1200,
      format: CompressFormat.jpeg,
    );

    if (result == null) return null;
    return File(result.path);
  }
}
