import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ffi' as ffiLib;
import 'package:ffi/ffi.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../printer/printer_manager.dart';
import '../../common/print_settings/provider/common_sdk_variable.dart';

/// ─── BT Scan ─────────────────────────────────
Future<List<String>> getDotBleResultFormSdk() async {
  if (Platform.isMacOS) {
    try {
      final devices = await PrinterManager.instance.scanBluetooth();
      return devices.map((d) => d.name).toList();
    } catch (e) {
      debugPrint("BLE scan error: $e");
      return [];
    }
  } else {
    final receivePort = ReceivePort();
    await Isolate.spawn(_dotBleScanIsolate, {'sendPort': receivePort.sendPort});
    final result = await receivePort.first;
    receivePort.close();
    return result is List<String> ? result : [];
  }
}

// windows isolate get scan list
void _dotBleScanIsolate(Map<String, dynamic> data) {
  final SendPort sendPort = data['sendPort'];
  try {
    final bindings = PrinterManager.instance.ffiBindings;
    final ptr = bindings.printerListCharBT();
    if (ptr.address == 0) {
      sendPort.send(<String>[]);
      return;
    }
    final raw = ptr.toDartString();
    bindings.freePrinterListChar(ptr);
    final list = raw
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim())
        .toList();
    sendPort.send(list);
  } catch (e) {
    debugPrint("Isolate BLE scan error: $e");
    sendPort.send(<String>[]);
  }
}

/// ─── BT Connect ─────────────────────────────────────
Future<int> setDotBTPrinterIsolated(int index, int maxWidth, int paperSize) async {
  if (Platform.isMacOS) {
    try {
      final success = await PrinterManager.instance.connectBluetooth(index, maxWidth: maxWidth);
      return success ? 0 : -1;
    } catch (e) {
      debugPrint("BT connect error: $e");
      return -1;
    }
  } else {
    final receivePort = ReceivePort();
    await Isolate.spawn(_setDotBTPrinterIsolate, {
      'sendPort': receivePort.sendPort,
      'index': index,
      'maxWidth': maxWidth,
      'paperSize': paperSize,
    });
    final result = await receivePort.first as int;
    receivePort.close();
    return result;
  }
}

// windows isolate set BT printer
void _setDotBTPrinterIsolate(Map<String, dynamic> data) {
  final SendPort sendPort = data['sendPort'];
  final int index = data['index'];
  final int maxWidth = data['maxWidth'];
  try {
    final bindings = PrinterManager.instance.ffiBindings;
    sendPort.send(bindings.setPrinterBT(index, maxWidth));
  } catch (e) {
    debugPrint("Isolate setBTPrinter error: $e");
    sendPort.send(-1);
  }
}

/// ───────────────────────────────────  Print section ───────────────────────────────────
Future<void> dotSendByteListToPrinterIsolated({
  required List<int> list,
  required int height,
  required int width,
  required int printHeight,
  required int printDirection,
  required int isBluetooth,
}) async {
  final printerContrastValue = isPrintSetting ? pPrinterContrastValue : lPrinterContrastValue;

  debugPrint("Dot isBluetooth isolated: $isBluetooth");
  debugPrint(
    "byteList length: ${list.length}, "
    "expected (h*w*3): ${height * width * 3}, "
    "height: $height, width: $width, printHeight: $printHeight",
  );

  // ✅ Step 1: Encoding → isolate (pure Dart, UI freeze নেই)
  final encoded = await _encodeInIsolate(
    list: list,
    height: height,
    width: width,
    contrast: printerContrastValue,
    paperHeight: printHeight,
    direction: printDirection,
  );

  if (encoded.isEmpty) {
    debugPrint("❌ Encoding failed — empty result");
    return;
  }
  debugPrint("📦 Encoded: ${encoded.length} bytes");

  // ✅ Step 2: Hardware send → main thread via microtask
  await Future.microtask(() {
    final bindings = PrinterManager.instance.ffiBindings;
    final ptr = calloc<ffiLib.Uint8>(encoded.length);
    try {
      ptr.asTypedList(encoded.length).setAll(0, encoded);
      if (isBluetooth == 1) {
        bindings.sendRawBluetooth(ptr, encoded.length);
      } else {
        bindings.sendRawUSB(ptr, encoded.length);
      }
    } finally {
      calloc.free(ptr);
    }
  });
}

