import 'package:fluent_ui/fluent_ui.dart';

import '../../../../../utils/constants/enums.dart';
import '../../../../../common/font_load/font_load.dart';
import '../../../../../utils/snackbar_toast/snack_bar.dart';
import 'package:grozziie/utils/constants/icons.dart';
import 'package:grozziie/localization/main_texts.dart';
import '../../../../../common/font_load/font_family_model.dart';
import '../../../../../utils/constants/label_global_variable.dart';

class CommonFunctionProvider extends ChangeNotifier {
  double textFontSize = 25.0;

  final Map<String, String> fontTranslations = {
    "JosefinSans_Regular": "JosefinSans",
    "Arimo_Regular": "Arimo",
    "BebasNeue-Regular": "BebasNeue",
    "Comfortaa-Regular": "Comfortaa",
    "DMSans_18pt-Regular": "DMSans",
    "Figtree-Regular": "Figtree",
    "FjallaOne-Regular": "FjallaOne",
    "Inter_18pt-Regular": "Inter",
    "Jost-Regular": "Jost",
    "Lato-Regular": "Lato",
    "Manrope-Regular": "Manrope",
    "Montserrat-Regular": "Montserrat",
    "NotoSans-Regular": "NotoSans",
    "OpenSans-Regular": "OpenSans",
  };

  // helper method - rotation aware movement
  Offset applyRotationMove(Offset old, Offset delta, double rotation) {
    switch (rotation.toInt()) {
      case 0: // normal
        return Offset(old.dx + delta.dx, old.dy + delta.dy);
      case 1: // left
        return Offset(old.dx - delta.dx, old.dy + delta.dy);
      case 2: // up
        return Offset(old.dx - delta.dx, old.dy - delta.dy);
      case 3: // right
        return Offset(old.dx + delta.dx, old.dy - delta.dy);
      default:
        return old;
    }
  }

  /// Moving widget function
  void movingWidget({
    required DragUpdateDetails details,
    double rotation = 0.0,
  }) {
    final delta = details.delta;

    // multi widget move
    if (isMultiSelectEnabled) {
      for (final index in selectedWidgetIndices) {
        // TEXT
        if (index < textCodeOffsets.length) {
          textCodeOffsets[index] = applyRotationMove(
            textCodeOffsets[index],
            delta,
            rotation,
          );
        }
        // BARCODE
        else if (index - barcodeOffsetIndex < barCodeOffsets.length) {
          final i = index - barcodeOffsetIndex;
          barCodeOffsets[i] = applyRotationMove(
            barCodeOffsets[i],
            delta,
            rotation,
          );
        }
        // QR CODE
        else if (index - qrcodeOffsetIndex < qrCodeOffsets.length) {
          final i = index - qrcodeOffsetIndex;
          qrCodeOffsets[i] = Offset(
            qrCodeOffsets[i].dx + delta.dx,
            qrCodeOffsets[i].dy + delta.dy,
          );
        }
        // TABLE
        else if (index - tableOffsetIndex < tableOffsets.length) {
          final i = index - tableOffsetIndex;
          tableOffsets[i] = applyRotationMove(tableOffsets[i], delta, rotation);
        }
        // IMAGE
        else if (index - imageOffsetIndex < imageOffsets.length) {
          final i = index - imageOffsetIndex;
          imageOffsets[i] = applyRotationMove(imageOffsets[i], delta, rotation);
        }
        // EMOJI
        else if (index - emojiOffsetIndex < emojiCodeOffsets.length) {
          final i = index - emojiOffsetIndex;
          emojiCodeOffsets[i] = applyRotationMove(
            emojiCodeOffsets[i],
            delta,
            rotation,
          );
        }
        // SHAPE
        else if (index - shapeOffsetIndex < shapeOffsets.length) {
          final i = index - shapeOffsetIndex;
          shapeOffsets[i] = Offset(
            shapeOffsets[i].dx + delta.dx,
            shapeOffsets[i].dy + delta.dy,
          );
        }
        // LINE
        else if (index - lineOffsetIndex < lineOffsets.length) {
          final i = index - lineOffsetIndex;
          lineOffsets[i] = applyRotationMove(lineOffsets[i], delta, rotation);
        }
      }
    }
    // single widget move
    else {
      if (selectedTextIndex != -1 && textBorder == true) {
        if (isTextLock[selectedTextIndex]) return;
        textCodeOffsets[selectedTextIndex] = applyRotationMove(
          textCodeOffsets[selectedTextIndex],
          delta,
          rotation,
        );
      }
      // barcode
      else if (selectedBarCodeIndex != -1 && barcodeBorder == true) {
        if (isBarcodeLock[selectedBarCodeIndex]) return;
        barCodeOffsets[selectedBarCodeIndex] = applyRotationMove(
          barCodeOffsets[selectedBarCodeIndex],
          delta,
          rotation,
        );
      }
      //qrcode
      else if (selectedQRCodeIndex != -1 && qrcodeBorder == true) {
        if (isQrcodeLock[selectedQRCodeIndex]) return;
        qrCodeOffsets[selectedQRCodeIndex] = Offset(
          qrCodeOffsets[selectedQRCodeIndex].dx + delta.dx,
          qrCodeOffsets[selectedQRCodeIndex].dy + delta.dy,
        );
      }
      // table
      else if (selectedTableIndex != -1 && tableBorder == true) {
        if (isTableLock[selectedTableIndex]) return;
        tableOffsets[selectedTableIndex] = applyRotationMove(
          tableOffsets[selectedTableIndex],
          delta,
          rotation,
        );
      }
      // image
      else if (selectedImageIndex != -1 && imageBorder == true) {
        if (isImageLock[selectedImageIndex]) return;
        imageOffsets[selectedImageIndex] = applyRotationMove(
          imageOffsets[selectedImageIndex],
          delta,
          rotation,
        );
      }
      //emoji
      else if (selectedEmojiIndex != -1 && emojiBorder == true) {
        if (isEmojiLock[selectedEmojiIndex]) return;
        emojiCodeOffsets[selectedEmojiIndex] = applyRotationMove(
          emojiCodeOffsets[selectedEmojiIndex],
          delta,
          rotation,
        );
      }
      // shape
      else if (selectedShapeIndex != -1 && shapeBorder == true) {
        if (isShapeLock[selectedShapeIndex]) return;
        shapeOffsets[selectedShapeIndex] = Offset(
          shapeOffsets[selectedShapeIndex].dx + delta.dx,
          shapeOffsets[selectedShapeIndex].dy + delta.dy,
        );
      }
      // line
      else if (selectedLineIndex != -1 && lineBorder == true) {
        if (isLineLock[selectedLineIndex]) return;
        lineOffsets[selectedLineIndex] = applyRotationMove(
          lineOffsets[selectedLineIndex],
          delta,
          rotation,
        );
      }
    }
    notifyListeners();
  }

