import 'dart:typed_data';
import 'printer_config.dart';

class DotMatrixProtocol {
  /// Binary image → ESC/P command bytes
  /// isolate safe — pure Dart, no platform calls
  static Uint8List encode(List<int> binarize, int height, int width, int maxWidth, int paperHeight, int direction) {
    final bytes = <int>[];

    // ── Header ──────────────────────────────────────
    bytes.addAll(PrinterConfig.buildHeader(direction));

    // ── Paper height bytes ───────────────────────────
    bytes.add((paperHeight >> 8) & 0xFF); // nH
    bytes.add(paperHeight & 0xFF); // nL
    bytes.addAll([0x1B, 0xA0, 0x00]);

    // ── Width centering ──────────────────────────────
    int extraLeft = 0;
    int extraRight = 0;
    if (width != maxWidth) {
      extraLeft = (maxWidth - width) ~/ 2;
      extraRight = extraLeft + (maxWidth - width) % 2;
    }

    // ── 16-row bit-packing ───────────────────────────
    for (int i = 0; i < height; i += 16) {
      bytes.addAll([0x1B, 0x2A, 0x01, 0x40, 0x0B]);

      // 1st: odd rows (1, 3, 5, ...)
      bytes.addAll(List.filled(extraLeft, 0x00));
      for (int w = 0; w < width; w++) {
        int byteValue = 0;
        for (int h = i + 1; h < 17 + i; h += 2) {
          byteValue = (byteValue << 1) | binarize[((h - 1) * width) + w];
        }
        bytes.add(byteValue);
      }
      bytes.addAll(List.filled(extraRight, 0x00));

      // 2nd: even rows (0, 2, 4, ...)
      bytes.addAll(List.filled(extraLeft, 0x00));
      for (int w = 0; w < width; w++) {
        int byteValue = 0;
        for (int h = i; h < 16 + i; h += 2) {
          byteValue = (byteValue << 1) | binarize[(h * width) + w];
        }
        bytes.add(byteValue);
      }
      bytes.addAll(List.filled(extraRight, 0x00));

      bytes.addAll([0x1B, 0x4A, 0x10]);
    }

    // ── Footer ───────────────────────────────────────
    bytes.addAll([0x0A, 0x1D, 0x56, 0x57]);

    return Uint8List.fromList(bytes);
  }
}
