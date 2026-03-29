import 'package:fluent_ui/fluent_ui.dart';

class BarcodeState {
  final List<String> barCodes;
  final List<Offset> barCodeOffsets;
  final List<double> barCalculatedWidth;
  final List<FocusNode> brFocusNodes;
  final List<TextEditingController> barcodeControllers;
  final List<double> barCodesContainerRotations;
  final List<double> updateBarcodeWidth;
  final List<double> updateBarcodeHeight;
  final List<String> barEncodingType;
  final List<bool> barTextBold;
  final List<bool> barTextItalic;
  final List<bool> barTextUnderline;
  final List<bool> barTextStrikeThrough;
  final List<double> barTextFontSize;
  final List<bool> isBarcodeLock;
  final List<bool> drawText;

  final bool barcodeBorder;
  final bool showBarcodeWidget;
  final bool showBarcodeContainerFlag;
  final bool isCheckedSerialNumber;
  final List<TextEditingController> prefixController;
  final List<TextEditingController> inputController;
  final List<TextEditingController> suffixController;
  final List<TextEditingController> incrementController;
  final List<TextEditingController> endPage;
  final int selectedBarCodeIndex;

  BarcodeState({
    required this.barCodes,
    required this.barCodeOffsets,
    required this.barCalculatedWidth,
    required this.brFocusNodes,
    required this.barcodeControllers,
    required this.barCodesContainerRotations,
    required this.updateBarcodeWidth,
    required this.updateBarcodeHeight,
    required this.barEncodingType,
    required this.barTextBold,
    required this.barTextItalic,
    required this.barTextUnderline,
    required this.barTextStrikeThrough,
    required this.barTextFontSize,
    required this.isBarcodeLock,
    required this.drawText,

    required this.barcodeBorder,
    required this.showBarcodeWidget,
    required this.showBarcodeContainerFlag,
    required this.isCheckedSerialNumber,
    required this.prefixController,
    required this.inputController,
    required this.suffixController,
    required this.incrementController,
    required this.endPage,
    required this.selectedBarCodeIndex,
  });

  factory BarcodeState.empty() {
    return BarcodeState(
      barCodes: [],
      barCodeOffsets: [],
      barCalculatedWidth: [],
      brFocusNodes: [],
      barcodeControllers: [],
      barCodesContainerRotations: [],
      updateBarcodeWidth: [],
      updateBarcodeHeight: [],
      barEncodingType: [],
      barTextBold: [],
      barTextItalic: [],
      barTextUnderline: [],
      barTextStrikeThrough: [],
      barTextFontSize: [],
      isBarcodeLock: [],
      drawText: [],

      barcodeBorder: false,
      showBarcodeWidget: false,
      showBarcodeContainerFlag: false,
      isCheckedSerialNumber: false,
      prefixController: [],
      inputController: [],
      suffixController: [],
      incrementController: [],
      endPage: [],
      selectedBarCodeIndex: -1,
    );
  }

  BarcodeState copyWith({
    List<String>? barCodes,
    List<Offset>? barCodeOffsets,
    List<double>? barCalculatedWidth,
    List<FocusNode>? brFocusNodes,
    List<TextEditingController>? barcodeControllers,
    List<double>? barCodesContainerRotations,
    List<double>? updateBarcodeWidth,
    List<double>? updateBarcodeHeight,
    List<String>? barEncodingType,
    List<bool>? barTextBold,
    List<bool>? barTextItalic,
    List<bool>? barTextUnderline,
    List<bool>? barTextStrikeThrough,
    List<double>? barTextFontSize,
    List<bool>? isBarcodeLock,
    List<bool>? drawText,

    bool? barcodeBorder,
    bool? showBarcodeWidget,
    bool? showBarcodeContainerFlag,
    bool? isCheckedSerialNumber,
    List<TextEditingController>? prefixController,
    List<TextEditingController>? inputController,
    List<TextEditingController>? suffixController,
    List<TextEditingController>? incrementController,
    List<TextEditingController>? endPage,
    int? selectedBarCodeIndex,
  }) {
    return BarcodeState(
      barCodes: barCodes ?? List.from(this.barCodes),
      barCodeOffsets: barCodeOffsets ?? List.from(this.barCodeOffsets),
      barCalculatedWidth:
          barCalculatedWidth ?? List.from(this.barCalculatedWidth),
      brFocusNodes: brFocusNodes ?? List.from(this.brFocusNodes),
      barcodeControllers:
          barcodeControllers ?? List.from(this.barcodeControllers),
      barCodesContainerRotations:
          barCodesContainerRotations ??
          List.from(this.barCodesContainerRotations),
      updateBarcodeWidth:
          updateBarcodeWidth ?? List.from(this.updateBarcodeWidth),
      updateBarcodeHeight:
          updateBarcodeHeight ?? List.from(this.updateBarcodeHeight),
      barEncodingType: barEncodingType ?? List.from(this.barEncodingType),
      barTextBold: barTextBold ?? List.from(this.barTextBold),
      barTextItalic: barTextItalic ?? List.from(this.barTextItalic),
      barTextUnderline: barTextUnderline ?? List.from(this.barTextUnderline),
      barTextStrikeThrough:
          barTextStrikeThrough ?? List.from(this.barTextStrikeThrough),
      barTextFontSize: barTextFontSize ?? List.from(this.barTextFontSize),
      isBarcodeLock: isBarcodeLock ?? List.from(this.isBarcodeLock),
      drawText: drawText ?? List.from(this.drawText),

      barcodeBorder: barcodeBorder ?? this.barcodeBorder,
      showBarcodeWidget: showBarcodeWidget ?? this.showBarcodeWidget,
      showBarcodeContainerFlag:
          showBarcodeContainerFlag ?? this.showBarcodeContainerFlag,
      isCheckedSerialNumber:
          isCheckedSerialNumber ?? this.isCheckedSerialNumber,
      prefixController: prefixController ?? List.from(this.prefixController),
      inputController: inputController ?? List.from(this.inputController),
      suffixController: suffixController ?? List.from(this.suffixController),
      incrementController:
          incrementController ?? List.from(this.incrementController),
      endPage: endPage ?? List.from(this.endPage),
      selectedBarCodeIndex: selectedBarCodeIndex ?? this.selectedBarCodeIndex,
    );
  }
}
