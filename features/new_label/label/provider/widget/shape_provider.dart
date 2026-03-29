import 'package:grozziie/utils/extension/provider_extension.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../common/clipboard_service/clipboard_service.dart';
import '../../../../../utils/extension/global_context.dart';
import '../common/common_function_provider.dart';
import '../../../../../common/redo_undo/undo_redo_manager.dart';
import '../../../../../utils/constants/label_global_variable.dart';
import '../../../../../localization/provider/language_provider.dart';
import '../../../../../data_layer/models/redo_undo_model/shape_state.dart';

class ShapeProvider extends ChangeNotifier {
  CommonFunctionProvider commonModel = CommonFunctionProvider();

  bool _isResizing = false;
  final List<String> _shapeFlags = ['Square', 'Round Shape', 'Circular', 'Oval Circular'];
  final Map<String, String> _translations = {
    'Square': '正方形',
    'Round Shape': '圆角',
    'Circular': '圆',
    'Oval Circular': '椭圆',
  };
  int selectedShapeIndexType = 0;
  int _pasteCount = 0;

  /// ================== Undo / Redo ==================
  void saveCurrentShapeState() {
    final context = GlobalContext.context;
    if (context == null) return;

    final snapshot = ShapeState(
      shapeCodes: List.from(shapeCodes),
      shapeOffsets: List.from(shapeOffsets),
      updateShapeWidth: List.from(updateShapeWidth),
      updateShapeHeight: List.from(updateShapeHeight),
      isSquareUpdate: List.from(isSquareUpdate),
      isRoundSquareUpdate: List.from(isRoundSquareUpdate),
      isCircularUpdate: List.from(isCircularUpdate),
      isOvalCircularUpdate: List.from(isOvalCircularUpdate),
      shapeTypes: List.from(shapeTypes),
      updateShapeLineWidthSize: List.from(updateShapeLineWidthSize),
      shapeCodesContainerRotations: List.from(shapeCodesContainerRotations),
      isFixedFigureSize: List.from(isFixedFigureSize),
      trueShapeWidth: List.from(trueShapeWidth),
      trueShapeHeight: List.from(trueShapeHeight),

      isShapeLock: List.from(isShapeLock),
      fixedShapeSize: fixedShapeSize,
      showShapeWidget: showShapeWidget,
      showShapeContainerFlag: showShapeContainerFlag,
      shapeBorder: shapeBorder,
      selectedShapeIndex: selectedShapeIndex,
    );

    context.undoRedoProvider.addAction(
      ActionState(type: "Shape", state: snapshot, restore: (s) => _restoreShapeState(s as ShapeState)),
    );
  }

  void _restoreShapeState(ShapeState state) {
    shapeCodes = List.from(state.shapeCodes);
    shapeOffsets = List.from(state.shapeOffsets);
    updateShapeWidth = List.from(state.updateShapeWidth);
    updateShapeHeight = List.from(state.updateShapeHeight);
    isSquareUpdate = List.from(state.isSquareUpdate);
    isRoundSquareUpdate = List.from(state.isRoundSquareUpdate);
    isCircularUpdate = List.from(state.isCircularUpdate);
    isOvalCircularUpdate = List.from(state.isOvalCircularUpdate);
    shapeTypes = List.from(state.shapeTypes);
    updateShapeLineWidthSize = List.from(state.updateShapeLineWidthSize);
    shapeCodesContainerRotations = List.from(state.shapeCodesContainerRotations);
    isFixedFigureSize = List.from(state.isFixedFigureSize);
    trueShapeWidth = List.from(state.trueShapeWidth);
    trueShapeHeight = List.from(state.trueShapeHeight);
    isShapeLock = List.from(state.isShapeLock);
    fixedShapeSize = state.fixedShapeSize;
    showShapeWidget = state.showShapeWidget;
    showShapeContainerFlag = state.showShapeContainerFlag;
    shapeBorder = state.shapeBorder;
    selectedShapeIndex = state.selectedShapeIndex;
    notifyListeners();
  }

  /// ==================== COPY / PASTE ====================

