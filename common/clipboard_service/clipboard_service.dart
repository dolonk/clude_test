import 'package:fluent_ui/fluent_ui.dart';
import '../../utils/constants/label_global_variable.dart';
import 'package:grozziie/utils/snackbar_toast/snack_bar.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';

class ClipboardItem {
  final String type;
  final dynamic state;

  ClipboardItem({required this.type, required this.state});
}

class GlobalClipboardManager extends ChangeNotifier {
  ClipboardItem? _copiedItem;

  /// Getter for copied item
  ClipboardItem? get copiedItem => _copiedItem;
  bool get hasCopied => _copiedItem != null;

  /// Copy function
  void copy(ClipboardItem item) {
    _copiedItem = item;
    debugPrint("📋 Copied item type: ${item.type}");
    notifyListeners();
  }

  /// Clear clipboard
  void clear() {
    _copiedItem = null;
    notifyListeners();
  }

  /// Unified Copy-Paste operation (Duplicate Widget)
  Future<void> duplicateWidget(BuildContext context) async {
    try {
      if (isMultiSelectEnabled && selectedWidgetIndices.isNotEmpty) {
        await context.multipleWidgetProvider.multiSelectWidgetCopy();
        if (!context.mounted) return;
        await context.multipleWidgetProvider.multiSelectWidgetPaste();
        return;
      }

      // Copy selected widget
      final copiedSuccessfully = await _copySelectedWidget(context);

      if (!copiedSuccessfully) {
        if (!context.mounted) return;
        DSnackBar.informationSnackBar(title: "error");
        return;
      }

      // Paste the copied widget
      if (!context.mounted) return;
      await _pasteCurrentWidget(context);
    } catch (e) {
      debugPrint("❌ Error in duplicate operation: $e");
    }
  }

  /// Copy the currently selected widget
  Future<bool> _copySelectedWidget(BuildContext context) async {
    clear();

    if (selectedTextIndex != -1 && textBorder == true) {
      await context.textEditingProvider.copyTextWidget();
      return _copiedItem != null;
    }

    if (selectedBarCodeIndex != -1 && barcodeBorder == true) {
      await context.barcodeProvider.copyBarcodeWidget();
      return _copiedItem != null;
    }

    if (selectedQRCodeIndex != -1 && qrcodeBorder == true) {
      await context.qrCodeProvider.copyQrcodeWidget();
      return _copiedItem != null;
    }

    if (selectedImageIndex != -1 && imageBorder == true) {
      await context.imageTakeProvider.copyImageWidget();
      return _copiedItem != null;
    }

    if (selectedTableIndex != -1 && tableBorder == true) {
      await context.tableProvider.copyTableWidget();
      return _copiedItem != null;
    }

    if (selectedEmojiIndex != -1 && emojiBorder == true) {
      await context.emojiProvider.copyEmojiWidget();
      return _copiedItem != null;
    }

    if (selectedShapeIndex != -1 && shapeBorder == true) {
      await context.shapeProvider.copyShapeWidget();
      return _copiedItem != null;
    }

    if (selectedLineIndex != -1 && lineBorder == true) {
      await context.lineProvider.copyLineWidget();
      return _copiedItem != null;
    }

    return false;
  }

  /// Paste the currently copied widget
  Future<void> _pasteCurrentWidget(BuildContext context) async {
    final clipboard = _copiedItem;
    if (clipboard == null) return;

    switch (clipboard.type) {
      case "text":
        await context.textEditingProvider.pasteTextWidget(clipboard);
        break;
      case "barcode":
        await context.barcodeProvider.pasteBarcodeWidget(clipboard);
        break;
      case "qrcode":
        await context.qrCodeProvider.pasteQrcodeWidget(clipboard);
        break;
      case "table":
        await context.tableProvider.pasteTableWidget(clipboard);
        break;
      case "image":
        await context.imageTakeProvider.pasteImageWidget(clipboard);
        break;
      case "emoji":
        await context.emojiProvider.pasteEmojiWidget(clipboard);
        break;
      case "shape":
        await context.shapeProvider.pasteShapeWidget(clipboard);
        break;
      case "line":
        await context.lineProvider.pasteLineWidget(clipboard);
        break;
      default:
        debugPrint("❌ Unknown paste type: ${clipboard.type}");
    }
  }
}
