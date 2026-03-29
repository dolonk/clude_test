enum PrinterConnectionType { usb, bluetooth, wifi }

class PrinterDevice {
  final int index;
  final String name;
  final String id;
  final PrinterConnectionType type;

  const PrinterDevice({required this.index, required this.name, required this.id, required this.type});
}