  Future<void> copyShapeWidget() async {
    final context = GlobalContext.context;
    if (context == null) return;
    _pasteCount = 0;

    final snapshot = ShapeState(
      shapeCodes: [shapeCodes[selectedShapeIndex]],
      shapeOffsets: [shapeOffsets[selectedShapeIndex]],
      updateShapeWidth: [updateShapeWidth[selectedShapeIndex]],
      updateShapeHeight: [updateShapeHeight[selectedShapeIndex]],
      isSquareUpdate: [isSquareUpdate[selectedShapeIndex]],
      isRoundSquareUpdate: [isRoundSquareUpdate[selectedShapeIndex]],
      isCircularUpdate: [isCircularUpdate[selectedShapeIndex]],
      isOvalCircularUpdate: [isOvalCircularUpdate[selectedShapeIndex]],
      shapeTypes: [shapeTypes[selectedShapeIndex]],
      updateShapeLineWidthSize: [updateShapeLineWidthSize[selectedShapeIndex]],
      shapeCodesContainerRotations: [shapeCodesContainerRotations[selectedShapeIndex]],
      isFixedFigureSize: [isFixedFigureSize[selectedShapeIndex]],
      trueShapeWidth: [trueShapeWidth[selectedShapeIndex]],
      trueShapeHeight: [trueShapeHeight[selectedShapeIndex]],
      isShapeLock: [isShapeLock[selectedShapeIndex]],
      fixedShapeSize: fixedShapeSize,
      showShapeWidget: true,
      showShapeContainerFlag: true,
      shapeBorder: shapeBorder,
      selectedShapeIndex: selectedShapeIndex,
    );

    context.copyPasteProvider.copy(ClipboardItem(type: "shape", state: snapshot));
  }

  Future<void> pasteShapeWidget(ClipboardItem clipboard) async {
    commonModel.clearAllBorder();
    final context = GlobalContext.context;
    if (context == null) return;

    if (clipboard.state is! ShapeState) return;
    final pastedState = clipboard.state as ShapeState;
    _pasteCount++;
    Offset shift = Offset(10.0 * _pasteCount, 50.0 * _pasteCount);

    shapeCodes.addAll(pastedState.shapeCodes);
    shapeOffsets.addAll(pastedState.shapeOffsets.map((offset) => offset + shift));
    updateShapeWidth.addAll(pastedState.updateShapeWidth);
    updateShapeHeight.addAll(pastedState.updateShapeHeight);
    isSquareUpdate.addAll(pastedState.isSquareUpdate);
    isRoundSquareUpdate.addAll(pastedState.isRoundSquareUpdate);
    isCircularUpdate.addAll(pastedState.isCircularUpdate);
    isOvalCircularUpdate.addAll(pastedState.isOvalCircularUpdate);
    shapeTypes.addAll(pastedState.shapeTypes);
    updateShapeLineWidthSize.addAll(pastedState.updateShapeLineWidthSize);
    shapeCodesContainerRotations.addAll(pastedState.shapeCodesContainerRotations);
    isFixedFigureSize.addAll(pastedState.isFixedFigureSize);
    trueShapeWidth.addAll(pastedState.trueShapeWidth);
    trueShapeHeight.addAll(pastedState.trueShapeHeight);
    fixedShapeSize = pastedState.fixedShapeSize;
    showShapeWidget = pastedState.showShapeWidget;
    showShapeContainerFlag = pastedState.showShapeContainerFlag;
    isShapeLock.add(false);

    shapeBorder = true;
    selectedShapeIndex = shapeCodes.length - 1;

    context.copyPasteProvider.clear();
    saveCurrentShapeState();
    notifyListeners();
  }

  /// ================== Shape Functions ==================
  void setShowFigureWidget(bool flag) {
    showShapeWidget = flag;
    saveCurrentShapeState();
    notifyListeners();
  }

  void fixedFigureSizeSwitch() {
    isFixedFigureSize[selectedShapeIndex] = !isFixedFigureSize[selectedShapeIndex];
    saveCurrentShapeState();
    notifyListeners();
  }

  void _onCallFunction(String flagToSet) {
    isSquareUpdate[selectedShapeIndex] = flagToSet == 'Square';
    isRoundSquareUpdate[selectedShapeIndex] = flagToSet == 'Round Shape';
    isCircularUpdate[selectedShapeIndex] = flagToSet == 'Circular';
    isOvalCircularUpdate[selectedShapeIndex] = flagToSet == 'Oval Circular';
    notifyListeners();
  }

  void _setSelectedShapeIndex(int index) {
    selectedShapeIndexType = index;
    notifyListeners();
  }

  void _setShapeType(String newType) {
    shapeTypes[selectedShapeIndex] = newType;
    _onCallFunction(newType);
    notifyListeners();
  }

  List<String> getShapeNames(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final localeCode = languageProvider.locale.languageCode;

    if (localeCode == 'zh') return _shapeFlags.map((s) => _translations[s]!).toList();
    return _shapeFlags;
  }

  List<MenuFlyoutItem> generateMenuItems() {
    List<MenuFlyoutItem> items = [];
    for (int i = 2; i <= 10; i++) {
      items.add(
        MenuFlyoutItem(
          text: Text(i.toString()),
          onPressed: () {
            double fontValue = i.toDouble();
            updateShapeLineWidthSize[selectedShapeIndex] = fontValue;
            notifyListeners();
          },
        ),
      );
    }
    return items;
  }

