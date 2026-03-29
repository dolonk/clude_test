import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;

const int compressionQuality = 85;
const int maxFileSizeBytes = 1 * 1024 * 1024;

Future<Uint8List> compressImageIfNeeded(Uint8List fileBytes) async {
  final originalSize = fileBytes.length;
  // 500KB check
  const int limit = 500 * 1024;

  if (originalSize <= limit) {
    debugPrint('📷 Image size within 500KB limit - no compression needed');
    return fileBytes;
  }

  debugPrint('📷 Image size exceeds 500KB - compressing...');

  try {
    final image = img.decodeImage(fileBytes);
    if (image == null) return fileBytes;

    Uint8List compressedBytes = fileBytes;
    int quality = 85; // Initial quality
    double scaleFactor = 0.9;

    // Loop ta cholbe jotokkhon image size limit er niche na ashe
    while (compressedBytes.length > limit && scaleFactor > 0.2) {
      final resizedImage = img.copyResize(
        image,
        width: (image.width * scaleFactor).round(),
        interpolation: img.Interpolation.linear,
      );

      // Quality and scale factor eksathe komanu hocche fast compression er jonno
      compressedBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: quality),
      );

      scaleFactor -= 0.1;
      if (quality > 40) quality -= 10;
    }

    debugPrint(
      '✅ Compression Done! Final Size: ${(compressedBytes.length / 1024).toStringAsFixed(2)} KB',
    );
    return compressedBytes;
  } catch (e) {
    debugPrint('⚠️ Error: $e');
    return fileBytes;
  }
}
