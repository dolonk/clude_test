import 'package:fluent_ui/fluent_ui.dart';
import '../common/common_function_provider.dart';
import '../../../../../utils/extension/global_context.dart';
import '../../../../../common/redo_undo/undo_redo_manager.dart';
import '../../../../../utils/extension/provider_extension.dart';
import '../../../../../utils/constants/label_global_variable.dart';
import '../../../../../common/clipboard_service/clipboard_service.dart';
import '../../../../../data_layer/models/redo_undo_model/line_state.dart';

class LineProvide extends ChangeNotifier {
  CommonFunctionProvider commonModel = CommonFunctionProvider();
  int _pasteCount = 0;

  /// ================== Undo / Redo Core ==================
  void saveCurrentLineWidgetState() {
    final context = GlobalContext.context;
    if (context == null) return;

    final snapshot = LineState(
      lineCodes: List.from(lineCodes),
      lineOffsets: List.from(lineOffsets),
      lineCodesContainerRotations: List.from(lineCodesContainerRotations),
      updateSliderLineWidth: List.from(updateSliderLineWidth),
      isDottedLineUpdate: List.from(isDottedLineUpdate),
      updateLineWidth: List.from(updateLineWidth),
      isLineLock: List.from(isLineLock),
      showLineWidget: showLineWidget,
      showLineContainerFlag: showLineContainerFlag,
      lineBorder: lineBorder,
      selectedLineIndex: selectedLineIndex,
    );

    context.undoRedoProvider.addAction(
      ActionState(
        type: "line",
        state: snapshot,
        restore: (state) => _restoreLineState(state),
      ),
    );
  }

  void _restoreLineState(LineState state) {
    lineCodes = List.from(state.lineCodes);
    lineOffsets = List.from(state.lineOffsets);
    lineCodesContainerRotations = List.from(state.lineCodesContainerRotations);
    updateSliderLineWidth = List.from(state.updateSliderLineWidth);
    isDottedLineUpdate = List.from(state.isDottedLineUpdate);
    updateLineWidth = List.from(state.updateLineWidth);
    isLineLock = List.from(state.isLineLock);
    showLineWidget = state.showLineWidget;
    showLineContainerFlag = state.showLineContainerFlag;
    lineBorder = state.lineBorder;
    selectedLineIndex = state.selectedLineIndex;

    debugPrint("🔄 LineState restored, showLineWidget: $showLineWidget");
    notifyListeners();
  }

  /// ================== COPY / PASTE =====================
  Future<void> copyLineWidget() async {
    final context = GlobalContext.context;
    if (context == null) return;
    _pasteCount = 0;

    final snapshot = LineState(
      lineCodes: [lineCodes[selectedLineIndex]],
      lineOffsets: [lineOffsets[selectedLineIndex]],
      lineCodesContainerRotations: [
        lineCodesContainerRotations[selectedLineIndex],
      ],
      updateSliderLineWidth: [updateSliderLineWidth[selectedLineIndex]],
      isDottedLineUpdate: [isDottedLineUpdate[selectedLineIndex]],
      updateLineWidth: [updateLineWidth[selectedLineIndex]],
      isLineLock: [isLineLock[selectedLineIndex]],
      showLineWidget: true,
      showLineContainerFlag: true,
      lineBorder: lineBorder,
      selectedLineIndex: 0,
    );

    context.copyPasteProvider.copy(
      ClipboardItem(type: "line", state: snapshot),
    );
  }

  Future<void> pasteLineWidget(ClipboardItem clipboard) async {
    final context = GlobalContext.context;
    if (context == null) return;

    if (clipboard.state is! LineState) return;
    final pastedState = clipboard.state as LineState;

    _pasteCount++;
    Offset shift = Offset(10.0 * _pasteCount, 50.0 * _pasteCount);

    lineCodes.addAll(pastedState.lineCodes);
    lineOffsets.addAll(
      pastedState.lineOffsets.map((offset) => offset + shift).toList(),
    );
    lineCodesContainerRotations.addAll(pastedState.lineCodesContainerRotations);
    updateSliderLineWidth.addAll(pastedState.updateSliderLineWidth);
    isDottedLineUpdate.addAll(pastedState.isDottedLineUpdate);
    updateLineWidth.addAll(pastedState.updateLineWidth);
    isLineLock.add(false);
    lineBorder = true;
    selectedLineIndex = lineCodes.length - 1;

    saveCurrentLineWidgetState();
    notifyListeners();
  }

  /// ================= line Code Generation ================
  void setShowLineWidget(bool flag) {
    saveCurrentLineWidgetState();

    showLineWidget = flag;
    showLineContainerFlag = flag;
    generateLineCode();
    notifyListeners();
  }

  void generateLineCode() {
    commonModel.generateBorderOff('line', true);
    lineCodes.add('Line');
    lineOffsets.add(Offset(0, (lineCodes.length * 5).toDouble()));
    isDottedLineUpdate.add(false);
    updateSliderLineWidth.add(2);
    lineCodesContainerRotations.add(0);
    updateLineWidth.add(100);
    isLineLock.add(false);
    selectedLineIndex = lineCodes.length - 1;

    saveCurrentLineWidgetState();
  }

  void deleteLineCode(int lineIndex) {
    commonModel.clearAllBorder();
    if (lineIndex >= 0 && lineIndex < lineCodes.length) {
      lineCodes.removeAt(lineIndex);
      lineOffsets.removeAt(lineIndex);

      if (lineIndex < lineCodesContainerRotations.length) {
        lineCodesContainerRotations.removeAt(lineIndex);
      }
      if (lineIndex < updateSliderLineWidth.length) {
        updateSliderLineWidth.removeAt(lineIndex);
      }
      if (lineIndex < isDottedLineUpdate.length) {
        isDottedLineUpdate.removeAt(lineIndex);
      }
      if (lineIndex < updateLineWidth.length) {
        updateLineWidth.removeAt(lineIndex);
      }
      if (lineIndex < isLineLock.length) {
        isLineLock.removeAt(lineIndex);
      }
    }

    saveCurrentLineWidgetState();
    notifyListeners();
  }

  /// ================== LINE STYLE SECTION ==================
  void setIsDottedLineUpdateFlag(bool flag) {
    isDottedLineUpdate[selectedLineIndex] = flag;

    saveCurrentLineWidgetState();
    notifyListeners();
  }

  void setSliderValue(double value) {
    updateSliderLineWidth[selectedLineIndex] = value;
    notifyListeners();
  }

  /// ==================== RESIZE HANDLING ====================
  void handleResizeGesture(DragUpdateDetails details, int lineIndex) {
    if (selectedLineIndex == lineIndex) {
      final newWidth = updateLineWidth[selectedLineIndex] + details.delta.dx;
      const minWidth = 40.0;

      if (newWidth >= minWidth) {
        updateLineWidth[selectedLineIndex] = newWidth;
      } else {
        updateLineWidth[selectedLineIndex] = minWidth;
      }
    }
    notifyListeners();
  }
}
