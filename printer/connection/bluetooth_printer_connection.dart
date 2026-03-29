import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import '../ffi/printer_ffi_bindings.dart';
import '../models/printer_device.dart';

class BluetoothPrinterConnection {
  final PrinterFfiBindings _ffi;

  BluetoothPrinterConnection(this._ffi);

  /// Scan visible/paired Bluetooth printers
  Future<List<PrinterDevice>> scanDevices() async {
    return await Future.microtask(() {
      final ptr = _ffi.printerListCharBT();
      if (ptr == nullptr) return [];

      final raw = ptr.toDartString();
      _ffi.freePrinterListChar(ptr);

      if (raw.trim().isEmpty) return [];

      return raw
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList()
          .asMap()
          .entries
          .map(
            (e) => PrinterDevice(
              index: e.key,
              name: e.value.trim(),
              id: e.value.trim(),
              type: PrinterConnectionType.bluetooth,
            ),
          )
          .toList();
    });
  }

  /// Pair and connect to BT printer by index
  /// Returns true on success
  Future<bool> connect(int index, int maxWidth) async {
    return await Future.microtask(() {
      final result = _ffi.setPrinterBT(index, maxWidth);
      return result == 0;
    });
  }

  /// Send pre-encoded ESC/P bytes via RFCOMM
  Future<void> sendBytes(Uint8List bytes) async {
    await Future.microtask(() {
      final ptr = calloc<Uint8>(bytes.length);
      try {
        ptr.asTypedList(bytes.length).setAll(0, bytes);
        _ffi.sendRawBluetooth(ptr, bytes.length);
      } finally {
        calloc.free(ptr);
      }
    });
  }
}