  /// show widget border and data input container flag
  Future<void> showBorderContainerFlag(
    WidgetType widgetType,
    bool value,
    int index,
  ) async {
    if (isMultiSelectEnabled) {
      if (_isWidgetLocked(index)) {
        DSnackBar.informationSnackBar(title: DTexts.instance.lockMessageWaring);
        return;
      }

      // Check if widget is rotated - rotated widgets cannot be added to multi-select
      if (_isWidgetRotated(index)) {
        DSnackBar.informationSnackBar(
          title: DTexts.instance.rotatedWidgetWarning,
        );
        return;
      }

      if (selectedWidgetIndices.contains(index)) {
        debugPrint('Widget already selected: $index');
      } else {
        selectedWidgetIndices.add(index);
        //showMultiSelectContainerFlag = true;

        // Close all containers
        showTextEditingContainerFlag = false;
        showBarcodeContainerFlag = false;
        showQrcodeContainerFlag = false;
        showTableContainerFlag = false;
        showImageContainerFlag = false;
        showDateContainerFlag = false;
        showEmojiContainerFlag = false;
        showSerialContainerFlag = false;
        showShapeContainerFlag = false;
        showLineContainerFlag = false;
        showBackgroundImageContainerFlag = false;
      }
      notifyListeners();
      return;
    }

    switch (widgetType) {
      case WidgetType.text:
        selectedTextIndex = index;
        textBorder = value;
        showTextEditingContainerFlag = value;
        textFocusNodes[index].requestFocus();

        // Border all
        barcodeBorder = false;
        qrcodeBorder = false;
        tableCellBorderOff();
        tableBorder = false;
        imageBorder = false;
        emojiBorder = false;
        shapeBorder = false;
        lineBorder = false;

        // container all
        showBarcodeContainerFlag = false;
        showQrcodeContainerFlag = false;
        showTableContainerFlag = false;
        showImageContainerFlag = false;
        showDateContainerFlag = false;
        showEmojiContainerFlag = false;
        showSerialContainerFlag = false;
        showShapeContainerFlag = false;
        showLineContainerFlag = false;
        showBackgroundImageContainerFlag = false;
        break;

      case WidgetType.barcode:
        selectedBarCodeIndex = index;
        barcodeBorder = value;
        showBarcodeContainerFlag = value;
        brFocusNodes[index].requestFocus();

        // Border all
        textBorder = false;
        qrcodeBorder = false;
        tableCellBorderOff();
        tableBorder = false;
        imageBorder = false;
        emojiBorder = false;
        shapeBorder = false;
        lineBorder = false;

        // container all
        showTextEditingContainerFlag = false;
        showQrcodeContainerFlag = false;
        showTableContainerFlag = false;
        showImageContainerFlag = false;
        showDateContainerFlag = false;
        showEmojiContainerFlag = false;
        showSerialContainerFlag = false;
        showShapeContainerFlag = false;
        showLineContainerFlag = false;
        showBackgroundImageContainerFlag = false;
        break;

      case WidgetType.qrcode:
        selectedQRCodeIndex = index;
        qrcodeBorder = value;
        showQrcodeContainerFlag = value;
        qrFocusNodes[index].requestFocus();

        // Border all
        textBorder = false;
        barcodeBorder = false;
        tableCellBorderOff();
        tableBorder = false;
        imageBorder = false;
        emojiBorder = false;
        shapeBorder = false;
        lineBorder = false;

        // container all
        showTextEditingContainerFlag = false;
        showBarcodeContainerFlag = false;
        showTableContainerFlag = false;
        showImageContainerFlag = false;
        showDateContainerFlag = false;
        showEmojiContainerFlag = false;
        showSerialContainerFlag = false;
        showShapeContainerFlag = false;
        showLineContainerFlag = false;
        showBackgroundImageContainerFlag = false;
        break;

      case WidgetType.table:
        selectedTableIndex = index;
        tableBorder = value;
        showTableContainerFlag = value;

        // Border all
        textBorder = false;
        barcodeBorder = false;
        qrcodeBorder = false;
        imageBorder = false;
        emojiBorder = false;
        shapeBorder = false;
        lineBorder = false;

        // container all
        showTextEditingContainerFlag = false;
        showBarcodeContainerFlag = false;
        showQrcodeContainerFlag = false;
        showImageContainerFlag = false;
        showDateContainerFlag = false;
        showEmojiContainerFlag = false;
        showSerialContainerFlag = false;
        showShapeContainerFlag = false;
        showLineContainerFlag = false;
        showBackgroundImageContainerFlag = false;
        break;

      case WidgetType.image:
        selectedImageIndex = index;
        imageBorder = value;
        showImageContainerFlag = value;

        // Border all
        textBorder = false;
        barcodeBorder = false;
        qrcodeBorder = false;
        tableCellBorderOff();
        tableBorder = false;
        emojiBorder = false;
        shapeBorder = false;
        lineBorder = false;

        // container all
        showTextEditingContainerFlag = false;
        showBarcodeContainerFlag = false;
        showQrcodeContainerFlag = false;
        showTableContainerFlag = false;
        showDateContainerFlag = false;
        showEmojiContainerFlag = false;
        showSerialContainerFlag = false;
        showShapeContainerFlag = false;
        showLineContainerFlag = false;
        showBackgroundImageContainerFlag = false;
        break;

      /*    case 'time':
        selectedTextIndex = index;
        showDateContainerFlag = value;
        textBorder = value;

        // Border all
        barcodeBorder = false;
        qrcodeBorder = false;
        tableCellBorderOff();
        tableBorder = false;
        imageBorder = false;
        emojiBorder = false;
        shapeBorder = false;
        lineBorder = false;

        // container all
        showTextEditingContainerFlag = false;
        showBarcodeContainerFlag = false;
        showQrcodeContainerFlag = false;
        showTableContainerFlag = false;
        showImageContainerFlag = false;
        showEmojiContainerFlag = false;
        showSerialContainerFlag = false;
        showShapeContainerFlag = false;
        showLineContainerFlag = false;
        showBackgroundImageContainerFlag = false;
        showLocalBackgroundImageContainerFlag = false;
        break;*/

      case WidgetType.emoji:
        selectedEmojiIndex = index;
        emojiBorder = value;
        showEmojiContainerFlag = value;

        // Border all
        textBorder = false;
        barcodeBorder = false;
        qrcodeBorder = false;
        tableCellBorderOff();
        tableBorder = false;
        imageBorder = false;
        shapeBorder = false;
        lineBorder = false;

        // container all
        showTextEditingContainerFlag = false;
        showBarcodeContainerFlag = false;
        showQrcodeContainerFlag = false;
        showTableContainerFlag = false;
        showImageContainerFlag = false;
        showDateContainerFlag = false;
        showSerialContainerFlag = false;
        showShapeContainerFlag = false;
        showLineContainerFlag = false;
        showBackgroundImageContainerFlag = false;
        break;

      /*      case 'serial':
        selectedTextIndex = index;
        textBorder = value;
        showSerialContainerFlag = value;

        // Border all
        barcodeBorder = false;
        qrcodeBorder = false;
        tableCellBorderOff();
        tableBorder = false;
        imageBorder = false;
        emojiBorder = false;
        shapeBorder = false;
        lineBorder = false;

        /// Container Widget Flag
        showTextEditingContainerFlag = false;
        showBarcodeContainerFlag = false;
        showQrcodeContainerFlag = false;
        showTableContainerFlag = false;
        showImageContainerFlag = false;
        showDateContainerFlag = false;
        showEmojiContainerFlag = false;
        showShapeContainerFlag = false;
        showLineContainerFlag = false;
        showBackgroundImageContainerFlag = false;
        showLocalBackgroundImageContainerFlag = false;
        break;*/

      case WidgetType.shape:
        selectedShapeIndex = index;
        shapeBorder = value;
        showShapeContainerFlag = value;

        // Border all
        textBorder = false;
        barcodeBorder = false;
        qrcodeBorder = false;
        tableCellBorderOff();
        tableBorder = false;
        imageBorder = false;
        emojiBorder = false;
        lineBorder = false;

        // container all
        showTextEditingContainerFlag = false;
        showBarcodeContainerFlag = false;
        showQrcodeContainerFlag = false;
        showTableContainerFlag = false;
        showImageContainerFlag = false;
        showDateContainerFlag = false;
        showEmojiContainerFlag = false;
        showSerialContainerFlag = false;
        showLineContainerFlag = false;
        showBackgroundImageContainerFlag = false;
        break;

      case WidgetType.line:
        selectedLineIndex = index;
        lineBorder = value;
        showLineContainerFlag = value;

        // Border all
        textBorder = false;
        barcodeBorder = false;
        qrcodeBorder = false;
        tableCellBorderOff();
        tableBorder = false;
        imageBorder = false;
        emojiBorder = false;
        shapeBorder = false;

        // container all
        showTextEditingContainerFlag = false;
        showBarcodeContainerFlag = false;
        showQrcodeContainerFlag = false;
        showTableContainerFlag = false;
        showImageContainerFlag = false;
        showDateContainerFlag = false;
        showEmojiContainerFlag = false;
        showSerialContainerFlag = false;
        showShapeContainerFlag = false;
        showBackgroundImageContainerFlag = false;
        break;
    }

    notifyListeners();
  }

