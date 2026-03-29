import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import '../../features/new_label/label/view/dashboard_option/templated_container/show_widget_class/table_widget_class.dart';

bool isLockWidget = false;
bool isAdmin = true;
bool isUserLoggedIn = false;

/// Main container variable
int connectivityType = 0;
int mainContainerId = 0;
int mainPaperWidth = 0;
int mainPaperHeight = 0;
String selectPlatform = "";
String selectPrinter = "";
String printCategory = "";
String thermalPrinterModelName = "";
String dotPrinterModelName = "";
const String thermalPrinter = 'Thermal';
const String dotPrinter = 'Dot';
const String localDatabase = 'Local';
const String serverDatabase = 'Server';

/// Text  function variable
List<String> textCodes = [];
List<Offset> textCodeOffsets = [];
List<FocusNode> textFocusNodes = [];
List<TextEditingController> textControllers = [];
List<double> textContainerRotations = [];
List<bool> updateTextBold = [];
List<bool> updateTextItalic = [];
List<bool> updateTextUnderline = [];
List<TextAlign> updateTextAlignment = [];
List<double> updateTextFontSize = [];
List<double> updateTextWidthSize = [];
List<double> updateTextHeightSize = [];
List<String> textSelectedFontFamily = [];
List<bool> updateTextStrikeThrough = [];
List<bool> isTextLock = [];
bool textBorder = false;
bool showTextEditingWidget = false;
bool showTextEditingContainerFlag = false;
int selectedTextIndex = 0;

/// Barcode function variable
List<String> barCodes = [];
List<Offset> barCodeOffsets = [];
List<double> barCalculatedWidth = [];
List<FocusNode> brFocusNodes = [];
List<double> barCodesContainerRotations = [];
List<double> updateBarcodeWidth = [];
List<double> updateBarcodeHeight = [];
List<String> barEncodingType = [];
List<int> selectBarcodeTypeIndex = [];
List<bool> barTextBold = [];
List<bool> barTextItalic = [];
List<bool> barTextUnderline = [];
List<double> barTextFontSize = [];
List<TextEditingController> barcodeControllers = [];
List<bool> barTextStrikeThrough = [];
List<bool> isBarcodeLock = [];
List<bool> drawText = [];
bool showBarcodeWidget = false;
bool showBarcodeContainerFlag = false;
bool barcodeBorder = false;
int selectedBarCodeIndex = 0;

/// Qrcode function variable
List<String> qrCodes = [];
List<Offset> qrCodeOffsets = [];
List<FocusNode> qrFocusNodes = [];
List<TextEditingController> qrcodeControllers = [];
List<double> updateQrcodeSize = [];
List<bool> isQrcodeLock = [];
bool showQrcodeWidget = false;
bool showQrcodeContainerFlag = false;
bool qrcodeBorder = false;
int selectedQRCodeIndex = 0;

/// Table function variable
String inputText = '';
List<String> tableCodes = [];
List<Offset> tableOffsets = [];
List<int> rowCount = [];
List<int> columnCount = [];
List<double> tableLineWidth = [];
List<List<GridCell>> tablesCells = [];
List<List<double>> tablesRowHeights = [];
List<List<double>> tablesColumnWidths = [];
List<List<GridCell>> tablesSelectedCells = [];
List<FocusNode> tableTextFocusNodes = [];
List<TextEditingController> textController = [];
List<bool> tableBorderStyle = [];
List<double> tableContainerRotations = [];
List<bool> isTableLock = [];
List<bool> alignLeft = [];
List<bool> alignCenter = [];
List<bool> alignRight = [];
List<bool> alignStraight = [];
bool tableBorder = false;
bool showTableWidget = false;
bool showTableContainerFlag = false;
int selectedColIndex = 0;
int selectedRowIndex = 0;
int selectedTableIndex = 0;

/// Image  function variable
List<Uint8List> imageCodes = [];
List<Offset> imageOffsets = [];
List<double> updateImageSize = [];
List<double> imageCodesContainerRotations = [];
List<bool> isImageLock = [];
bool showImageWidget = false;
bool showImageContainerFlag = false;
bool imageBorder = false;
int selectedImageIndex = 0;

/// Time and Date Variable
List<String> checkTextIdentifyWidget = ['text'];
bool showDateContainerFlag = false;

/// Emoji function Variable
List<String> emojiCodes = [];
List<Offset> emojiCodeOffsets = [];
List<double> updatedEmojiWidth = [];
List<dynamic> selectedEmojis = [];
List<double> emojiCodesContainerRotations = [];
List<bool> isEmojiLock = [];
bool emojiBorder = false;
bool showEmojiWidget = false;
bool showEmojiContainerFlag = false;
String? selectedEmojiCategory;
int selectedEmojiIndex = 0;

/// serial number bar and text
List<String> prefixNumber = [];
List<String> suffixNumber = [];
List<int> incrementNumber = [];
List<int> endPageNumber = [];
List<TextEditingController> prefixController = [];
List<TextEditingController> inputController = [];
List<TextEditingController> suffixController = [];
List<TextEditingController> incrementController = [];
List<TextEditingController> endPageController = [];
bool showSerialContainerFlag = false;

