import 'dart:convert';
import 'dart:typed_data';
import '../../../features/new_label/label/view/dashboard_option/templated_container/show_widget_class/table_widget_class.dart';

class WidgetContainerModelClass {
  int? id;
  int mainContainerId;
  String widgetType;

  // primary variable
  String contentData;
  double offsetDx;
  double offsetDy;
  double width;
  double? height;
  double? rotation;

  // Text style Variable
  bool? isBold;
  bool? isUnderline;
  bool? isItalic;
  bool? isTextStrikeThrough;
  double? fontSize;
  String? textAlignment;
  String? fontFamily;

  // text identify
  String? checkTextIdentifyWidget;

  // Barcode Variable
  String? barEncodingType;

  // Table Variable
  int? rowCount;
  int? columnCount;
  List<List<GridCell>>? tablesCells;
  List<List<double>>? tablesRowHeights;
  List<List<double>>? tablesColumnWidths;

  // Emoji Variable
  Uint8List? selectedEmojiIcons;

  // serial number
  String? prefix;
  String? suffix;

  // Shape Variable
  String? shapeTypes;
  bool? isRectangale;
  bool? isRoundRectangale;
  bool? isCircularFixed;
  bool? isCircularNotFixed;
  double? widgetLineWidth;
  bool? isFixedFigureSize;
  double? trueShapeWidth;
  double? trueShapeHeight;

  WidgetContainerModelClass({
    this.id,
    required this.mainContainerId,
    required this.widgetType,
    required this.contentData,
    required this.offsetDx,
    required this.offsetDy,
    required this.width,
    this.height,
    this.rotation,
    this.isBold,
    this.isUnderline,
    this.isItalic,
    this.isTextStrikeThrough,
    this.fontSize,
    this.textAlignment,
    this.fontFamily,
    this.checkTextIdentifyWidget,
    this.barEncodingType,
    this.rowCount,
    this.columnCount,
    this.tablesCells,
    this.tablesRowHeights,
    this.tablesColumnWidths,
    this.selectedEmojiIcons,
    this.prefix,
    this.suffix,
    this.shapeTypes,
    this.isRectangale,
    this.isRoundRectangale,
    this.isCircularFixed,
    this.isCircularNotFixed,
    this.widgetLineWidth,
    this.isFixedFigureSize,
    this.trueShapeWidth,
    this.trueShapeHeight,
  });

  // Convert object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mainContainerId': mainContainerId,
      'widgetType': widgetType,
      'contentData': contentData,
      'offsetDx': offsetDx,
      'offsetDy': offsetDy,
      'width': width,
      'height': height,
      'rotation': rotation,
      'isBold': isBold == true ? 1 : 0,
      'isUnderline': isUnderline == true ? 1 : 0,
      'isItalic': isItalic == true ? 1 : 0,
      'isTextStrikeThrough': isItalic == true ? 1 : 0,
      'fontSize': fontSize,
      'textAlignment': textAlignment,
      'fontFamily': fontFamily,
      'checkTextIdentifyWidget': checkTextIdentifyWidget,
      'barEncodingType': barEncodingType,
      'rowCount': rowCount,
      'columnCount': columnCount,
      'tablesCells': tablesCells != null
          ? jsonEncode(tablesCells!.map((row) => row.map((cell) => cell.toMap()).toList()).toList())
          : null,
      'tablesRowHeights': tablesRowHeights != null
          ? jsonEncode(tablesRowHeights!.map((row) => row.map((height) => height).toList()).toList())
          : null,
      'tablesColumnWidths': tablesColumnWidths != null
          ? jsonEncode(tablesColumnWidths!.map((row) => row.map((width) => width).toList()).toList())
          : null,
      'selectedEmojiIcons': selectedEmojiIcons,
      'prefix': prefix,
      'suffix': suffix,
      'shapeTypes': shapeTypes,
      'isRectangale': isRectangale == true ? 1 : 0,
      'isRoundRectangale': isRoundRectangale == true ? 1 : 0,
      'isCircularFixed': isCircularFixed == true ? 1 : 0,
      'isCircularNotFixed': isCircularNotFixed == true ? 1 : 0,
      'widgetLineWidth': widgetLineWidth,
      'isFixedFigureSize': isFixedFigureSize == true ? 1 : 0,
      'trueShapeWidth': trueShapeWidth,
      'trueShapeHeight': trueShapeHeight,
    };
  }

  // Create object from a map
  static WidgetContainerModelClass fromMap(Map<String, dynamic> map) {
    return WidgetContainerModelClass(
      id: map['id'],
      mainContainerId: map['mainContainerId'],
      widgetType: map['widgetType'],
      contentData: map['contentData'],
      offsetDx: map['offsetDx'],
      offsetDy: map['offsetDy'],
      width: map['width'],
      height: map['height'],
      rotation: map['rotation'],
      isBold: map['isBold'] == 1,
      isUnderline: map['isUnderline'] == 1,
      isItalic: map['isItalic'] == 1,
      isTextStrikeThrough: map['isTextStrikeThrough'] == 1,
      fontSize: map['fontSize'],
      textAlignment: map['textAlignment'],
      fontFamily: map['fontFamily'],
      checkTextIdentifyWidget: map['checkTextIdentifyWidget'],
      barEncodingType: map['barEncodingType'],
      rowCount: map['rowCount'],
      columnCount: map['columnCount'],
      tablesCells: map['tablesCells'] != null
          ? (jsonDecode(map['tablesCells']) as List)
                .map((row) => (row as List).map((cell) => GridCell.fromMap(cell)).toList())
                .toList()
          : null,
      tablesRowHeights: map['tablesRowHeights'] != null
          ? (jsonDecode(map['tablesRowHeights']) as List)
                .map((row) => (row as List).map((height) => height as double).toList())
                .toList()
          : null,
      tablesColumnWidths: map['tablesColumnWidths'] != null
          ? (jsonDecode(map['tablesColumnWidths']) as List)
                .map((row) => (row as List).map((width) => width as double).toList())
                .toList()
          : null,
      selectedEmojiIcons: map['selectedEmojiIcons'],
      prefix: map['prefix'],
      suffix: map['suffix'],
      shapeTypes: map['shapeTypes'],
      isRectangale: map['isRectangale'] == 1,
      isRoundRectangale: map['isRoundRectangale'] == 1,
      isCircularFixed: map['isCircularFixed'] == 1,
      isCircularNotFixed: map['isCircularNotFixed'] == 1,
      widgetLineWidth: map['widgetLineWidth'],
      isFixedFigureSize: map['isFixedFigureSize'] == 1,
      trueShapeWidth: map['trueShapeWidth'],
      trueShapeHeight: map['trueShapeHeight'],
    );
  }
}