  bool _isWidgetLocked(int index) {
    // TEXT
    if (index < barcodeOffsetIndex) {
      return isTextLock.length > index && isTextLock[index];
    }
    // BARCODE
    else if (index < qrcodeOffsetIndex) {
      final i = index - barcodeOffsetIndex;
      return isBarcodeLock.length > i && isBarcodeLock[i];
    }
    // QR CODE
    else if (index < tableOffsetIndex) {
      final i = index - qrcodeOffsetIndex;
      return isQrcodeLock.length > i && isQrcodeLock[i];
    }
    // TABLE
    else if (index < imageOffsetIndex) {
      final i = index - tableOffsetIndex;
      return isTableLock.length > i && isTableLock[i];
    }
    // IMAGE
    else if (index < emojiOffsetIndex) {
      final i = index - imageOffsetIndex;
      return isImageLock.length > i && isImageLock[i];
    }
    // EMOJI
    else if (index < shapeOffsetIndex) {
      final i = index - emojiOffsetIndex;
      return isEmojiLock.length > i && isEmojiLock[i];
    }
    // SHAPE
    else if (index < lineOffsetIndex) {
      final i = index - shapeOffsetIndex;
      return isShapeLock.length > i && isShapeLock[i];
    }
    // LINE
    else if (index >= lineOffsetIndex) {
      final i = index - lineOffsetIndex;
      return isLineLock.length > i && isLineLock[i];
    }
    return false; // Default to not locked
  }