  List<MenuFlyoutItem> shapeTypeMenuItems(BuildContext context) {
    final shapeNames = getShapeNames(context);
    return shapeNames.map((shapeName) {
      final internalFlag = _shapeFlags.firstWhere(
        (flag) => _translations[flag] == shapeName || flag == shapeName,
        orElse: () => shapeName,
      );
      return MenuFlyoutItem(
        text: Text(shapeName),
        onPressed: () {
          _setSelectedShapeIndex(_shapeFlags.indexOf(internalFlag));
          _setShapeType(internalFlag);
          saveCurrentShapeState();
        },
      );
    }).toList();
  }

  /// ==================== ADD / DELETE SHAPE ====================
  void generateShapeCode() {
    commonModel.generateBorderOff('shape', true);

    shapeCodes.add('Shape');
    shapeOffsets.add(Offset(0, (shapeCodes.length * 5).toDouble()));
    shapeTypes.add('Square');
    isSquareUpdate.add(true);
    isRoundSquareUpdate.add(false);
    isCircularUpdate.add(false);
    isOvalCircularUpdate.add(false);
    updateShapeLineWidthSize.add(2);
    updateShapeWidth.add(60);
    updateShapeHeight.add(60);
    trueShapeWidth.add(60);
    trueShapeHeight.add(60);
    shapeCodesContainerRotations.add(0);
    isFixedFigureSize.add(false);
    isShapeLock.add(false);

    selectedShapeIndex = shapeCodes.length - 1;
    saveCurrentShapeState();
    notifyListeners();
  }

  void deleteShapeCode(int figureIndex) {
    saveCurrentShapeState();
    commonModel.generateBorderOff('shape', false);
    if (figureIndex < 0 || figureIndex >= shapeCodes.length) return;

    shapeCodes.removeAt(figureIndex);
    shapeBorder = false;
    if (figureIndex < shapeOffsets.length) shapeOffsets.removeAt(figureIndex);
    if (figureIndex < shapeTypes.length) shapeTypes.removeAt(figureIndex);
    if (figureIndex < isSquareUpdate.length) isSquareUpdate.removeAt(figureIndex);
    if (figureIndex < isRoundSquareUpdate.length) isRoundSquareUpdate.removeAt(figureIndex);
    if (figureIndex < isCircularUpdate.length) isCircularUpdate.removeAt(figureIndex);
    if (figureIndex < isOvalCircularUpdate.length) isOvalCircularUpdate.removeAt(figureIndex);
    if (figureIndex < updateShapeLineWidthSize.length) updateShapeLineWidthSize.removeAt(figureIndex);
    if (figureIndex < updateShapeWidth.length) updateShapeWidth.removeAt(figureIndex);
    if (figureIndex < updateShapeHeight.length) updateShapeHeight.removeAt(figureIndex);
    if (figureIndex < isFixedFigureSize.length) isFixedFigureSize.removeAt(figureIndex);
    if (figureIndex < trueShapeWidth.length) trueShapeWidth.removeAt(figureIndex);
    if (figureIndex < trueShapeHeight.length) trueShapeHeight.removeAt(figureIndex);
    if (figureIndex < shapeCodesContainerRotations.length) shapeCodesContainerRotations.removeAt(figureIndex);

    if (figureIndex < isShapeLock.length) {
      isShapeLock.removeAt(figureIndex);
    }

    notifyListeners();
  }

  void handleResizeGestureStart() {
    if (!_isResizing) {
      _isResizing = true;
      saveCurrentShapeState();
    }
  }

  void handleResizeGesture(DragUpdateDetails details) {
    const minWidth = 10.0, minHeight = 10.0;

    if (isFixedFigureSize[selectedShapeIndex]) {
      trueShapeWidth[selectedShapeIndex] = (trueShapeHeight[selectedShapeIndex] + details.delta.dx).clamp(
        minWidth,
        double.infinity,
      );
      trueShapeHeight[selectedShapeIndex] = (trueShapeHeight[selectedShapeIndex] + details.delta.dy).clamp(
        minHeight,
        double.infinity,
      );
    } else {
      updateShapeWidth[selectedShapeIndex] = (updateShapeWidth[selectedShapeIndex] + details.delta.dx).clamp(
        minWidth,
        double.infinity,
      );
      updateShapeHeight[selectedShapeIndex] = (updateShapeHeight[selectedShapeIndex] + details.delta.dy).clamp(
        minHeight,
        double.infinity,
      );
    }

    notifyListeners();
  }

  void handleResizeGestureEnd() {
    if (_isResizing) {
      saveCurrentShapeState();
      _isResizing = false;
    }
  }
}