/// ────────────────────────────────Isolate encode trigger ─────────────────────────
Future<Uint8List> _encodeInIsolate({
  required List<int> list,
  required int height,
  required int width,
  required int contrast,
  required int paperHeight,
  required int direction,
}) async {
  final receivePort = ReceivePort();
  final isolate = await Isolate.spawn(_encodeWorker, {
    'list': list,
    'height': height,
    'width': width,
    'contrast': contrast,
    'paperHeight': paperHeight,
    'direction': direction,
    'maxWidth': 1440,
    'sendPort': receivePort.sendPort,
  });

  final result = await receivePort.first;
  receivePort.close();
  isolate.kill(priority: Isolate.immediate);

  return result is Uint8List ? result : Uint8List(0);
}

/// ─────────────── Isolate worker ─────────────
void _encodeWorker(Map<String, dynamic> data) {
  final SendPort sendPort = data['sendPort'];

  try {
    final list = data['list'] as List<int>;
    final height = data['height'] as int;
    final width = data['width'] as int;
    final contrast = data['contrast'] as int;
    final paperHeight = data['paperHeight'] as int;
    final direction = data['direction'] as int;
    final maxWidth = data['maxWidth'] as int;

    // Step 1: RGB → binary
    final binary = <int>[];
    for (int i = 0; i < list.length; i += 3) {
      final r = list[i];
      final g = list[i + 1];
      final b = list[i + 2];
      final lum = (r * 0.3 + g * 0.59 + b * 0.11).toInt();
      binary.add(lum >= contrast ? 0 : 1);
    }

    // 16-row padding
    final remainder = height % 16;
    int finalHeight = height;
    if (remainder != 0) {
      final padRows = 16 - remainder;
      for (int i = 0; i < width * padRows; i++) {
        binary.add(0);
      }
      finalHeight = height + padRows;
    }

    // Step 2: ESC/P encode
    final bytes = <int>[];

    // Header
    final header = [
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
      direction == 1 ? 0x01 : 0x00,
      0x1B,
      0x89,
    ];
    bytes.addAll(header);

    // Paper height bytes
    bytes.add((paperHeight >> 8) & 0xFF); // nH
    bytes.add(paperHeight & 0xFF); // nL
    bytes.addAll([0x1B, 0xA0, 0x00]);

    // Width centering
    int extraLeft = 0;
    int extraRight = 0;
    if (width != maxWidth) {
      extraLeft = (maxWidth - width) ~/ 2;
      extraRight = extraLeft + (maxWidth - width) % 2;
    }

    // 16-row bit-packing
    for (int i = 0; i < finalHeight; i += 16) {
      bytes.addAll([0x1B, 0x2A, 0x01, 0x40, 0x0B]);

      // Odd rows (1, 3, 5, ...)
      bytes.addAll(List.filled(extraLeft, 0x00));
      for (int w = 0; w < width; w++) {
        int byteValue = 0;
        for (int h = i + 1; h < 17 + i; h += 2) {
          byteValue = (byteValue << 1) | binary[((h - 1) * width) + w];
        }
        bytes.add(byteValue);
      }
      bytes.addAll(List.filled(extraRight, 0x00));

      // Even rows (0, 2, 4, ...)
      bytes.addAll(List.filled(extraLeft, 0x00));
      for (int w = 0; w < width; w++) {
        int byteValue = 0;
        for (int h = i; h < 16 + i; h += 2) {
          byteValue = (byteValue << 1) | binary[(h * width) + w];
        }
        bytes.add(byteValue);
      }
      bytes.addAll(List.filled(extraRight, 0x00));

      bytes.addAll([0x1B, 0x4A, 0x10]);
    }

    // Footer
    bytes.addAll([0x0A, 0x1D, 0x56, 0x57]);

    sendPort.send(Uint8List.fromList(bytes));
  } catch (e) {
    debugPrint("Encode worker error: $e");
    sendPort.send(Uint8List(0));
  }
}