  /// Check if widget is rotated
  bool _isWidgetRotated(int index) {
    // TEXT
    if (index < barcodeOffsetIndex) {
      return textContainerRotations.length > index &&
          textContainerRotations[index] != 0;
    }
    // BARCODE
    else if (index < qrcodeOffsetIndex) {
      final i = index - barcodeOffsetIndex;
      return barCodesContainerRotations.length > i &&
          barCodesContainerRotations[i] != 0;
    }
    // QR CODE (no rotation support, always return false)
    else if (index < tableOffsetIndex) {
      return false;
    }
    // TABLE
    else if (index < imageOffsetIndex) {
      final i = index - tableOffsetIndex;
      return tableContainerRotations.length > i &&
          tableContainerRotations[i] != 0;
    }
    // IMAGE
    else if (index < emojiOffsetIndex) {
      final i = index - imageOffsetIndex;
      return imageCodesContainerRotations.length > i &&
          imageCodesContainerRotations[i] != 0;
    }
    // EMOJI
    else if (index < shapeOffsetIndex) {
      final i = index - emojiOffsetIndex;
      return emojiCodesContainerRotations.length > i &&
          emojiCodesContainerRotations[i] != 0;
    }
    // SHAPE
    else if (index < lineOffsetIndex) {
      final i = index - shapeOffsetIndex;
      return shapeCodesContainerRotations.length > i &&
          shapeCodesContainerRotations[i] != 0;
    }
    // LINE
    else if (index >= lineOffsetIndex) {
      final i = index - lineOffsetIndex;
      return lineCodesContainerRotations.length > i &&
          lineCodesContainerRotations[i] != 0;
    }
    return false; // Default to not rotated
  }

