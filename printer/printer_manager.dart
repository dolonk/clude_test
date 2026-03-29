import 'models/print_job.dart';
export 'models/print_job.dart';
import 'core/image_processor.dart';
import 'models/printer_device.dart';
export 'models/printer_device.dart';
import 'core/dot_matrix_protocol.dart';
import 'ffi/printer_ffi_bindings.dart';
import 'package:flutter/foundation.dart';
import 'connection/usb_printer_connection.dart';
import 'connection/wifi_printer_connection.dart';
import 'connection/bluetooth_printer_connection.dart';
export 'connection/wifi_printer_connection.dart' show PrinterException;

class PrinterManager {
  // ──────────────────── Singleton ───────────────────────────
  static PrinterManager? _instance;
  static PrinterManager get instance => _instance ??= PrinterManager._();

  late final PrinterFfiBindings _ffi;
  late final UsbPrinterConnection _usb;
  late final BluetoothPrinterConnection _bluetooth;
  WifiPrinterConnection? _wifi;

  // Exposed for dot_sdk_isolated.dart direct FFI access
  PrinterFfiBindings get ffiBindings => _ffi;

  PrinterManager._() {
    _ffi = PrinterFfiBindings();
    _usb = UsbPrinterConnection(_ffi);
    _bluetooth = BluetoothPrinterConnection(_ffi);
  }

  // ──────────────────── SDK Verify ─────────────────────────
  /// Call on app start — if "Hello, World!" prints, SDK connected
  void hello() => _ffi.hello();

  // ───────────────────────── Scan ───────────────────
  Future<List<PrinterDevice>> scanUsb() => _usb.scanDevices();
  Future<List<PrinterDevice>> scanBluetooth() => _bluetooth.scanDevices();

  // ──────────────────── Connect ────────────────────────────
  Future<void> connectUsb(int index, {int maxWidth = 1440}) => _usb.connect(index, maxWidth);

  Future<bool> connectBluetooth(int index, {int maxWidth = 1440}) => _bluetooth.connect(index, maxWidth);

  void setWifi(String ipAddress, {int port = 9100}) {
    _wifi = WifiPrinterConnection(ipAddress: ipAddress, port: port);
  }

  // ──────────────────── Print section ─────────────────────────────
  Future<void> print(PrintJob job) async {
    // Step 1: Heavy computation
    final encoded = await compute(_processAndEncode, {
      'rgbBytes': job.rgbBytes,
      'width': job.width,
      'height': job.height,
      'contrast': job.contrast,
      'paperHeight': job.paperHeight,
      'direction': job.direction,
      'maxWidth': job.maxWidth,
    });

    // Step 2: Hardware send → main isolate via microtask
    switch (job.connectionType) {
      case PrinterConnectionType.usb:
        await _usb.sendBytes(encoded);
      case PrinterConnectionType.bluetooth:
        await _bluetooth.sendBytes(encoded);
      case PrinterConnectionType.wifi:
        if (_wifi == null) {
          throw PrinterException('WiFi printer not configured. Call setWifi() first.');
        }
        await _wifi!.sendBytes(encoded);
    }
  }

  // ──────────────────── Cleanup ───────────────────────────
  void dispose() {
    _ffi.freeMemory();
  }
}

// ──────────────────── Isolate Worker ─────────────────────
Uint8List _processAndEncode(Map<String, dynamic> args) {
  // Step 1: RGB → binary
  final result = ImageProcessor.process(
    args['rgbBytes'] as List<int>,
    args['height'] as int,
    args['width'] as int,
    args['contrast'] as int,
  );

  // Step 2: binary → ESC/P bytes
  return DotMatrixProtocol.encode(
    result.data,
    result.height,
    result.width,
    args['maxWidth'] as int,
    args['paperHeight'] as int,
    args['direction'] as int,
  );
}
