import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../common/clipboard_service/clipboard_service.dart';
import '../common/common_function_provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../../../../utils/extension/global_context.dart';
import '../../../../../common/redo_undo/undo_redo_manager.dart';
import '../../../../../utils/constants/label_global_variable.dart';
import 'package:grozziie/utils/local_storage/local_data.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../../data_layer/models/redo_undo_model/barcode_state.dart';

class BarcodeProvider extends ChangeNotifier {
  CommonFunctionProvider commonModel = CommonFunctionProvider();
  Timer? _debounce;

  final List<String> supportedEncodingTypes = [
    'Code128',
    'UPC-A',
    'EAN-8',
    'EAN-13',
    'Code93',
    'Code39',
    'CodeBar',
  ];
  double minWidthBarcode4Chars = 100.0;
  double maxWidthFor28Chars = 500.0;
  double minBarcodeHeight = 50.0;
  bool _isCheckedSerialNumber = false;
  bool get isCheckedSerialNumber => _isCheckedSerialNumber;
  int _pasteCount = 0;

  BarcodeProvider() {
    _getLocalData();
  }

  void _getLocalData() async {
    _isCheckedSerialNumber =
        await LocalData.getLocalData<bool>("isCheckedSerialNumber") ?? false;
  }

  /// ==================== UNDO / REDO ====================
  void saveCurrentBarcodeState() {
    final context = GlobalContext.context;
    if (context == null) return;

    final snapshot = BarcodeState(
      barCodes: List.from(barCodes),
      barCodeOffsets: List.from(barCodeOffsets),
      barCalculatedWidth: List.from(barCalculatedWidth),
      brFocusNodes: List.from(brFocusNodes),
      barcodeControllers: List.from(barcodeControllers),
      updateBarcodeWidth: List.from(updateBarcodeWidth),
      updateBarcodeHeight: List.from(updateBarcodeHeight),

      barEncodingType: List.from(barEncodingType),
      barTextBold: List.from(barTextBold),
      barTextItalic: List.from(barTextItalic),
      barTextUnderline: List.from(barTextUnderline),
      barTextStrikeThrough: List.from(barTextStrikeThrough),
      barTextFontSize: List.from(barTextFontSize),
      barCodesContainerRotations: List.from(barCodesContainerRotations),
      isBarcodeLock: List.from(isBarcodeLock),
      drawText: List.from(drawText),

      isCheckedSerialNumber: _isCheckedSerialNumber,
      prefixController: List.from(prefixController),
      inputController: List.from(inputController),
      suffixController: List.from(suffixController),
      incrementController: List.from(incrementController),
      endPage: List.from(endPageController),

      barcodeBorder: barcodeBorder,
      showBarcodeWidget: showBarcodeWidget,
      showBarcodeContainerFlag: showBarcodeContainerFlag,
      selectedBarCodeIndex: selectedBarCodeIndex,
    );

    context.undoRedoProvider.addAction(
      ActionState(
        type: "Barcode",
        state: snapshot,
        restore: (s) => _restoreBarcodeState(s as BarcodeState),
      ),
    );
  }

  void _restoreBarcodeState(BarcodeState state) {
    barCodes = List.from(state.barCodes);
    barCodeOffsets = List.from(state.barCodeOffsets);
    barCalculatedWidth = List.from(state.barCalculatedWidth);
    brFocusNodes = List.from(state.brFocusNodes);
    barcodeControllers = List.from(state.barcodeControllers);
    barCodesContainerRotations = List.from(state.barCodesContainerRotations);
    updateBarcodeWidth = List.from(state.updateBarcodeWidth);
    updateBarcodeHeight = List.from(state.updateBarcodeHeight);
    barEncodingType = List.from(state.barEncodingType);
    barTextBold = List.from(state.barTextBold);
    barTextItalic = List.from(state.barTextItalic);
    barTextUnderline = List.from(state.barTextUnderline);
    barTextStrikeThrough = List.from(state.barTextStrikeThrough);
    barTextFontSize = List.from(state.barTextFontSize);
    isBarcodeLock = List.from(state.isBarcodeLock);
    drawText = List.from(state.drawText);

    barcodeBorder = state.barcodeBorder;
    showBarcodeWidget = state.showBarcodeWidget;
    showBarcodeContainerFlag = state.showBarcodeContainerFlag;
    _isCheckedSerialNumber = state.isCheckedSerialNumber;
    prefixController = List.from(state.prefixController);
    inputController = List.from(state.inputController);
    suffixController = List.from(state.suffixController);
    incrementController = List.from(state.incrementController);
    endPageController = List.from(state.endPage);
    selectedBarCodeIndex = state.selectedBarCodeIndex;

    notifyListeners();
  }

