import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../common/clipboard_service/clipboard_service.dart';
import '../common/common_function_provider.dart';
import '../../../../../utils/extension/global_context.dart';
import '../../../../../common/redo_undo/undo_redo_manager.dart';
import '../../../../../utils/constants/label_global_variable.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../../data_layer/models/redo_undo_model/qrcode_state.dart';

class QrCodeProvider extends ChangeNotifier {
  CommonFunctionProvider commonModel = CommonFunctionProvider();

  String qrcodeData = '';
  double minQrcodeSize = 50.0;
  bool isQrCodesTextCleared = true;
  bool _isResizing = false;
  Timer? _debounce;
  int _pasteCount = 0;

  /// ==================== UNDO / REDO ====================
  void saveCurrentQrcodeState() {
    final context = GlobalContext.context;
    if (context == null) return;

    final snapshot = QrcodeState(
      qrCodes: List.from(qrCodes),
      qrCodeOffsets: List.from(qrCodeOffsets),
      qrFocusNodes: List.from(qrFocusNodes),
      qrcodeControllers: List.from(qrcodeControllers),
      updateQrcodeSize: List.from(updateQrcodeSize),
      isQrcodeLock: List.from(isQrcodeLock),
      showQrcodeWidget: showQrcodeWidget,
      showQrcodeContainerFlag: showQrcodeContainerFlag,
      qrcodeBorder: qrcodeBorder,
      selectedQRCodeIndex: selectedQRCodeIndex,
    );

    context.undoRedoProvider.addAction(
      ActionState(type: "Qrcode", state: snapshot, restore: (s) => _restoreQrcodeState(s as QrcodeState)),
    );
  }

  void _restoreQrcodeState(QrcodeState state) {
    qrCodes = List.from(state.qrCodes);
    qrCodeOffsets = List.from(state.qrCodeOffsets);
    qrFocusNodes = List.from(state.qrFocusNodes);
    qrcodeControllers = List.from(state.qrcodeControllers);
    updateQrcodeSize = List.from(state.updateQrcodeSize);
    isQrcodeLock = List.from(state.isQrcodeLock);
    showQrcodeWidget = state.showQrcodeWidget;
    showQrcodeContainerFlag = state.showQrcodeContainerFlag;
    qrcodeBorder = state.qrcodeBorder;
    selectedQRCodeIndex = state.selectedQRCodeIndex;

    notifyListeners();
  }

  /// ==================== COPY / PASTE ====================
  Future<void> copyQrcodeWidget() async {
    final context = GlobalContext.context;
    if (context == null) return;
    _pasteCount = 0;

    final snapshot = QrcodeState(
      qrCodes: [qrCodes[selectedQRCodeIndex]],
      qrCodeOffsets: [qrCodeOffsets[selectedQRCodeIndex]],
      qrFocusNodes: [qrFocusNodes[selectedQRCodeIndex]],
      qrcodeControllers: [qrcodeControllers[selectedQRCodeIndex]],
      updateQrcodeSize: [updateQrcodeSize[selectedQRCodeIndex]],
      isQrcodeLock: [isQrcodeLock[selectedQRCodeIndex]],
      showQrcodeWidget: true,
      showQrcodeContainerFlag: true,
      qrcodeBorder: qrcodeBorder,
      selectedQRCodeIndex: selectedQRCodeIndex,
    );

    context.copyPasteProvider.copy(ClipboardItem(type: "qrcode", state: snapshot));
  }

  Future<void> pasteQrcodeWidget(ClipboardItem clipboard) async {
    commonModel.clearAllBorder();

    final context = GlobalContext.context;
    if (context == null) return;

    if (clipboard.state is! QrcodeState) return;
    final pastedState = clipboard.state as QrcodeState;
    _pasteCount++;
    Offset shift = Offset(10.0 * _pasteCount, 50.0 * _pasteCount);

    qrCodes.addAll(pastedState.qrCodes);
    qrCodeOffsets.addAll(pastedState.qrCodeOffsets.map((offset) => offset + shift).toList());
    qrFocusNodes.addAll(pastedState.qrFocusNodes);
    qrcodeControllers.addAll(pastedState.qrcodeControllers);
    updateQrcodeSize.addAll(pastedState.updateQrcodeSize);
    isQrcodeLock.add(false);

    qrcodeBorder = true;
    selectedQRCodeIndex = qrCodes.length - 1;

    context.copyPasteProvider.clear();
    saveCurrentQrcodeState();
    notifyListeners();
  }

  /// ==================== CORE ACTIONS ====================
  void setShowQrcodeWidget(bool flag) {
    showQrcodeWidget = flag;
    saveCurrentQrcodeState();
    notifyListeners();
  }

  void generateQRCode() {
    commonModel.generateBorderOff('qrcode', true);
    qrCodes.add('5678');
    qrCodeOffsets.add(Offset(0, (qrCodes.length * 5).toDouble()));
    selectedQRCodeIndex = qrCodes.length - 1;
    updateQrcodeSize.add(100);
    qrFocusNodes.add(FocusNode());
    qrcodeControllers.add(TextEditingController());
    qrFocusNodes[selectedQRCodeIndex].requestFocus();
    isQrcodeLock.add(false);

    saveCurrentQrcodeState();
    notifyListeners();
  }

  void deleteQRCode(int qrCodeIndex) {
    if (qrCodeIndex < 0 || qrCodeIndex >= qrCodes.length) return;

    saveCurrentQrcodeState();
    commonModel.generateBorderOff('qrcode', false);

    qrCodes.removeAt(qrCodeIndex);
    qrCodeOffsets.removeAt(qrCodeIndex);
    qrcodeControllers.removeAt(qrCodeIndex);
    updateQrcodeSize.removeAt(qrCodeIndex);
    qrFocusNodes.removeAt(qrCodeIndex);
    isQrcodeLock.removeAt(qrCodeIndex);

    selectedQRCodeIndex = qrCodes.isEmpty ? -1 : (qrCodeIndex - 1).clamp(0, qrCodes.length - 1);
    saveCurrentQrcodeState();
    notifyListeners();
  }

  void updateQrcodeInputData(String value) {
    if (selectedQRCodeIndex < 0 || selectedQRCodeIndex >= qrCodes.length) return;

    qrCodes[selectedQRCodeIndex] = value;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), saveCurrentQrcodeState);

    notifyListeners();
  }

  /// ==================== RESIZE HANDLING ====================
  void handleResizeGestureStart() {
    if (!_isResizing) {
      _isResizing = true;
      saveCurrentQrcodeState();
    }
  }

  void handleResizeGesture(DragUpdateDetails details, int? qrIndex) {
    if (selectedQRCodeIndex != qrIndex) return;

    final newQrcodeSize = updateQrcodeSize[selectedQRCodeIndex] + details.delta.dx;
    updateQrcodeSize[selectedQRCodeIndex] = newQrcodeSize >= minQrcodeSize ? newQrcodeSize : minQrcodeSize;

    notifyListeners();
  }

  void handleResizeGestureEnd() {
    if (_isResizing) {
      saveCurrentQrcodeState();
      _isResizing = false;
    }
  }
}
