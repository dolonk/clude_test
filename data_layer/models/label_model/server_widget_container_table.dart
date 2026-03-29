import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../features/new_label/label/view/dashboard_option/templated_container/show_widget_class/table_widget_class.dart';

class ServerWidgetContainerTableModel {
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

  ServerWidgetContainerTableModel({
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
      'fontSize': fontSize,
      'textAlignment': textAlignment,
      'fontFamily': fontFamily,
      'checkTextIdentifyWidget': checkTextIdentifyWidget,
      'barEncodingType': barEncodingType,
      'rowCount': rowCount,
      'columnCount': columnCount,
      'tablesCells': tablesCells != null
          ? jsonEncode(
              tablesCells!
                  .map((row) => row.map((cell) => cell.toMap()).toList())
                  .toList(),
            )
          : null,
      'tablesRowHeights': tablesRowHeights != null
          ? jsonEncode(
              tablesRowHeights!
                  .map((row) => row.map((height) => height).toList())
                  .toList(),
            )
          : null,
      'tablesColumnWidths': tablesColumnWidths != null
          ? jsonEncode(
              tablesColumnWidths!
                  .map((row) => row.map((width) => width).toList())
                  .toList(),
            )
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

  factory ServerWidgetContainerTableModel.fromJson(Map<String, dynamic> json) {
    return ServerWidgetContainerTableModel(
      id: json['id'],
      mainContainerId: json['mainContainerId'],
      widgetType: json['widgetType'] ?? '',
      contentData: json['contentData'] ?? '',
      offsetDx: (json['offsetDx'] ?? 0).toDouble(),
      offsetDy: (json['offsetDy'] ?? 0).toDouble(),
      width: (json['width'] ?? 0).toDouble(),
      height: json['height'] != null
          ? (json['height'] as num).toDouble()
          : null,
      rotation: json['rotation'] != null
          ? (json['rotation'] as num).toDouble()
          : null,
      isBold: json['isBold'] == 1,
      isUnderline: json['isUnderline'] == 1,
      isItalic: json['isItalic'] == 1,
      fontSize: json['fontSize'] != null
          ? (json['fontSize'] as num).toDouble()
          : null,
      textAlignment: json['textAlignment'],
      fontFamily: json['fontFamily'],
      checkTextIdentifyWidget: json['checkTextIdentifyWidget'],
      barEncodingType: json['barEncodingType'],
      rowCount: json['rowCount'],
      columnCount: json['columnCount'],
      tablesCells: json['tablesCells'] != null
          ? (jsonDecode(json['tablesCells']) as List)
                .map(
                  (row) => (row as List)
                      .map((cell) => GridCell.fromMap(cell))
                      .toList(),
                )
                .toList()
          : null,
      tablesRowHeights: json['tablesRowHeights'] != null
          ? (jsonDecode(json['tablesRowHeights']) as List)
                .map(
                  (row) => (row as List)
                      .map((height) => (height as num).toDouble())
                      .toList(),
                )
                .toList()
          : null,
      tablesColumnWidths: json['tablesColumnWidths'] != null
          ? (jsonDecode(json['tablesColumnWidths']) as List)
                .map(
                  (row) => (row as List)
                      .map((width) => (width as num).toDouble())
                      .toList(),
                )
                .toList()
          : null,
      selectedEmojiIcons: parseSelectedEmojiIcons(json),
      prefix: json['prefix'],
      suffix: json['suffix'],
      shapeTypes: json['shapeTypes'],
      isRectangale: json['isRectangale'] == 1,
      isRoundRectangale: json['isRoundRectangale'] == 1,
      isCircularFixed: json['isCircularFixed'] == 1,
      isCircularNotFixed: json['isCircularNotFixed'] == 1,
      widgetLineWidth: json['widgetLineWidth'] != null
          ? (json['widgetLineWidth'] as num).toDouble()
          : null,
      isFixedFigureSize: json['isFixedFigureSize'] == 1,
      trueShapeWidth: json['trueShapeWidth'] != null
          ? (json['trueShapeWidth'] as num).toDouble()
          : null,
      trueShapeHeight: json['trueShapeHeight'] != null
          ? (json['trueShapeHeight'] as num).toDouble()
          : null,
    );
  }

  static Uint8List? parseSelectedEmojiIcons(Map<String, dynamic> map) {
    Uint8List? uint8List;
    try {
      var selectedEmojiData = map['selectedEmojiIcons'];
      if (selectedEmojiData is String) {
        if (selectedEmojiData.isNotEmpty) {
          selectedEmojiData = selectedEmojiData
              .replaceAll('{', '')
              .replaceAll('}', '');
          if (selectedEmojiData.isNotEmpty) {
            List<String> parts = selectedEmojiData
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',');

            List<int> integers = parts.map((s) => int.parse(s.trim())).toList();
            uint8List = Uint8List.fromList(integers);
          }
        }
      } else if (selectedEmojiData is Uint8List) {
        uint8List = selectedEmojiData;
      } else {
        debugPrint(
          'Unexpected type for selectedEmojiIcons: ${selectedEmojiData.runtimeType}',
        );
      }
    } catch (e) {
      debugPrint('Error while parsing selectedEmojiIcons: $e');
    }
    return uint8List;
  }
}