  /// Widget Border Section
  Future<void> generateBorderOff(String flagToSet, bool value) async {
    isMultiSelectEnabled = false;
    selectedWidgetIndices.clear();
    if (flagToSet == 'text') {
      textBorder = value;
      showTextEditingContainerFlag = value;

      barcodeBorder = false;
      qrcodeBorder = false;
      imageBorder = false;
      shapeBorder = false;
      tableBorder = false;
      emojiBorder = false;
      tableCellBorderOff();

      /// Container Widget Flag
      showBarcodeContainerFlag = false;
      showQrcodeContainerFlag = false;
      showTableContainerFlag = false;
      showImageContainerFlag = false;
      showShapeContainerFlag = false;
      showSerialContainerFlag = false;
    } else if (flagToSet == 'barcode') {
      barcodeBorder = value;
      showBarcodeContainerFlag = value;

      textBorder = false;
      qrcodeBorder = false;
      imageBorder = false;
      shapeBorder = false;
      tableBorder = false;
      emojiBorder = false;
      tableCellBorderOff();

      /// Container Widget Flag
      showTextEditingContainerFlag = false;
      showQrcodeContainerFlag = false;
      showTableContainerFlag = false;
      showImageContainerFlag = false;
      showShapeContainerFlag = false;
      showSerialContainerFlag = false;
    } else if (flagToSet == 'qrcode') {
      qrcodeBorder = value;
      showQrcodeContainerFlag = value;

      textBorder = false;
      barcodeBorder = false;
      imageBorder = false;
      shapeBorder = false;
      tableBorder = false;
      emojiBorder = false;

      /// Container Widget Flag
      showTextEditingContainerFlag = false;
      showBarcodeContainerFlag = false;
      showTableContainerFlag = false;
      showImageContainerFlag = false;
      showShapeContainerFlag = false;
      showSerialContainerFlag = false;
      tableCellBorderOff();
    } else if (flagToSet == 'table') {
      tableBorder = value;
      showTableContainerFlag = value;

      textBorder = false;
      barcodeBorder = false;
      qrcodeBorder = false;
      imageBorder = false;
      shapeBorder = false;
      emojiBorder = false;

      /// Container Widget Flag
      showTextEditingContainerFlag = false;
      showBarcodeContainerFlag = false;
      showImageContainerFlag = false;
      showShapeContainerFlag = false;
      showSerialContainerFlag = false;
    } else if (flagToSet == 'image') {
      imageBorder = value;
      showImageContainerFlag = value;

      textBorder = false;
      barcodeBorder = false;
      qrcodeBorder = false;
      shapeBorder = false;
      tableBorder = false;
      emojiBorder = false;

      /// Container Widget Flag
      showTextEditingContainerFlag = false;
      showBarcodeContainerFlag = false;
      showTableContainerFlag = false;
      showShapeContainerFlag = false;
      showSerialContainerFlag = false;
      tableCellBorderOff();
    } else if (flagToSet == 'time') {
      textBorder = value;
      showDateContainerFlag = value;

      barcodeBorder = false;
      qrcodeBorder = false;
      imageBorder = false;
      shapeBorder = false;
      tableBorder = false;
      emojiBorder = false;

      /// Container Widget Flag
      showTextEditingContainerFlag = false;
      showBarcodeContainerFlag = false;
      showQrcodeContainerFlag = false;
      showTableContainerFlag = false;
      showImageContainerFlag = false;
      showShapeContainerFlag = false;
      showSerialContainerFlag = false;
      tableCellBorderOff();
    } else if (flagToSet == 'emoji') {
      emojiBorder = value;

      textBorder = false;
      barcodeBorder = false;
      qrcodeBorder = false;
      imageBorder = false;
      shapeBorder = false;
      tableBorder = false;
      tableCellBorderOff();
    } else if (flagToSet == 'serial') {
      textBorder = value;
      showSerialContainerFlag = value;

      barcodeBorder = false;
      qrcodeBorder = false;
      imageBorder = false;
      shapeBorder = false;
      tableBorder = false;
      emojiBorder = false;

      /// Container Widget Flag
      showTextEditingContainerFlag = false;
      showBarcodeContainerFlag = false;
      showQrcodeContainerFlag = false;
      showTableContainerFlag = false;
      showImageContainerFlag = false;
      showShapeContainerFlag = false;
      showDateContainerFlag = false;
      tableCellBorderOff();
    } else if (flagToSet == 'shape') {
      shapeBorder = value;
      showShapeContainerFlag = value;

      textBorder = false;
      barcodeBorder = false;
      qrcodeBorder = false;
      imageBorder = false;
      tableBorder = false;
      emojiBorder = false;

      /// Container Widget Flag
      showTextEditingContainerFlag = false;
      showBarcodeContainerFlag = false;
      showTableContainerFlag = false;
      showImageContainerFlag = false;
      showSerialContainerFlag = false;
      tableCellBorderOff();
    } else if (flagToSet == 'line') {
      lineBorder = value;
      showLineContainerFlag = value;

      // Border all
      barcodeBorder = false;
      qrcodeBorder = false;
      emojiBorder = false;
      tableBorder = false;
      textBorder = false;
      shapeBorder = false;
      tableCellBorderOff();

      // container all
      showTextEditingContainerFlag = false;
      showBarcodeContainerFlag = false;
      showTableContainerFlag = false;
      showQrcodeContainerFlag = false;
      showImageContainerFlag = false;
      showDateContainerFlag = false;
      showEmojiContainerFlag = false;
      showSerialContainerFlag = false;
      showShapeContainerFlag = false;
      showSerialContainerFlag = false;
    }
    notifyListeners();
  }

