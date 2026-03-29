import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// ── Native typedefs ──────────────────────────────────────
typedef _VoidFuncC = Void Function();
typedef _VoidFuncDart = void Function();

typedef _GetListC = Pointer<Utf8> Function();
typedef _GetListDart = Pointer<Utf8> Function();

typedef _SetPrinterC = Void Function(Int32, Int32);
typedef _SetPrinterDart = void Function(int, int);

typedef _SetPrinterBTC = Int32 Function(Int32, Int32);
typedef _SetPrinterBTDart = int Function(int, int);

typedef _SendRawC = Void Function(Pointer<Uint8>, Int32);
typedef _SendRawDart = void Function(Pointer<Uint8>, int);

typedef _FreeCharC = Void Function(Pointer<Utf8>);
typedef _FreeCharDart = void Function(Pointer<Utf8>);

// ── Bindings ─────────────────────────────────────────────
class PrinterFfiBindings {
  late final DynamicLibrary _lib;

  // SDK verify
  late final _VoidFuncDart hello;

  // USB
  late final _GetListDart printerListChar;
  late final _SetPrinterDart setPrinter;
  late final _SendRawDart sendRawUSB;

  // Bluetooth
  late final _GetListDart printerListCharBT;
  late final _SetPrinterBTDart setPrinterBT;
  late final _SendRawDart sendRawBluetooth;

  // Memory
  late final _FreeCharDart freePrinterListChar;
  late final _VoidFuncDart freeMemory;

  PrinterFfiBindings() {
    _lib = _loadLibrary();
    _bind();
  }

  DynamicLibrary _loadLibrary() {
    if (Platform.isMacOS) {
      // App bundle Frameworks path
      final appDir = File(Platform.resolvedExecutable).parent.path;
      final dylibPath = '$appDir/../Frameworks/libDotPrinterSdk-mac.dylib';
      return DynamicLibrary.open(dylibPath);
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('DotPrinterSdk.dll');
    }
    throw UnsupportedError('Platform not supported: ${Platform.operatingSystem}');
  }

  void _bind() {
    hello = _lib.lookup<NativeFunction<_VoidFuncC>>('hello').asFunction();

    printerListChar = _lib.lookup<NativeFunction<_GetListC>>('printerListChar').asFunction();

    setPrinter = _lib.lookup<NativeFunction<_SetPrinterC>>('setPrinter').asFunction();

    sendRawUSB = _lib.lookup<NativeFunction<_SendRawC>>('sendRawUSB').asFunction();

    printerListCharBT = _lib.lookup<NativeFunction<_GetListC>>('printerListCharBT').asFunction();

    setPrinterBT = _lib.lookup<NativeFunction<_SetPrinterBTC>>('setPrinterBT').asFunction();

    sendRawBluetooth = _lib.lookup<NativeFunction<_SendRawC>>('sendRawBluetooth').asFunction();

    freePrinterListChar = _lib.lookup<NativeFunction<_FreeCharC>>('freePrinterListChar').asFunction();

    freeMemory = _lib.lookup<NativeFunction<_VoidFuncC>>('freeMemory').asFunction();
  }
}
