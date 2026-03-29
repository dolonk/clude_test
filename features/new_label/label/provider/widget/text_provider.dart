import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import '../common/common_function_provider.dart';
import '../../../../../common/font_load/font_load.dart';
import '../../../../../utils/local_storage/local_data.dart';
import '../../../../../utils/extension/global_context.dart';
import '../../../../../common/redo_undo/undo_redo_manager.dart';
import '../../../../../utils/constants/label_global_variable.dart';
import '../../../../../common/clipboard_service/clipboard_service.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../../data_layer/models/redo_undo_model/text_editing_state.dart';

class TextEditingProvider extends ChangeNotifier {
  CommonFunctionProvider commonModel = CommonFunctionProvider();
  int _pasteCount = 0;
  Timer? _debounce;
  TextAlign textAlignment = TextAlign.center;

  /// ================== Undo / Redo Core ==================
  void saveCurrentTextWidgetState() {
    final context = GlobalContext.context;
    if (context == null) return;

    final snapshot = TextEditingState(
      textCodes: List.from(textCodes),
      textCodeOffsets: List.from(textCodeOffsets),
      textFocusNodes: List.from(textFocusNodes),
      textControllers: List.from(textControllers),
      updateTextWidthSize: List.from(updateTextWidthSize),
      updateTextHeightSize: List.from(updateTextHeightSize),
      updateTextBold: List.from(updateTextBold),
      updateTextItalic: List.from(updateTextItalic),
      updateTextUnderline: List.from(updateTextUnderline),
      updateTextStrikeThrough: List.from(updateTextStrikeThrough), //
      updateTextAlignment: List.from(updateTextAlignment),
      alignLeft: List.from(alignLeft),
      alignCenter: List.from(alignCenter),
      alignRight: List.from(alignRight),
      alignStraight: List.from(alignStraight),
      updateTextFontSize: List.from(updateTextFontSize),
      textContainerRotations: List.from(textContainerRotations),
      textSelectedFontFamily: List.from(textSelectedFontFamily),
      isTextLock: List.from(isTextLock),

      textBorder: textBorder,
      showTextEditingWidget: showTextEditingWidget,
      showTextEditingContainerFlag: showTextEditingContainerFlag,
      selectedTextIndex: selectedTextIndex,
    );

    context.undoRedoProvider.addAction(
      ActionState(
        type: "text",
        state: snapshot,
        restore: (s) => _restoreTextEditingState(s as TextEditingState),
      ),
    );
  }

  void _restoreTextEditingState(TextEditingState state) {
    textCodes = List.from(state.textCodes);
    textCodeOffsets = List.from(state.textCodeOffsets);
    textFocusNodes = List.from(state.textFocusNodes);
    textControllers = List.from(state.textControllers);
    textContainerRotations = List.from(state.textContainerRotations);
    updateTextBold = List.from(state.updateTextBold);
    updateTextItalic = List.from(state.updateTextItalic);
    updateTextUnderline = List.from(state.updateTextUnderline);
    updateTextStrikeThrough = List.from(state.updateTextStrikeThrough);
    updateTextAlignment = List.from(state.updateTextAlignment);
    alignLeft = List.from(state.alignLeft);
    alignCenter = List.from(state.alignCenter);
    alignRight = List.from(state.alignRight);
    alignStraight = List.from(state.alignStraight);
    updateTextFontSize = List.from(state.updateTextFontSize);
    updateTextWidthSize = List.from(state.updateTextWidthSize);
    updateTextHeightSize = List.from(state.updateTextHeightSize);
    textSelectedFontFamily = List.from(state.textSelectedFontFamily);
    isTextLock = List.from(state.isTextLock);

    textBorder = state.textBorder;
    showTextEditingWidget = state.showTextEditingWidget;
    showTextEditingContainerFlag = state.showTextEditingContainerFlag;
    selectedTextIndex = state.selectedTextIndex;

    notifyListeners();
  }

