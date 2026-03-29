import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import '../ffi/printer_ffi_bindings.dart';
import '../models/printer_device.dart';

class UsbPrinterConnection {
  final PrinterFfiBindings _ffi;

  UsbPrinterConnection(this._ffi);

  /// Scan connected USB printers
  /// Returns list of PrinterDevice
  Future<List<PrinterDevice>> scanDevices() async {
    return await Future.microtask(() {
      final ptr = _ffi.printerListChar();
      if (ptr == nullptr) return [];

      final raw = ptr.toDartString();
      _ffi.freePrinterListChar(ptr);

      if (raw.trim().isEmpty) return [];

      return raw
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList()
          .asMap()
          .entries
          .map((e) => PrinterDevice(index: e.key, name: e.value, id: e.value, type: PrinterConnectionType.usb))
          .toList();
    });
  }

  /// Select USB printer by index
  Future<void> connect(int index, int maxWidth) async {
    await Future.microtask(() {
      _ffi.setPrinter(index, maxWidth);
    });
  }

  /// Send pre-encoded ESC/P bytes via USB
  Future<void> sendBytes(Uint8List bytes) async {
    await Future.microtask(() {
      final ptr = calloc<Uint8>(bytes.length);
      try {
        ptr.asTypedList(bytes.length).setAll(0, bytes);
        _ffi.sendRawUSB(ptr, bytes.length);
      } finally {
        calloc.free(ptr);
      }
    });
  }
}
