import 'printer_device.dart';

class PrintJob {
  final List<int> rgbBytes;
  final int width;
  final int height;
  final int contrast;
  final int paperHeight;
  final int direction;
  final int maxWidth;
  final PrinterConnectionType connectionType;

  const PrintJob({
    required this.rgbBytes,
    required this.width,
    required this.height,
    required this.connectionType,
    this.contrast = 128,
    this.paperHeight = 279,
    this.direction = 0,
    this.maxWidth = 1440,
  });
}