  /// ================== COPY / PASTE =====================
  Future<void> copyTextWidget() async {
    final context = GlobalContext.context;
    if (context == null) return;
    _pasteCount = 0;

    final snapshot = TextEditingState(
      textCodes: [textCodes[selectedTextIndex]],
      textCodeOffsets: [textCodeOffsets[selectedTextIndex]],
      textFocusNodes: [textFocusNodes[selectedTextIndex]],
      textControllers: [textControllers[selectedTextIndex]],
      textContainerRotations: [textContainerRotations[selectedTextIndex]],
      updateTextBold: [updateTextBold[selectedTextIndex]],
      updateTextItalic: [updateTextItalic[selectedTextIndex]],
      updateTextUnderline: [updateTextUnderline[selectedTextIndex]],
      updateTextStrikeThrough: [updateTextStrikeThrough[selectedTextIndex]],
      updateTextAlignment: [updateTextAlignment[selectedTextIndex]],
      alignLeft: [alignLeft[selectedTextIndex]],
      alignCenter: [alignCenter[selectedTextIndex]],
      alignRight: [alignRight[selectedTextIndex]],
      alignStraight: [alignStraight[selectedTextIndex]],
      updateTextFontSize: [updateTextFontSize[selectedTextIndex]],
      updateTextWidthSize: [updateTextWidthSize[selectedTextIndex]],
      updateTextHeightSize: [updateTextHeightSize[selectedTextIndex]],
      textSelectedFontFamily: [textSelectedFontFamily[selectedTextIndex]],
      isTextLock: [isTextLock[selectedTextIndex]],

      showTextEditingWidget: true,
      showTextEditingContainerFlag: true,
      textBorder: textBorder,
      selectedTextIndex: 0,
    );

    context.copyPasteProvider.copy(
      ClipboardItem(type: "text", state: snapshot),
    );
  }

  Future<void> pasteTextWidget(ClipboardItem clipboard) async {
    commonModel.clearAllBorder();
    final context = GlobalContext.context;
    if (context == null) return;

    if (clipboard.state is! TextEditingState) return;
    final pastedState = clipboard.state as TextEditingState;

    _pasteCount++;
    Offset shift = Offset(10.0 * _pasteCount, 50.0 * _pasteCount);

    textCodes.addAll(pastedState.textCodes);
    textCodeOffsets.addAll(
      pastedState.textCodeOffsets.map((offset) => offset + shift).toList(),
    );
    textFocusNodes.addAll(pastedState.textFocusNodes);
    textControllers.addAll(pastedState.textControllers);
    textContainerRotations.addAll(pastedState.textContainerRotations);
    updateTextBold.addAll(pastedState.updateTextBold);
    updateTextItalic.addAll(pastedState.updateTextItalic);
    updateTextUnderline.addAll(pastedState.updateTextUnderline);
    updateTextStrikeThrough.addAll(pastedState.updateTextStrikeThrough);
    updateTextAlignment.addAll(pastedState.updateTextAlignment);
    alignLeft.addAll(pastedState.alignLeft);
    alignCenter.addAll(pastedState.alignCenter);
    alignRight.addAll(pastedState.alignRight);
    alignStraight.addAll(pastedState.alignStraight);
    updateTextFontSize.addAll(pastedState.updateTextFontSize);
    updateTextWidthSize.addAll(pastedState.updateTextWidthSize);
    updateTextHeightSize.addAll(pastedState.updateTextHeightSize);
    textSelectedFontFamily.addAll(pastedState.textSelectedFontFamily);
    isTextLock.add(false);
    textBorder = true;
    selectedTextIndex = textCodes.length - 1;

    context.copyPasteProvider.clear();
    saveCurrentTextWidgetState();
    notifyListeners();
  }

  /// ================= Text Code Generation ================
  void setShowTextEditingWidget(bool flag) {
    showTextEditingWidget = flag;
    saveCurrentTextWidgetState();
    notifyListeners();
  }

