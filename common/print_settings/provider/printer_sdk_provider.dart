import 'dart:async';
import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../utils/constants/colors.dart';
import '../../../localization/main_texts.dart';
import 'package:grozziie/utils/snackbar_toast/snack_bar.dart';
import '../../../printer/isolated_data/dot_sdk_isolated.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'common_sdk_variable.dart';
import '../../../printer/isolated_data/thermal_sdk_isolated.dart';
import '../../common_isolated_data.dart';
import 'package:grozziie/utils/constants/label_global_variable.dart';

class PrinterSdkProvider extends ChangeNotifier {
  // ─── Print State ─────────────────────────────────────────
  bool isPrinting = false;
  bool isCancelled = false;
  int currentPage = 0;
  int totalPages = 0;
  String? printError;

  /// Initialize printing with total count
  void initPrinting(int total) {
    isPrinting = true;
    isCancelled = false;
    currentPage = 0;
    totalPages = total;
    printError = null;
    notifyListeners();
  }

  /// Increment progress by 1
  void incrementProgress() {
    currentPage++;
    notifyListeners();
  }

  /// Cancel printing
  void cancelPrinting() {
    isCancelled = true;
    notifyListeners();
  }

  /// Complete printing
  void completePrinting({String? error}) {
    isPrinting = false;
    isCancelled = false;
    currentPage = 0;
    totalPages = 0;
    printError = error;
    notifyListeners();
  }

  // ────────────────────────Settings ──────────────────────
  void togglePrintSetting(bool value) {
    isPrintSetting = value;
    notifyListeners();
  }

  void setPrinterSpeed(int value) {
    isPrintSetting ? pPrinterSpeed = value : lPrinterSpeed = value;
    notifyListeners();
  }

  void setPrintDensity(int value) {
    isPrintSetting ? pPrintDensity = value : lPrintDensity = value;
    notifyListeners();
  }

  void setPrinterContrastValue(int value) {
    isPrintSetting ? pPrinterContrastValue = value : lPrinterContrastValue = value;
    notifyListeners();
  }

  void showFluentContrastDialog(BuildContext context) {
    final dTexts = DTexts.instance;

    int initialValue = isPrintSetting ? pPrinterContrastValue : lPrinterContrastValue;

    showDialog(
      context: context,
      builder: (context) {
        return ContentDialog(
          title: Center(child: Text(dTexts.selectContrastValue, style: context.title)),
          content: SizedBox(
            width: 400,
            height: 210,
            child: ListView.builder(
              itemExtent: 40,
              controller: ScrollController(initialScrollOffset: (initialValue - 1) * 40),
              itemCount: 250,
              itemBuilder: (context, index) {
                final value = index + 1;
                final isSelected = value == initialValue;
                return ListTile(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: isSelected ? DColors.primary : DColors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  title: Center(
                    child: Text('$value', style: context.body.copyWith(color: isSelected ? DColors.primary : null)),
                  ),
                  onPressed: () {
                    setPrinterContrastValue(value);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            Center(
              child: Button(child: Text(dTexts.save), onPressed: () => Navigator.pop(context)),
            ),
          ],
        );
      },
    );
  }

  // ────────────────────── Thermal Print ─────────────────────
  /// Thermal printer — unchanged (thermal SDK separate)
  Future<bool> thermalPrintToSdk({
    required Uint8List imageData,
    required int paperWidth,
    required int paperHeight,
  }) async {
    int copies = int.tryParse(isPrintSetting ? pPrinterCopy.text : lPrinterCopy.text) ?? 1;
    debugPrint('Printer Sdk copies: $copies');

    try {
      List<int> pixels = await receivedResizeDataToPixelsIsolated(
        imageData: imageData,
        width: paperWidth,
        height: paperHeight,
      );

      for (int i = 0; i < copies; i++) {
        if (isCancelled) return false;
        incrementProgress();

        debugPrint('Sdk Thermal Paper Width: $paperWidth and Paper Height: $paperHeight');
        debugPrint('Preparation next print');
        await Future.delayed(const Duration(milliseconds: 120));

        await thermalSendByteListToPrinterIsolated(
          list: pixels,
          width: paperWidth,
          height: paperHeight,
          isBluetooth: connectivityType,
        );

        debugPrint('Waiting for printer free handle');
        await Future.delayed(const Duration(milliseconds: 120));
      }

      return true;
    } catch (e) {
      DSnackBar.errorSnackBar(title: 'Print Error', message: e.toString());
      return false;
    }
  }

  // ─────────────────────── Dot Print ────────────────────────
  /// ✅ Updated: encoding Dart isolate এ, send FFI main thread এ
  Future<bool> dotPrintToSdk({
    required Uint8List imageData,
    required int paperWidth,
    required int paperHeight,
    required int printH,
  }) async {
    int copies = int.tryParse(isPrintSetting ? pPrinterCopy.text : lPrinterCopy.text) ?? 1;

    try {
      // ✅ Step 1: image → RGB pixels (isolate safe)
      List<int> pixels = await receivedResizeDataToPixelsIsolated(
        imageData: imageData,
        width: paperWidth,
        height: paperHeight,
      );

      debugPrint('Start - Total prints: $copies');

      for (int i = 0; i < copies; i++) {
        if (isCancelled) return false;
        incrementProgress();

        debugPrint(
          'Processed Page ${i + 1}: '
          'Width: $paperWidth, Height: $paperHeight',
        );
        debugPrint('Sdk Dot Paper Width: $paperWidth and Paper Height: $paperHeight');
        debugPrint('Preparation next print');

        await Future.delayed(const Duration(milliseconds: 120));

        // ✅ Step 2: encode (isolate) + send (main thread)
        await dotSendByteListToPrinterIsolated(
          list: pixels,
          height: paperHeight,
          width: paperWidth,
          printHeight: printH,
          printDirection: 0,
          isBluetooth: connectivityType,
        );

        debugPrint('Waiting for printer free handle');
        await Future.delayed(const Duration(milliseconds: 120));
      }

      return true;
    } catch (e) {
      DSnackBar.errorSnackBar(title: 'Print Error', message: e.toString());
      return false;
    }
  }
}
