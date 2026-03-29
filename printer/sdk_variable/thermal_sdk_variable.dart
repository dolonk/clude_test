import 'dart:io';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;
import 'package:fluent_ui/fluent_ui.dart';

///       /*------------------------------------- Thermal printer sdk --------------------------------- */
String thermalGetDllPath() {
  final executableDir = path.dirname(Platform.resolvedExecutable);

  if (Platform.isMacOS) {
    final dylibPath = path.join(executableDir, '..', 'Frameworks', 'universal.dylib');
    debugPrint("Thermal dylib path (macOS): $dylibPath");
    return dylibPath;
  } else {
    final dllPath = path.join(executableDir, 'ThermalPrinterSdk-CPP.dll');
    debugPrint("Thermal DLL path (Windows): $dllPath");
    return dllPath;
  }
}

/// Load Sdk from File path
final myLibrary = ffi.DynamicLibrary.open(thermalGetDllPath());

/// get printer list char for USB
typedef PrinterListC = ffi.Pointer<Utf8> Function();
typedef PrinterListDart = ffi.Pointer<Utf8> Function();
final thermalPrinterListFunction = myLibrary.lookupFunction<PrinterListC, PrinterListDart>('PrinterListChar');

/// get printer list char for BLUETOOTH
final thermalBlePrinterListFunction = myLibrary.lookupFunction<PrinterListC, PrinterListDart>('PrinterListCharBT');

/// Initialise printer variable set & printer model
typedef SetPrinterC = ffi.Void Function(ffi.Int32 num, ffi.Int32 maxWidth);
typedef SetPrinterDart = void Function(int num, int maxWidth);
final thermalSetPrinter = myLibrary.lookupFunction<SetPrinterC, SetPrinterDart>('setPrinter');

/// set Printer device for BLUETOOTH
typedef ThermalBleSetPrinterPaperSizeC = ffi.Uint8 Function(ffi.Int32 num, ffi.Int32 maxWidth);
typedef ThermalSetBlePrinterPaperSizeDart = int Function(int num, int maxWidth);
final thermalBleSetPrinter = myLibrary.lookupFunction<ThermalBleSetPrinterPaperSizeC, ThermalSetBlePrinterPaperSizeDart>(
  'setPrinterBT',
);

/// variable for Send Data list to printer
// Native C signature
typedef ThermalSendByteListC =
    ffi.Void Function(
      ffi.Pointer<ffi.Int32> byteList,
      ffi.Int32 height,
      ffi.Int32 width,
      ffi.Int32 speed,
      ffi.Int32 density,
      ffi.Int32 contrast,
      ffi.Uint8 isBluetooth,
    );

// Dart-side callable signature
typedef ThermalSendByteListDart =
    void Function(
      ffi.Pointer<ffi.Int32> byteList,
      int height,
      int width,
      int speed,
      int density,
      int contrast,
      int isBluetooth,
    );

final thermalSendByteListWithSettingsCMN = myLibrary.lookupFunction<ThermalSendByteListC, ThermalSendByteListDart>(
  'sendByteListWithSettingsCMN',
);
