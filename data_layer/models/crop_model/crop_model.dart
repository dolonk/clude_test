import 'dart:typed_data';

class CropModel {
  final Uint8List image;
  final double x;
  final double y;
  final double width;
  final double height;

  CropModel({
    required this.image,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  @override
  String toString() {
    return "CropModel(image: ${image.length} bytes, x: $x, y: $y, width: $width, height: $height)";
  }
}