  /// Table selected border off
  void tableCellBorderOff() {
    for (int j = 0; j < tablesCells.length; j++) {
      for (var cell in tablesCells[j]) {
        cell.isTapped = false;
        cell.isLongPressed = false;
      }
      tablesSelectedCells[j].clear();
    }
  }

  /// Font size change
  void changeFontSize({
    required double fontValue,
    required List<double> selectListTextFontSize,
    required int selectIndex,
    Function? saveCurrentWidgetState,
  }) {
    if (isMultiSelectEnabled && selectedWidgetIndices.isNotEmpty) {
      for (int i in selectedWidgetIndices) {
        if (i < selectListTextFontSize.length) {
          selectListTextFontSize[i] = fontValue;
        }
      }
    } else {
      selectListTextFontSize[selectIndex] = fontValue;
    }

    saveCurrentWidgetState?.call();
    notifyListeners();
  }

  /// Bold toggle
  void toggleBold({
    required List<bool> selectListTextBold,
    required int selectedIndex,
    required Function saveCurrentWidgetState,
  }) {
    if (isMultiSelectEnabled && selectedWidgetIndices.isNotEmpty) {
      final bool targetState = selectedWidgetIndices
          .where((i) => i < selectListTextBold.length)
          .any((i) => !selectListTextBold[i]);

      for (int i in selectedWidgetIndices) {
        if (i < selectListTextBold.length) {
          selectListTextBold[i] = targetState;
        }
      }
    } else {
      if (selectedIndex >= 0 && selectedIndex < selectListTextBold.length) {
        selectListTextBold[selectedIndex] = !selectListTextBold[selectedIndex];
      }
    }

    saveCurrentWidgetState();
    notifyListeners();
  }

  /// Italic toggle
  void toggleItalic({
    required List<bool> selectListTextItalic,
    required int selectedIndex,
    required Function saveCurrentWidgetState,
  }) {
    if (isMultiSelectEnabled && selectedWidgetIndices.isNotEmpty) {
      // If ANY selected text is not italic, make ALL selected texts italic.
      final bool targetState = selectedWidgetIndices
          .where((i) => i < selectListTextItalic.length)
          .any((i) => !selectListTextItalic[i]);

      for (int i in selectedWidgetIndices) {
        if (i < selectListTextItalic.length) {
          selectListTextItalic[i] = targetState;
        }
      }
    } else {
      // For single-select, just toggle the current state.
      if (selectedIndex >= 0 && selectedIndex < selectListTextItalic.length) {
        selectListTextItalic[selectedIndex] =
            !selectListTextItalic[selectedIndex];
      }
    }

    saveCurrentWidgetState();
    notifyListeners();
  }

  /// Underline toggle
  void toggleTextUnderline({
    required int selectedIndex,
    required List<bool> selectListTestUnderline,
    required List<bool> isListTextStrikeThrough,
    required Function saveCurrentWidgetState,
  }) {
    if (isMultiSelectEnabled && selectedWidgetIndices.isNotEmpty) {
      final bool targetState = selectedWidgetIndices
          .where((i) => i < selectListTestUnderline.length)
          .any((i) => !selectListTestUnderline[i]);

      for (int i in selectedWidgetIndices) {
        if (i < selectListTestUnderline.length) {
          selectListTestUnderline[i] = targetState;
          if (targetState) {
            isListTextStrikeThrough[i] = false;
          }
        }
      }
    } else {
      if (selectedIndex >= 0 &&
          selectedIndex < selectListTestUnderline.length) {
        selectListTestUnderline[selectedIndex] =
            !selectListTestUnderline[selectedIndex];
        if (selectListTestUnderline[selectedIndex]) {
          isListTextStrikeThrough[selectedIndex] = false;
        }
      }
    }

    saveCurrentWidgetState();
    notifyListeners();
  }

