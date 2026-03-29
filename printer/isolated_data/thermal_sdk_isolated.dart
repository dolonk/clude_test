import 'dart:io';
import 'dart:isolate';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import '../../common/print_settings/provider/common_sdk_variable.dart';
import '../sdk_variable/thermal_sdk_variable.dart';

Future<List<String>> getThermalBleResultFormSdk() async {
  if (Platform.isMacOS) {
    try {
      final pointer = thermalBlePrinterListFunction();
      if (pointer.address == 0) return [];

      final printersBle = pointer.toDartString();
      debugPrint("printersBle (Main Thread): $printersBle");

      if (printersBle.isEmpty) return [];

      return printersBle
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .map((s) => s.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim())
          .toList();
    } catch (e) {
      debugPrint("Main Thread BLE fetch error: $e");
      return [];
    }
  } else {
    final receivePort = ReceivePort();

    await Isolate.spawn(_thermalByteListToPrinterIsolate, {
      'sendPort': receivePort.sendPort,
    });

    final result = await receivePort.first;
    receivePort.close();

    if (result is List<String>) {
      return result;
    } else {
      return [];
    }
  }
}

void _thermalByteListToPrinterIsolate(Map<String, dynamic> data) {
  final SendPort sendPort = data['sendPort'];

  try {
    // Call the SDK FFI function
    final pointer = thermalBlePrinterListFunction();
    final printersBle = pointer.toDartString();

    // Split the string into list of printer names (example logic)
    List<String> printerList = printersBle.split(', ');

    // Return result back to main isolate
    sendPort.send(printerList);
  } catch (e) {
    debugPrint("Isolate BLE fetch error: $e");
    sendPort.send([]);
  }
}

/// thermal Set printer for BLUETOOTH
Future<int> setThermalBTPrinterIsolated(int num, int maxWidth) async {
  final receivePort = ReceivePort();

  await Isolate.spawn(_setThermalBTPrinterIsolate, {
    'sendPort': receivePort.sendPort,
    'num': num,
    'maxWidth': maxWidth,
  });

  final result = await receivePort.first as int;
  return result;
}

void _setThermalBTPrinterIsolate(Map<String, dynamic> data) {
  final SendPort sendPort = data['sendPort'];
  final int printerNum = data['num'];
  final int maxWidth = data['maxWidth'];

  try {
    final result = thermalBleSetPrinter(printerNum, maxWidth);
    sendPort.send(result);
  } catch (e) {
    debugPrint("Isolate setBTPrinter error: $e");
    sendPort.send([]);
  }
}

/// thermal Send byte list to printer with settings
Future<void> thermalSendByteListToPrinterIsolated({
  required List<int> list,
  required int width,
  required int height,
  required int isBluetooth,
}) async {
  final receivePort = ReceivePort();

  // Start the isolate with the isolated function
  final isolate = await Isolate.spawn(_thermalSendByteListToPrinterIsolate, {
    'list': list,
    'height': height,
    'width': width,
    'isBluetooth': isBluetooth,

    // global parameter
    'isPrintSetting': isPrintSetting,
    'dPrinterSpeed': pPrinterSpeed,
    'lPrinterSpeed': lPrinterSpeed,
    'dPrintDensity': pPrintDensity,
    'lPrintDensity': lPrintDensity,
    'dPrinterContrastValue': pPrinterContrastValue,
    'lPrinterContrastValue': lPrinterContrastValue,
    'sendPort': receivePort.sendPort,
  });

  // Wait for the completion signal from the isolate
  await receivePort.first;

  // Clean up
  receivePort.close();
  isolate.kill(priority: Isolate.immediate);
}

void _thermalSendByteListToPrinterIsolate(Map<String, dynamic> data) {
  final List<int> list = data['list'];
  final int height = data['height'];
  final int width = data['width'];
  final int isBluetooth = data['isBluetooth'];

  /// global parameter
  final bool isPrintSetting = data['isPrintSetting'];
  final int dPrinterSpeed = data['dPrinterSpeed'];
  final int lPrinterSpeed = data['lPrinterSpeed'];
  final int dPrintDensity = data['dPrintDensity'];
  final int lPrintDensity = data['lPrintDensity'];
  final int dPrinterContrastValue = data['dPrinterContrastValue'];
  final int lPrinterContrastValue = data['lPrinterContrastValue'];
  final SendPort sendPort = data['sendPort'];

  // Allocate memory for the list
  final pointer = calloc<ffi.Int32>(list.length);
  try {
    // Copy list values into the allocated memory
    for (var i = 0; i < list.length; i++) {
      pointer[i] = list[i];
    }

    // Set the printer parameters based on isPrintSetting
    final printerSpeed = isPrintSetting ? dPrinterSpeed : lPrinterSpeed;
    final printDensity = isPrintSetting ? dPrintDensity : lPrintDensity;
    final printerContrastValue = isPrintSetting
        ? dPrinterContrastValue
        : lPrinterContrastValue;
    debugPrint("Thermal SDK Isolated isBluetooth: $isBluetooth");

    // Call the sendByteList function with allocated pointer and settings
    thermalSendByteListWithSettingsCMN(
      pointer,
      height,
      width,
      printerSpeed,
      printDensity,
      printerContrastValue,
      isBluetooth,
    );
  } catch (e) {
    debugPrint("Error in isolate: $e");
  } finally {
    // Free the allocated memory
    calloc.free(pointer);

    // Signal the main thread that processing is complete
    sendPort.send(null);
  }
}