  /// ================== COPY / PASTE =====================
  Future<void> copyBarcodeWidget() async {
    final context = GlobalContext.context;
    if (context == null) return;
    _pasteCount = 0;

    final snapshot = BarcodeState(
      barCodes: [barCodes[selectedBarCodeIndex]],
      barCodeOffsets: [barCodeOffsets[selectedBarCodeIndex]],
      barCalculatedWidth: [],
      brFocusNodes: [brFocusNodes[selectedBarCodeIndex]],
      barcodeControllers: [barcodeControllers[selectedBarCodeIndex]],
      barCodesContainerRotations: [
        barCodesContainerRotations[selectedBarCodeIndex],
      ],
      updateBarcodeWidth: [updateBarcodeWidth[selectedBarCodeIndex]],
      updateBarcodeHeight: [updateBarcodeHeight[selectedBarCodeIndex]],
      barEncodingType: [barEncodingType[selectedBarCodeIndex]],
      barTextBold: [barTextBold[selectedBarCodeIndex]],
      barTextItalic: [barTextItalic[selectedBarCodeIndex]],
      barTextUnderline: [barTextUnderline[selectedBarCodeIndex]],
      barTextStrikeThrough: [barTextStrikeThrough[selectedBarCodeIndex]],
      barTextFontSize: [barTextFontSize[selectedBarCodeIndex]],
      isBarcodeLock: [isBarcodeLock[selectedBarCodeIndex]],
      drawText: [drawText[selectedBarCodeIndex]],

      prefixController: [prefixController[selectedBarCodeIndex]],
      inputController: [inputController[selectedBarCodeIndex]],
      suffixController: [suffixController[selectedBarCodeIndex]],
      incrementController: [incrementController[selectedBarCodeIndex]],
      endPage: [endPageController[selectedBarCodeIndex]],
      isCheckedSerialNumber: _isCheckedSerialNumber,
      barcodeBorder: barcodeBorder,
      showBarcodeWidget: true,
      showBarcodeContainerFlag: true,
      selectedBarCodeIndex: 0,
    );

    context.copyPasteProvider.copy(
      ClipboardItem(type: "barcode", state: snapshot),
    );
  }

  Future<void> pasteBarcodeWidget(ClipboardItem clipboard) async {
    commonModel.clearAllBorder();
    final context = GlobalContext.context;
    if (context == null) return;

    if (clipboard.state is! BarcodeState) return;
    final pastedState = clipboard.state as BarcodeState;
    _pasteCount++;
    Offset shift = Offset(10.0 * _pasteCount, 50.0 * _pasteCount);

    barCodes.addAll(pastedState.barCodes);
    barCodeOffsets.addAll(
      pastedState.barCodeOffsets.map((offset) => offset + shift).toList(),
    );
    brFocusNodes.addAll(pastedState.brFocusNodes);
    barcodeControllers.addAll(pastedState.barcodeControllers);
    updateBarcodeWidth.addAll(pastedState.updateBarcodeWidth);
    updateBarcodeHeight.addAll(pastedState.updateBarcodeHeight);

    barEncodingType.addAll(pastedState.barEncodingType);
    barTextBold.addAll(pastedState.barTextBold);
    barTextItalic.addAll(pastedState.barTextItalic);
    barTextUnderline.addAll(pastedState.barTextUnderline);
    barTextStrikeThrough.addAll(pastedState.barTextStrikeThrough);
    barTextFontSize.addAll(pastedState.barTextFontSize);
    barCodesContainerRotations.addAll(pastedState.barCodesContainerRotations);
    isBarcodeLock.add(false);
    drawText.add(true);

    prefixController.addAll(pastedState.prefixController);
    inputController.addAll(pastedState.inputController);
    suffixController.addAll(pastedState.suffixController);
    incrementController.addAll(pastedState.incrementController);
    endPageController.addAll(pastedState.endPage);
    barcodeBorder = true;
    selectedBarCodeIndex = barCodes.length - 1;

    context.copyPasteProvider.clear();
    saveCurrentBarcodeState();
    notifyListeners();
  }

