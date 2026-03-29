class ImageProcessorResult {
  final List<int> data;
  final int width;
  final int height;

  const ImageProcessorResult({required this.data, required this.width, required this.height});
}

class ImageProcessor {
  /// RGB bytes → binary (0/1) + 16-row height padding
  /// isolate safe — pure Dart, no platform calls
  static ImageProcessorResult process(List<int> rgbBytes, int height, int width, int contrast) {
    final data = <int>[];
    data.length = 0;

    // Step 1: RGB → binary using luminosity formula
    // lum = 0.3*R + 0.59*G + 0.11*B
    for (int i = 0; i < rgbBytes.length; i += 3) {
      final r = rgbBytes[i];
      final g = rgbBytes[i + 1];
      final b = rgbBytes[i + 2];
      final lum = (r * 0.3 + g * 0.59 + b * 0.11).toInt();
      data.add(lum >= contrast ? 0 : 1);
    }

    // Step 2: Pad height to multiple of 16 (dot-matrix requirement)
    final remainder = height % 16;
    int finalHeight = height;

    if (remainder != 0) {
      final padRows = 16 - remainder;
      for (int i = 0; i < width * padRows; i++) {
        data.add(0);
      }
      finalHeight = height + padRows;
    }

    return ImageProcessorResult(data: data, width: width, height: finalHeight);
  }
}