  /// Strike toggle
  void toggleStrikeThrough({
    required int selectedIndex,
    required List<bool> selectListTextStrikeThrough,
    required List<bool> isListTextUnderline,
    required Function saveCurrentWidgetState,
  }) {
    //
    if (isMultiSelectEnabled && selectedWidgetIndices.isNotEmpty) {
      final bool targetStrikeState = selectedWidgetIndices
          .where((i) => i < selectListTextStrikeThrough.length)
          .any((i) => !selectListTextStrikeThrough[i]);

      for (int i in selectedWidgetIndices) {
        if (i < selectListTextStrikeThrough.length) {
          selectListTextStrikeThrough[i] = targetStrikeState;
          if (targetStrikeState) {
            isListTextUnderline[i] = false;
          }
        }
      }
    } else {
      // For single-select, just toggle.
      if (selectedIndex >= 0 &&
          selectedIndex < selectListTextStrikeThrough.length) {
        selectListTextStrikeThrough[selectedIndex] =
            !selectListTextStrikeThrough[selectedIndex];
        if (selectListTextStrikeThrough[selectedIndex]) {
          isListTextUnderline[selectedIndex] = false;
        }
      }
    }

    saveCurrentWidgetState();
    notifyListeners();
  }

  /// Alignment change
  void changeAlignment(
    List<TextAlign> updateTextAlignment,
    int selectedTextCodeIndex,
    TextAlign alignment,
    Function saveCurrentWidgetState,
  ) {
    if (isMultiSelectEnabled && selectedWidgetIndices.isNotEmpty) {
      for (int i in selectedWidgetIndices) {
        if (i < updateTextAlignment.length) {
          updateTextAlignment[i] = alignment;
        }
      }
    } else {
      updateTextAlignment[selectedTextCodeIndex] = alignment;
    }

    saveCurrentWidgetState();
    notifyListeners();
  }

  /// Text position left
  void alignmentLeft({
    required int index,
    required List<Offset> currentOffset,
    required Function saveCurrentWidgetState,
  }) {
    currentOffset[index] = Offset(
      currentOffset[index].dx - 1,
      currentOffset[index].dy,
    );

    saveCurrentWidgetState();
    notifyListeners();
  }

  /// Text position right
  void alignmentRight({
    required int index,
    required List<Offset> currentOffset,
    required Function saveCurrentWidgetState,
  }) {
    currentOffset[index] = Offset(
      currentOffset[index].dx + 1,
      currentOffset[index].dy,
    );

    saveCurrentWidgetState();
    notifyListeners();
  }

  /// Text position top
  void alignmentTop({
    required int index,
    required List<Offset> currentOffset,
    required Function saveCurrentWidgetState,
  }) {
    final newDy = currentOffset[index].dy - 1;
    currentOffset[index] = Offset(
      currentOffset[index].dx,
      newDy < 1 ? 1 : newDy,
    );

    saveCurrentWidgetState();
    notifyListeners();
  }

  /// Text position top
  void alignmentBottom({
    required int index,
    required List<Offset> currentOffset,
    required Function saveCurrentWidgetState,
  }) {
    // Get the maximum allowed position for the bottom boundary
    final maxDy = 700.0 - 1;

    // Incrementally move down by 5 units
    final newDy = currentOffset[index].dy + 1;
    currentOffset[index] = Offset(
      currentOffset[index].dx,
      newDy > maxDy ? maxDy : newDy,
    );

    saveCurrentWidgetState();
    notifyListeners();
  }

  /// Text font family
  void changeFontFamily(
    String? newFont,
    List<String> textSelectedFontFamily,
    int selectedTextIndex,
    Function saveCurrentWidgetState,
  ) async {
    if (newFont != null) {
      try {
        final selected = allFonts.firstWhere(
          (f) => f.name == newFont,
          orElse: () {
            debugPrint('❌ Font not found: $newFont');
            return FontData(name: '', ext: '');
          },
        );
        if (selected.name.isEmpty || selected.ext.isEmpty) return;
        await loadFontFromJson(selected);

        if (isMultiSelectEnabled && selectedWidgetIndices.isNotEmpty) {
          for (int i in selectedWidgetIndices) {
            if (i < textSelectedFontFamily.length) {
              textSelectedFontFamily[i] = newFont;
            }
          }
        }
        // single widget mode
        else {
          textSelectedFontFamily[selectedTextIndex] = newFont;
        }

        saveCurrentWidgetState();
        notifyListeners();
      } catch (e) {
        debugPrint('Error changing font: $e');
      }
    }
  }