  void generateTextCode() async {
    commonModel.generateBorderOff('text', true);
    final fontKey =
        await LocalData.getLocalData<String>("FontFamily") ?? "Poppins";

    switch (languageCode) {
      case 'zh':
        textCodes.add('输入您想要的文字');
        break;
      default:
        textCodes.add('Input Text What You Want');
    }

    textCodeOffsets.add(Offset(0, (textCodes.length * 5).toDouble()));
    selectedTextIndex = textCodes.length - 1;
    textFocusNodes.add(FocusNode());
    textFocusNodes[selectedTextIndex].requestFocus();
    textControllers.add(TextEditingController());
    updateTextBold.add(false);
    updateTextItalic.add(false);
    updateTextUnderline.add(false);

    updateTextStrikeThrough.add(false);
    alignLeft.add(true);
    alignCenter.add(false);
    alignRight.add(false);
    alignStraight.add(false);
    updateTextAlignment.add(TextAlign.left);
    updateTextFontSize.add(20.0);
    textContainerRotations.add(0.0);

    updateTextWidthSize.add(200);
    updateTextHeightSize.add(60);
    textSelectedFontFamily.add(fontKey);
    isTextLock.add(false);

    saveCurrentTextWidgetState();
    notifyListeners();
  }

  void deleteTextCode(int textIndex) {
    if (textIndex < 0 || textIndex >= textCodes.length) return;

    commonModel.generateBorderOff('text', false);

    textBorder = false;
    textCodes.removeAt(textIndex);
    textCodeOffsets.removeAt(textIndex);
    textControllers.removeAt(textIndex);
    updateTextBold.removeAt(textIndex);
    updateTextItalic.removeAt(textIndex);
    updateTextUnderline.removeAt(textIndex);
    updateTextStrikeThrough.removeAt(textIndex);
    updateTextFontSize.removeAt(textIndex);
    alignLeft.removeAt(textIndex);
    alignCenter.removeAt(textIndex);
    alignRight.removeAt(textIndex);
    alignStraight.removeAt(textIndex);
    updateTextAlignment.removeAt(textIndex);
    textContainerRotations.removeAt(textIndex);
    updateTextWidthSize.removeAt(textIndex);
    updateTextHeightSize.removeAt(textIndex);
    textFocusNodes.removeAt(textIndex);
    textSelectedFontFamily.removeAt(textIndex);
    isTextLock.removeAt(textIndex);

    saveCurrentTextWidgetState();
    notifyListeners();
  }

  /// ==================== RESIZE HANDLING ====================
  void handleResizeGesture(DragUpdateDetails details, int textIndex) {
    if (selectedTextIndex == textIndex) {
      final newWidth =
          updateTextWidthSize[selectedTextIndex] + details.delta.dx;
      final newHeight =
          updateTextHeightSize[selectedTextIndex] + details.delta.dy;

      const minWidth = 5.0;
      const minHeight = 5.0;

      updateTextWidthSize[selectedTextIndex] = newWidth >= minWidth
          ? newWidth
          : minWidth;
      updateTextHeightSize[selectedTextIndex] = newHeight >= minHeight
          ? newHeight
          : minHeight;
    }
    notifyListeners();
  }

  /// ================== TEXT EDITING SECTION ==================
  void updateTextInputData(String value) {
    if (selectedTextIndex < 0 || selectedTextIndex >= textCodes.length) return;

    textCodes[selectedTextIndex] = value;

    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 600),
      saveCurrentTextWidgetState,
    );

    notifyListeners();
  }

  void changeAlignment(TextAlign alignment) {
    if (selectedTextIndex < 0 || selectedTextIndex >= textCodes.length) return;

    textAlignment = alignment;
    updateTextAlignment[selectedTextIndex] = textAlignment;
    alignLeft[selectedTextIndex] = (textAlignment == TextAlign.left);
    alignCenter[selectedTextIndex] = (textAlignment == TextAlign.center);
    alignRight[selectedTextIndex] = (textAlignment == TextAlign.right);
    alignStraight[selectedTextIndex] = (textAlignment == TextAlign.justify);

    saveCurrentTextWidgetState();
    notifyListeners();
  }
}