  /// ====================  BARCODE GENERATED ====================
  void setShowBarcodeWidget(bool flag) {
    showBarcodeWidget = flag;

    saveCurrentBarcodeState();
    notifyListeners();
  }

  void generateBarCode() {
    // only border and container off function
    commonModel.generateBorderOff('barcode', true);

    _isCheckedSerialNumber ? barCodes.add('1') : barCodes.add('1234');
    barCodeOffsets.add(Offset(0, (barCodes.length * 10).toDouble()));
    selectedBarCodeIndex = barCodes.length - 1;
    updateBarcodeWidth.add(100);
    updateBarcodeHeight.add(80);
    barCodesContainerRotations.add(0);
    barTextFontSize.add(25);
    barEncodingType.add('Code128');
    barTextBold.add(true);
    barTextItalic.add(false);
    barTextUnderline.add(false);
    barTextStrikeThrough.add(false);
    isBarcodeLock.add(false);
    drawText.add(true);

    brFocusNodes.add(FocusNode());
    brFocusNodes[selectedBarCodeIndex].requestFocus();
    barcodeControllers.add(TextEditingController());
    prefixController.add(TextEditingController());
    inputController.add(TextEditingController(text: "1"));
    suffixController.add(TextEditingController());
    incrementController.add(TextEditingController(text: "1"));
    endPageController.add(TextEditingController(text: "5"));

    saveCurrentBarcodeState();
    notifyListeners();
  }

  void deleteBarCode(int barcodeIndex) {
    commonModel.generateBorderOff('barcode', false);

    if (barcodeIndex >= 0 && barcodeIndex < barCodes.length) {
      barCodes.removeAt(barcodeIndex);
      if (barcodeIndex < barCodeOffsets.length) {
        barCodeOffsets.removeAt(barcodeIndex);
      }
      if (barcodeIndex < barcodeControllers.length) {
        barcodeControllers.removeAt(barcodeIndex);
      }
      if (barcodeIndex < updateBarcodeWidth.length) {
        updateBarcodeWidth.removeAt(barcodeIndex);
      }
      if (barcodeIndex < updateBarcodeHeight.length) {
        updateBarcodeHeight.removeAt(barcodeIndex);
      }
      if (barcodeIndex < barEncodingType.length) {
        barEncodingType.removeAt(barcodeIndex);
      }
      if (barcodeIndex < barTextFontSize.length) {
        barTextFontSize.removeAt(barcodeIndex);
      }
      if (barcodeIndex < barTextBold.length) {
        barTextBold.removeAt(barcodeIndex);
      }
      if (barcodeIndex < barTextItalic.length) {
        barTextItalic.removeAt(barcodeIndex);
      }
      if (barcodeIndex < barTextUnderline.length) {
        barTextUnderline.removeAt(barcodeIndex);
      }
      if (barcodeIndex < barTextStrikeThrough.length) {
        barTextStrikeThrough.removeAt(barcodeIndex);
      }
      if (barcodeIndex < drawText.length) {
        drawText.removeAt(barcodeIndex);
      }
      if (barcodeIndex < isBarcodeLock.length) {
        isBarcodeLock.removeAt(barcodeIndex);
      }

      if (barcodeIndex < barCodesContainerRotations.length) {
        barCodesContainerRotations.removeAt(barcodeIndex);
      }
      if (barcodeIndex < brFocusNodes.length) {
        brFocusNodes.removeAt(barcodeIndex);
      }
      if (barcodeIndex < prefixController.length) {
        prefixController.removeAt(barcodeIndex);
      }
      if (barcodeIndex < inputController.length) {
        inputController.removeAt(barcodeIndex);
      }
      if (barcodeIndex < suffixController.length) {
        suffixController.removeAt(barcodeIndex);
      }
      if (barcodeIndex < incrementController.length) {
        incrementController.removeAt(barcodeIndex);
      }
      if (barcodeIndex < endPageController.length) {
        endPageController.removeAt(barcodeIndex);
      }
    }

    saveCurrentBarcodeState();
    notifyListeners();
  }