  String getTranslatedFontValueForDropdown(
    String? internalKey,
    Map<String, String> translations,
  ) {
    return translations[internalKey] ?? translations.values.first;
  }

  /// Widget Rotation Section
  void rotateFunction({
    required List<double> rotations,
    required int selectedIndex,
    required Function saveCurrentWidgetState,
  }) {
    final i = selectedIndex;
    rotations[i] = (rotations[i] + 1) % 4;

    saveCurrentWidgetState();
    notifyListeners();
  }

  /// Widget Lock Section
  void widgetLockToggle({
    required int index,
    required List<bool> lockList,
    required Function saveCurrentWidgetState,
  }) {
    lockList[index] = !lockList[index];

    saveCurrentWidgetState();
    notifyListeners();
  }

  String getIcon() {
    final isLocked = _getCurrentLockState();
    return isLocked ? DIcons.unlock : DIcons.locked;
  }

  bool _getCurrentLockState() {
    if (textBorder &&
        isTextLock.isNotEmpty &&
        selectedTextIndex < isTextLock.length) {
      return isTextLock[selectedTextIndex];
    } else if (barcodeBorder &&
        isBarcodeLock.isNotEmpty &&
        selectedBarCodeIndex < isBarcodeLock.length) {
      return isBarcodeLock[selectedBarCodeIndex];
    } else if (qrcodeBorder &&
        isQrcodeLock.isNotEmpty &&
        selectedQRCodeIndex < isQrcodeLock.length) {
      return isQrcodeLock[selectedQRCodeIndex];
    } else if (tableBorder &&
        isTableLock.isNotEmpty &&
        selectedTableIndex < isTableLock.length) {
      return isTableLock[selectedTableIndex];
    } else if (imageBorder &&
        isImageLock.isNotEmpty &&
        selectedImageIndex < isImageLock.length) {
      return isImageLock[selectedImageIndex];
    } else if (emojiBorder &&
        isEmojiLock.isNotEmpty &&
        selectedEmojiIndex < isEmojiLock.length) {
      return isEmojiLock[selectedEmojiIndex];
    } else if (shapeBorder &&
        isShapeLock.isNotEmpty &&
        selectedShapeIndex < isShapeLock.length) {
      return isShapeLock[selectedShapeIndex];
    } else if (lineBorder &&
        isLineLock.isNotEmpty &&
        selectedLineIndex < isLineLock.length) {
      return isLineLock[selectedLineIndex];
    }
    return false;
  }

  /// Clear all widget border
  Future<void> clearAllBorder() async {
    /// All border
    textBorder = false;
    barcodeBorder = false;
    qrcodeBorder = false;
    imageBorder = false;
    shapeBorder = false;
    tableBorder = false;
    emojiBorder = false;
    lineBorder = false;
    tableCellBorderOff();

    /// all container flag
    showTextEditingContainerFlag = false;
    showBarcodeContainerFlag = false;
    showQrcodeContainerFlag = false;
    showTableContainerFlag = false;
    showImageContainerFlag = false;
    showDateContainerFlag = false;
    showEmojiContainerFlag = false;
    showLineContainerFlag = false;
    showShapeContainerFlag = false;
    showSerialContainerFlag = false;
    showBackgroundImageContainerFlag = false;

    // isMultiSelectEnabled = false;
    // selectedWidgetIndices.clear();
    // showMultiSelectContainerFlag = false;
    notifyListeners();
  }

  Future<void> clearMultipleBorder() async {
    isMultiSelectEnabled = false;
    selectedWidgetIndices.clear();
    //showMultiSelectContainerFlag = false;
    notifyListeners();
  }

  /// Clear all widget border
  Future<void> printAllContainerBorder() async {
    /// All border
    textBorder = false;
    barcodeBorder = false;
    qrcodeBorder = false;
    imageBorder = false;
    shapeBorder = false;
    tableBorder = false;
    emojiBorder = false;
    lineBorder = false;
    tableCellBorderOff();
    showBackgroundImageWidget = false;
    showBackgroundImageWidget = false;

    /// all container flag
    showTextEditingContainerFlag = false;
    showBarcodeContainerFlag = false;
    showQrcodeContainerFlag = false;
    showTableContainerFlag = false;
    showImageContainerFlag = false;
    showDateContainerFlag = false;
    showEmojiContainerFlag = false;
    showLineContainerFlag = false;
    showShapeContainerFlag = false;
    showSerialContainerFlag = false;
    showBackgroundImageContainerFlag = false;

    isMultiSelectEnabled = false;
    selectedWidgetIndices.clear();
    //showMultiSelectContainerFlag = false;
    notifyListeners();
  }
}
