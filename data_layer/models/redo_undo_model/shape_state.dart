import 'package:fluent_ui/fluent_ui.dart';

class ShapeState {
  final List<String> shapeCodes;
  final List<Offset> shapeOffsets;
  final List<double> updateShapeWidth;
  final List<double> updateShapeHeight;
  final List<bool> isSquareUpdate;
  final List<bool> isRoundSquareUpdate;
  final List<bool> isCircularUpdate;
  final List<bool> isOvalCircularUpdate;
  final List<String> shapeTypes;
  final List<double> updateShapeLineWidthSize;
  final List<double> shapeCodesContainerRotations;
  final List<bool> isFixedFigureSize;
  final List<double> trueShapeWidth;
  final List<double> trueShapeHeight;
  final List<bool> isShapeLock;
  final bool fixedShapeSize;
  final bool showShapeWidget;
  final bool showShapeContainerFlag;
  final bool shapeBorder;
  final int selectedShapeIndex;

  ShapeState({
    required this.shapeCodes,
    required this.shapeOffsets,
    required this.updateShapeWidth,
    required this.updateShapeHeight,
    required this.isSquareUpdate,
    required this.isRoundSquareUpdate,
    required this.isCircularUpdate,
    required this.isOvalCircularUpdate,
    required this.shapeTypes,
    required this.updateShapeLineWidthSize,
    required this.shapeCodesContainerRotations,
    required this.isShapeLock,
    required this.isFixedFigureSize,
    required this.trueShapeWidth,
    required this.trueShapeHeight,
    required this.fixedShapeSize,
    required this.showShapeWidget,
    required this.showShapeContainerFlag,
    required this.shapeBorder,
    required this.selectedShapeIndex,
  });

  factory ShapeState.empty() {
    return ShapeState(
      shapeCodes: [],
      shapeOffsets: [],
      updateShapeWidth: [],
      updateShapeHeight: [],
      isSquareUpdate: [],
      isRoundSquareUpdate: [],
      isCircularUpdate: [],
      isOvalCircularUpdate: [],
      shapeTypes: [],
      updateShapeLineWidthSize: [],
      shapeCodesContainerRotations: [],
      isFixedFigureSize: [],
      trueShapeWidth: [],
      trueShapeHeight: [],
      isShapeLock: [],
      fixedShapeSize: false,
      showShapeWidget: false,
      showShapeContainerFlag: false,
      shapeBorder: false,
      selectedShapeIndex: -1,
    );
  }

  ShapeState copyWith({
    List<String>? shapeCodes,
    List<Offset>? shapeOffsets,
    List<double>? updateShapeWidth,
    List<double>? updateShapeHeight,
    List<bool>? isSquareUpdate,
    List<bool>? isRoundSquareUpdate,
    List<bool>? isCircularUpdate,
    List<bool>? isOvalCircularUpdate,
    List<String>? shapeTypes,
    List<double>? updateShapeLineWidthSize,
    List<double>? shapeCodesContainerRotations,
    List<bool>? isFixedFigureSize,
    List<double>? trueShapeWidth,
    List<double>? trueShapeHeight,
    List<bool>? isShapeLock,
    bool? fixedShapeSize,
    bool? showShapeWidget,
    bool? showShapeContainerFlag,
    bool? shapeBorder,
    int? selectedShapeIndex,
  }) {
    return ShapeState(
      shapeCodes: shapeCodes ?? List.from(this.shapeCodes),
      shapeOffsets: shapeOffsets ?? List.from(this.shapeOffsets),
      updateShapeWidth: updateShapeWidth ?? List.from(this.updateShapeWidth),
      updateShapeHeight: updateShapeHeight ?? List.from(this.updateShapeHeight),
      isSquareUpdate: isSquareUpdate ?? List.from(this.isSquareUpdate),
      isRoundSquareUpdate:
          isRoundSquareUpdate ?? List.from(this.isRoundSquareUpdate),
      isCircularUpdate: isCircularUpdate ?? List.from(this.isCircularUpdate),
      isOvalCircularUpdate:
          isOvalCircularUpdate ?? List.from(this.isOvalCircularUpdate),
      shapeTypes: shapeTypes ?? List.from(this.shapeTypes),
      updateShapeLineWidthSize:
          updateShapeLineWidthSize ?? List.from(this.updateShapeLineWidthSize),
      shapeCodesContainerRotations:
          shapeCodesContainerRotations ??
          List.from(this.shapeCodesContainerRotations),
      isFixedFigureSize: isFixedFigureSize ?? List.from(this.isFixedFigureSize),
      trueShapeWidth: trueShapeWidth ?? List.from(this.trueShapeWidth),
      trueShapeHeight: trueShapeHeight ?? List.from(this.trueShapeHeight),
      isShapeLock: isShapeLock ?? List.from(this.isShapeLock),
      fixedShapeSize: fixedShapeSize ?? this.fixedShapeSize,
      showShapeWidget: showShapeWidget ?? this.showShapeWidget,
      showShapeContainerFlag:
          showShapeContainerFlag ?? this.showShapeContainerFlag,
      shapeBorder: shapeBorder ?? this.shapeBorder,
      selectedShapeIndex: selectedShapeIndex ?? this.selectedShapeIndex,
    );
  }
}
