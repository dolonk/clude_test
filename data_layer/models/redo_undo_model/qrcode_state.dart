import 'package:fluent_ui/fluent_ui.dart';

class QrcodeState {
  final List<String> qrCodes;
  final List<Offset> qrCodeOffsets;
  final List<FocusNode> qrFocusNodes;
  final List<TextEditingController> qrcodeControllers;
  final List<double> updateQrcodeSize;
  final List<bool> isQrcodeLock;
  final bool showQrcodeWidget;
  final bool showQrcodeContainerFlag;
  final bool qrcodeBorder;
  final int selectedQRCodeIndex;

  QrcodeState({
    required this.qrCodes,
    required this.qrCodeOffsets,
    required this.qrFocusNodes,
    required this.qrcodeControllers,
    required this.updateQrcodeSize,
    required this.isQrcodeLock,
    required this.showQrcodeWidget,
    required this.showQrcodeContainerFlag,
    required this.qrcodeBorder,
    required this.selectedQRCodeIndex,
  });

  factory QrcodeState.empty() {
    return QrcodeState(
      qrCodes: [],
      qrCodeOffsets: [],
      qrFocusNodes: [],
      qrcodeControllers: [],
      updateQrcodeSize: [],
      isQrcodeLock: [],
      showQrcodeWidget: false,
      showQrcodeContainerFlag: false,
      qrcodeBorder: false,
      selectedQRCodeIndex: -1,
    );
  }

  QrcodeState copyWith({
    List<String>? qrCodes,
    List<Offset>? qrCodeOffsets,
    List<FocusNode>? qrFocusNodes,
    List<TextEditingController>? qrcodeControllers,
    List<double>? updateQrcodeSize,
    List<bool>? isQrcodeLock,
    bool? showQrcodeWidget,
    bool? showQrcodeContainerFlag,
    bool? qrcodeBorder,
    int? selectedQRCodeIndex,
  }) {
    return QrcodeState(
      qrCodes: qrCodes ?? List.from(this.qrCodes),
      qrCodeOffsets: qrCodeOffsets ?? List.from(this.qrCodeOffsets),
      qrFocusNodes: qrFocusNodes ?? List.from(this.qrFocusNodes),
      qrcodeControllers: qrcodeControllers ?? List.from(this.qrcodeControllers),
      updateQrcodeSize: updateQrcodeSize ?? List.from(this.updateQrcodeSize),
      isQrcodeLock: isQrcodeLock ?? List.from(this.isQrcodeLock),
      showQrcodeWidget: showQrcodeWidget ?? this.showQrcodeWidget,
      showQrcodeContainerFlag:
          showQrcodeContainerFlag ?? this.showQrcodeContainerFlag,
      qrcodeBorder: qrcodeBorder ?? this.qrcodeBorder,
      selectedQRCodeIndex: selectedQRCodeIndex ?? this.selectedQRCodeIndex,
    );
  }
}