/// Shape function variable
List<String> shapeCodes = [];
List<Offset> shapeOffsets = [];
List<String> shapeTypes = [];
List<bool> isSquareUpdate = [];
List<bool> isRoundSquareUpdate = [];
List<bool> isCircularUpdate = [];
List<bool> isOvalCircularUpdate = [];
List<double> updateShapeLineWidthSize = [];
List<double> updateShapeWidth = [];
List<double> updateShapeHeight = [];
List<double> trueShapeWidth = [];
List<double> trueShapeHeight = [];
List<double> shapeCodesContainerRotations = [];
List<bool> isFixedFigureSize = [];
List<bool> isShapeLock = [];
bool shapeBorder = false;
bool fixedShapeSize = false;
bool showShapeWidget = false;
bool showShapeContainerFlag = false;
int selectedShapeIndex = 0;

/// Line Widget Variable
List<String> lineCodes = [];
List<Offset> lineOffsets = [];
List<double> lineCodesContainerRotations = [];
List<double> updateSliderLineWidth = [];
List<bool> isDottedLineUpdate = [];
List<double> updateLineWidth = [];
List<bool> isLineLock = [];
bool showLineWidget = false;
bool showLineContainerFlag = false;
bool lineBorder = false;
int selectedLineIndex = 0;

/// Background image
Uint8List? selectedImage;
bool showBackgroundImageWidget = false;
bool showBackgroundImageContainerFlag = false;

/// data base use for attendance print section
List<List<List<String>>> cellTexts = [];
List<double> updateTableCellWidth = [];
List<int> selectedRowIndexList = [];
List<int> selectedColIndexList = [];
List<List<double>> columnWidths = [];
List<List<double>> rowHeights = [];
List<List<List<Alignment>>> tableTextAlignment = [];
List<List<List<bool>>> tableTextBold = [];
List<List<List<bool>>> tableTextUnderline = [];
List<List<List<bool>>> tableTextItalic = [];
List<List<List<double>>> tableTextFontSize = [];

/// local model variable
Uint8List? backgroundImage;
/* bool isLocalBackgroundImageTiger = false;
bool isServerBackgroundImageTiger = false;
bool showLocalBackgroundImageContainerFlag = false; */

/// Dot level print
int dotSelectPaperIndex = 0;
double dotSelectPaperSize = 279;
/*
Future<(double matchedHeight, int matchedIndex)> getDotSelectPaperSize(double size) async {
  var dotModels = dotPrintModels.where((model) => model.type == "Dot").toList();

  List<int> heights = dotModels.map((e) {
    return int.tryParse(e.defaultHeight?.split('.').first ?? '0') ?? 0;
  }).toList();

  // find out parameter value higher or equal
  List<int> greaterOrEqualHeights = heights.where((h) => h >= size).toList();

  if (greaterOrEqualHeights.isEmpty) {
    int maxHeight = heights.reduce((a, b) => a > b ? a : b);
    int maxIndex = heights.indexOf(maxHeight);
    return (maxHeight.toDouble(), maxIndex);
  }

  // find out the closer value
  int closestIndex = 0;
  double minDiff = (greaterOrEqualHeights[0] - size).abs();

  for (int i = 1; i < greaterOrEqualHeights.length; i++) {
    double diff = (greaterOrEqualHeights[i] - size).abs();
    if (diff < minDiff) {
      minDiff = diff;
      closestIndex = i;
    }
  }

  // return the match value
  int matchedHeight = greaterOrEqualHeights[closestIndex];
  int originalIndex = heights.indexOf(matchedHeight);

  return (matchedHeight.toDouble(), originalIndex);
}
*/

Future<int> getConnectionType(String type) async {
  if (type == "Bluetooth") {
    return 0;
  } else if (type == "Wifi") {
    return 1;
  }
  return 0;
}

/// Multiple widget variable
bool isMultiSelectEnabled = false;
List<int> selectedWidgetIndices = [];
//bool showMultiSelectContainerFlag = false;
int get textOffsetIndex => 0;
int get barcodeOffsetIndex => textCodeOffsets.length;
int get qrcodeOffsetIndex => textCodeOffsets.length + barCodeOffsets.length;
int get tableOffsetIndex =>
    textCodeOffsets.length + barCodeOffsets.length + qrCodeOffsets.length;
int get imageOffsetIndex =>
    textCodeOffsets.length +
    barCodeOffsets.length +
    qrCodeOffsets.length +
    tableOffsets.length;
int get emojiOffsetIndex =>
    textCodeOffsets.length +
    barCodeOffsets.length +
    qrCodeOffsets.length +
    tableOffsets.length +
    imageOffsets.length;
int get shapeOffsetIndex =>
    textCodeOffsets.length +
    barCodeOffsets.length +
    qrCodeOffsets.length +
    tableOffsets.length +
    imageOffsets.length +
    emojiCodeOffsets.length;
int get lineOffsetIndex =>
    textCodeOffsets.length +
    barCodeOffsets.length +
    qrCodeOffsets.length +
    tableOffsets.length +
    imageOffsets.length +
    emojiCodeOffsets.length +
    shapeOffsets.length;
