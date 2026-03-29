class PrinterConfig {
  static const int defaultMaxWidth = 1440;
  static const int defaultContrast = 128;
  static const int defaultPaperHeight = 279; // 279mm = 11 inch
  static const int defaultDirection = 0;

  // macOS ESC/P header bytes
  static const List<int> _headerBytes = [
    0x1B,
    0x01,
    0x40,
    0x53,
    0x4D,
    0x38,
    0x38,
    0x30,
    0x0A,
    0xFF,
    0xFF,
    0x0A,
    0x0A,
    0x1B,
    0x55,
    0x01,
    0x1B,
    0x89,
  ];

  /// direction 0 = both sides, 1 = single side
  static List<int> buildHeader(int direction) {
    final header = List<int>.from(_headerBytes);
    header[15] = direction == 1 ? 0x01 : 0x00;
    return header;
  }
}