  /// ==================== RESIZE BARCODE WIDTH & HEIGHT ====================
  void handleResizeGesture(DragUpdateDetails details, int? brIndex) {
    if (selectedBarCodeIndex == brIndex) {
      final newWidth =
          updateBarcodeWidth[selectedBarCodeIndex] + details.delta.dx;

      final newHeight =
          updateBarcodeHeight[selectedBarCodeIndex] + details.delta.dy;

      // Ensure that the new width is greater than or equal to the minimum barcode width
      if (newWidth >= minWidthBarcode4Chars) {
        updateBarcodeWidth[selectedBarCodeIndex] = newWidth;
      }

      // Ensure that the new height is greater than or equal to the minimum barcode height
      if (newHeight >= minBarcodeHeight) {
        updateBarcodeHeight[selectedBarCodeIndex] = newHeight;
      }
    }
    notifyListeners();
  }

  /// ==================== BARCODE INPUT SECTION====================
  void updateBarcodeInputData(String value) {
    if (!_isCheckedSerialNumber) {
      barCodes[selectedBarCodeIndex] = value;
    } else {
      value =
          prefixController[selectedBarCodeIndex].text +
          inputController[selectedBarCodeIndex].text +
          suffixController[selectedBarCodeIndex].text;
      barCodes[selectedBarCodeIndex] = value;
    }

    // Calculate width based on the length of barcode data
    int dataLength = value.length;
    double widthPerCharacter =
        (maxWidthFor28Chars - minWidthBarcode4Chars) / (28 - 4);

    // Calculate the width needed for the current barcode data
    double calculatedWidth =
        minWidthBarcode4Chars + (dataLength * widthPerCharacter);

    // Make sure the width does not exceed the maximum for 20 characters
    calculatedWidth = calculatedWidth > maxWidthFor28Chars
        ? maxWidthFor28Chars
        : calculatedWidth;

    // Update the width if it's greater than the minimum width required
    if (calculatedWidth > minWidthBarcode4Chars) {
      updateBarcodeWidth[selectedBarCodeIndex] = calculatedWidth;
    }

    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 600),
      saveCurrentBarcodeState,
    );

    notifyListeners();
  }

  /// ==================== BARCODE STYLE SECTION====================
  Barcode getBarcode(String encodingType) {
    switch (encodingType) {
      case 'UPC-A':
        return Barcode.upcA();

      case 'EAN-8':
        return Barcode.ean8();

      case 'EAN-13':
        return Barcode.ean13();

      case 'Code93':
        return Barcode.code93();

      case 'Code39':
        return Barcode.code39();

      case 'CodeBar':
        return Barcode.codabar();

      default:
        return Barcode.code128();
    }
  }

  void setEncodingType(dynamic newType) {
    barEncodingType[selectedBarCodeIndex] = newType;
    getBarcode(newType);
    notifyListeners();
  }

  List<MenuFlyoutItem> barcodeTypeMenuItems() {
    List<MenuFlyoutItem> items = [];
    for (String encodingType in supportedEncodingTypes) {
      items.add(
        MenuFlyoutItem(
          text: Text(encodingType),
          onPressed: () {
            setEncodingType(encodingType);
            saveCurrentBarcodeState();
          },
        ),
      );
    }
    return items;
  }

  void toggleCheckbox(bool value) async {
    _isCheckedSerialNumber = value;
    LocalData.saveLocalData<bool>(
      "isCheckedSerialNumber",
      _isCheckedSerialNumber,
    );
    barCodes[selectedBarCodeIndex] = inputController[selectedBarCodeIndex].text;

    saveCurrentBarcodeState();
    notifyListeners();
  }

  void toggleDrawText(bool value) {
    if (selectedBarCodeIndex >= 0 && selectedBarCodeIndex < drawText.length) {
      drawText[selectedBarCodeIndex] = value;
      saveCurrentBarcodeState();
      notifyListeners();
    }
  }
}
