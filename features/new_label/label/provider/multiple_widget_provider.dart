import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grozziie/localization/main_texts.dart';
import '../../../../utils/constants/label_global_variable.dart';
import '../../../../utils/extension/global_context.dart';
import '../../../../utils/extension/null_check_extension.dart';
import '../../../../utils/extension/provider_extension.dart';
import '../../../../utils/snackbar_toast/snack_bar.dart';

class MultipleWidgetProvider extends ChangeNotifier {
  Map<String, dynamic>? multiSelectClipboard;

  void multiSelectWidget(bool v) async {
    selectedWidgetIndices.clear();

    isMultiSelectEnabled = v;
    //showMultiSelectContainerFlag = true;
    notifyListeners();
  }

  /// Get bounding box for all selected widgets
  Rect? getMultiSelectBoundingBox() {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty) return null;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    // Track how many valid (non-rotated) widgets we found
    int validWidgetCount = 0;

    for (int index in selectedWidgetIndices) {
      double widgetLeft = 0;
      double widgetTop = 0;
      double widgetRight = 0;
      double widgetBottom = 0;

      // Text widget
      if (index < barcodeOffsetIndex) {
        // Skip rotated text widgets
        if (index < textContainerRotations.length && textContainerRotations[index] != 0) {
          continue;
        }
        widgetLeft = textCodeOffsets[index].dx;
        widgetTop = textCodeOffsets[index].dy;
        widgetRight = widgetLeft + updateTextWidthSize[index];
        widgetBottom = widgetTop + updateTextHeightSize[index];
      }
      // Barcode widget
      else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        // Skip rotated barcode widgets
        if (i < barCodesContainerRotations.length && barCodesContainerRotations[i] != 0) {
          continue;
        }
        widgetLeft = barCodeOffsets[i].dx;
        widgetTop = barCodeOffsets[i].dy;
        widgetRight = widgetLeft + updateBarcodeWidth[i];
        widgetBottom = widgetTop + updateBarcodeHeight[i];
      }
      // QR Code widget (no rotation support, include normally)
      else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        widgetLeft = qrCodeOffsets[i].dx;
        widgetTop = qrCodeOffsets[i].dy;
        widgetRight = widgetLeft + updateQrcodeSize[i];
        widgetBottom = widgetTop + updateQrcodeSize[i];
      }
      // Table widget
      else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        // Skip rotated table widgets
        if (i < tableContainerRotations.length && tableContainerRotations[i] != 0) {
          continue;
        }
        double totalTableWidth = 0;
        double totalTableHeight = 0;

        if (i < tablesColumnWidths.length) {
          for (var colWidth in tablesColumnWidths[i]) {
            totalTableWidth += colWidth;
          }
        }
        if (i < tablesRowHeights.length) {
          for (var rowHeight in tablesRowHeights[i]) {
            totalTableHeight += rowHeight;
          }
        }

        widgetLeft = tableOffsets[i].dx;
        widgetTop = tableOffsets[i].dy;
        widgetRight = widgetLeft + totalTableWidth;
        widgetBottom = widgetTop + totalTableHeight;
      }
      // Image widget
      else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        // Skip rotated image widgets
        if (i < imageCodesContainerRotations.length && imageCodesContainerRotations[i] != 0) {
          continue;
        }
        widgetLeft = imageOffsets[i].dx;
        widgetTop = imageOffsets[i].dy;
        widgetRight = widgetLeft + updateImageSize[i];
        widgetBottom = widgetTop + updateImageSize[i];
      }
      // Emoji widget
      else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        // Skip rotated emoji widgets
        if (i < emojiCodesContainerRotations.length && emojiCodesContainerRotations[i] != 0) {
          continue;
        }
        widgetLeft = emojiCodeOffsets[i].dx;
        widgetTop = emojiCodeOffsets[i].dy;
        widgetRight = widgetLeft + updatedEmojiWidth[i];
        widgetBottom = widgetTop + updatedEmojiWidth[i];
      }
      // Shape widget
      else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        // Skip rotated shape widgets
        if (i < shapeCodesContainerRotations.length && shapeCodesContainerRotations[i] != 0) {
          continue;
        }
        widgetLeft = shapeOffsets[i].dx;
        widgetTop = shapeOffsets[i].dy;
        widgetRight = widgetLeft + updateShapeWidth[i];
        widgetBottom = widgetTop + updateShapeHeight[i];
      }
      // Line widget
      else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        // Skip rotated line widgets
        if (i < lineCodesContainerRotations.length && lineCodesContainerRotations[i] != 0) {
          continue;
        }
        widgetLeft = lineOffsets[i].dx;
        widgetTop = lineOffsets[i].dy;
        widgetRight = widgetLeft + updateLineWidth[i];
        widgetBottom = widgetTop + updateSliderLineWidth[i] + 30;
      }

      validWidgetCount++;
      minX = min(minX, widgetLeft);
      minY = min(minY, widgetTop);
      maxX = max(maxX, widgetRight);
      maxY = max(maxY, widgetBottom);
    }

    // If no valid non-rotated widgets found
    if (validWidgetCount == 0) return null;

    return Rect.fromLTRB(minX - 10, minY - 10, maxX + 10, maxY + 10);
  }

  /// ==================  Move all widgets LEFT RIGHT TOP BOTTOM ==================
  void multiSelectMoveLeft() {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty) return;

    for (int index in selectedWidgetIndices) {
      // Text widget
      if (index < barcodeOffsetIndex) {
        textCodeOffsets[index] = Offset(textCodeOffsets[index].dx - 1, textCodeOffsets[index].dy);
      }
      // Barcode widget
      else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        barCodeOffsets[i] = Offset(barCodeOffsets[i].dx - 1, barCodeOffsets[i].dy);
      }
      // QR Code widget
      else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        qrCodeOffsets[i] = Offset(qrCodeOffsets[i].dx - 1, qrCodeOffsets[i].dy);
      }
      // Table widget
      else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        tableOffsets[i] = Offset(tableOffsets[i].dx - 1, tableOffsets[i].dy);
      }
      // Image widget
      else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        imageOffsets[i] = Offset(imageOffsets[i].dx - 1, imageOffsets[i].dy);
      }
      // Emoji widget
      else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        emojiCodeOffsets[i] = Offset(emojiCodeOffsets[i].dx - 1, emojiCodeOffsets[i].dy);
      }
      // Shape widget
      else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        shapeOffsets[i] = Offset(shapeOffsets[i].dx - 1, shapeOffsets[i].dy);
      }
      // Line widget
      else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        lineOffsets[i] = Offset(lineOffsets[i].dx - 1, lineOffsets[i].dy);
      }
    }

    notifyListeners();
  }

  void multiSelectMoveRight() {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty) return;

    for (int index in selectedWidgetIndices) {
      // Text widget
      if (index < barcodeOffsetIndex) {
        textCodeOffsets[index] = Offset(textCodeOffsets[index].dx + 1, textCodeOffsets[index].dy);
      }
      // Barcode widget
      else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        barCodeOffsets[i] = Offset(barCodeOffsets[i].dx + 1, barCodeOffsets[i].dy);
      }
      // QR Code widget
      else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        qrCodeOffsets[i] = Offset(qrCodeOffsets[i].dx + 1, qrCodeOffsets[i].dy);
      }
      // Table widget
      else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        tableOffsets[i] = Offset(tableOffsets[i].dx + 1, tableOffsets[i].dy);
      }
      // Image widget
      else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        imageOffsets[i] = Offset(imageOffsets[i].dx + 1, imageOffsets[i].dy);
      }
      // Emoji widget
      else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        emojiCodeOffsets[i] = Offset(emojiCodeOffsets[i].dx + 1, emojiCodeOffsets[i].dy);
      }
      // Shape widget
      else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        shapeOffsets[i] = Offset(shapeOffsets[i].dx + 1, shapeOffsets[i].dy);
      }
      // Line widget
      else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        lineOffsets[i] = Offset(lineOffsets[i].dx + 1, lineOffsets[i].dy);
      }
    }

    notifyListeners();
  }

  void multiSelectMoveTop() {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty) return;

    for (int index in selectedWidgetIndices) {
      // Text widget
      if (index < barcodeOffsetIndex) {
        final newDy = textCodeOffsets[index].dy - 1;
        textCodeOffsets[index] = Offset(textCodeOffsets[index].dx, newDy < 1 ? 1 : newDy);
      }
      // Barcode widget
      else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        final newDy = barCodeOffsets[i].dy - 1;
        barCodeOffsets[i] = Offset(barCodeOffsets[i].dx, newDy < 1 ? 1 : newDy);
      }
      // QR Code widget
      else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        final newDy = qrCodeOffsets[i].dy - 1;
        qrCodeOffsets[i] = Offset(qrCodeOffsets[i].dx, newDy < 1 ? 1 : newDy);
      }
      // Table widget
      else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        final newDy = tableOffsets[i].dy - 1;
        tableOffsets[i] = Offset(tableOffsets[i].dx, newDy < 1 ? 1 : newDy);
      }
      // Image widget
      else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        final newDy = imageOffsets[i].dy - 1;
        imageOffsets[i] = Offset(imageOffsets[i].dx, newDy < 1 ? 1 : newDy);
      }
      // Emoji widget
      else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        final newDy = emojiCodeOffsets[i].dy - 1;
        emojiCodeOffsets[i] = Offset(emojiCodeOffsets[i].dx, newDy < 1 ? 1 : newDy);
      }
      // Shape widget
      else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        final newDy = shapeOffsets[i].dy - 1;
        shapeOffsets[i] = Offset(shapeOffsets[i].dx, newDy < 1 ? 1 : newDy);
      }
      // Line widget
      else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        final newDy = lineOffsets[i].dy - 1;
        lineOffsets[i] = Offset(lineOffsets[i].dx, newDy < 1 ? 1 : newDy);
      }
    }

    notifyListeners();
  }

  void multiSelectMoveBottom() {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty) return;

    final maxDy = 0.46.sh - 1;

    for (int index in selectedWidgetIndices) {
      // Text widget
      if (index < barcodeOffsetIndex) {
        final newDy = textCodeOffsets[index].dy + 1;
        textCodeOffsets[index] = Offset(textCodeOffsets[index].dx, newDy > maxDy ? maxDy : newDy);
      }
      // Barcode widget
      else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        final newDy = barCodeOffsets[i].dy + 1;
        barCodeOffsets[i] = Offset(barCodeOffsets[i].dx, newDy > maxDy ? maxDy : newDy);
      }
      // QR Code widget
      else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        final newDy = qrCodeOffsets[i].dy + 1;
        qrCodeOffsets[i] = Offset(qrCodeOffsets[i].dx, newDy > maxDy ? maxDy : newDy);
      }
      // Table widget
      else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        final newDy = tableOffsets[i].dy + 1;
        tableOffsets[i] = Offset(tableOffsets[i].dx, newDy > maxDy ? maxDy : newDy);
      }
      // Image widget
      else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        final newDy = imageOffsets[i].dy + 1;
        imageOffsets[i] = Offset(imageOffsets[i].dx, newDy > maxDy ? maxDy : newDy);
      }
      // Emoji widget
      else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        final newDy = emojiCodeOffsets[i].dy + 1;
        emojiCodeOffsets[i] = Offset(emojiCodeOffsets[i].dx, newDy > maxDy ? maxDy : newDy);
      }
      // Shape widget
      else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        final newDy = shapeOffsets[i].dy + 1;
        shapeOffsets[i] = Offset(shapeOffsets[i].dx, newDy > maxDy ? maxDy : newDy);
      }
      // Line widget
      else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        final newDy = lineOffsets[i].dy + 1;
        lineOffsets[i] = Offset(lineOffsets[i].dx, newDy > maxDy ? maxDy : newDy);
      }
    }

    notifyListeners();
  }

  /// ================== VERTICAL SPACING CONTROL DECREASE, INCREASE, CENTER ==================
  WidgetIndexInfo getWidgetTypeByGlobalIndex(int index) {
    if (index < textOffsetIndex + textCodeOffsets.length) {
      return WidgetIndexInfo(type: 'text', localIndex: index - textOffsetIndex);
    } else if (index < barcodeOffsetIndex + barCodeOffsets.length) {
      return WidgetIndexInfo(type: 'barcode', localIndex: index - barcodeOffsetIndex);
    } else if (index < qrcodeOffsetIndex + qrCodeOffsets.length) {
      return WidgetIndexInfo(type: 'qrcode', localIndex: index - qrcodeOffsetIndex);
    } else if (index < tableOffsetIndex + tableOffsets.length) {
      return WidgetIndexInfo(type: 'table', localIndex: index - tableOffsetIndex);
    } else if (index < imageOffsetIndex + imageOffsets.length) {
      return WidgetIndexInfo(type: 'image', localIndex: index - imageOffsetIndex);
    } else if (index < emojiOffsetIndex + emojiCodeOffsets.length) {
      return WidgetIndexInfo(type: 'emoji', localIndex: index - emojiOffsetIndex);
    } else if (index < shapeOffsetIndex + shapeOffsets.length) {
      return WidgetIndexInfo(type: 'shape', localIndex: index - shapeOffsetIndex);
    } else if (index < lineOffsetIndex + lineOffsets.length) {
      return WidgetIndexInfo(type: 'line', localIndex: index - lineOffsetIndex);
    } else {
      throw Exception('Invalid widget index: $index');
    }
  }

  void decreaseVerticalSpacing(BuildContext context) {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty || selectedWidgetIndices.length < 2) {
      DSnackBar.informationSnackBar(title: DTexts.instance.spaceWaring);
      return;
    }

    // Get all selected widgets and sort by Y position
    final allIndices = List<int>.from(selectedWidgetIndices);

    // Create list with position data for sorting
    List<MapEntry<int, double>> indexWithY = [];
    for (int index in allIndices) {
      // Get Y position based on widget type
      double yPos = 0;
      if (index < barcodeOffsetIndex) {
        yPos = textCodeOffsets[index].dy;
      } else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        yPos = barCodeOffsets[i].dy;
      } else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        yPos = qrCodeOffsets[i].dy;
      } else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        yPos = tableOffsets[i].dy;
      } else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        yPos = imageOffsets[i].dy;
      } else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        yPos = emojiCodeOffsets[i].dy;
      } else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        yPos = shapeOffsets[i].dy;
      } else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        yPos = lineOffsets[i].dy;
      }

      indexWithY.add(MapEntry(index, yPos));
    }

    // Sort by Y position (top to bottom)
    indexWithY.sort((a, b) => a.value.compareTo(b.value));
    final sortedIndices = indexWithY.map((e) => e.key).toList();

    // Move widgets closer by reducing gap
    const reduction = 2.0;
    for (int i = 1; i < sortedIndices.length; i++) {
      final currentIndex = sortedIndices[i];
      final previousIndex = sortedIndices[i - 1];

      // Calculate height of previous widget
      double previousHeight = 0;
      if (previousIndex < barcodeOffsetIndex) {
        previousHeight = updateTextHeightSize[previousIndex];
      } else if (previousIndex < qrcodeOffsetIndex) {
        final p = previousIndex - barcodeOffsetIndex;
        previousHeight = updateBarcodeHeight[p];
      } else if (previousIndex < tableOffsetIndex) {
        final p = previousIndex - qrcodeOffsetIndex;
        previousHeight = updateQrcodeSize[p];
      } else if (previousIndex < imageOffsetIndex) {
        //final p = previousIndex - tableOffsetIndex;
        previousHeight = 0; // Table height calculated differently
      } else if (previousIndex < emojiOffsetIndex) {
        final p = previousIndex - imageOffsetIndex;
        previousHeight = updateImageSize[p];
      } else if (previousIndex < shapeOffsetIndex) {
        final p = previousIndex - emojiOffsetIndex;
        previousHeight = updatedEmojiWidth[p];
      } else if (previousIndex < lineOffsetIndex) {
        final p = previousIndex - shapeOffsetIndex;
        previousHeight = updateShapeHeight[p];
      } else if (previousIndex >= lineOffsetIndex) {
        final p = previousIndex - lineOffsetIndex;
        previousHeight = updateSliderLineWidth[p];
      }

      // Get previous widget Y position
      double previousY = 0;
      if (previousIndex < barcodeOffsetIndex) {
        previousY = textCodeOffsets[previousIndex].dy;
      } else if (previousIndex < qrcodeOffsetIndex) {
        final p = previousIndex - barcodeOffsetIndex;
        previousY = barCodeOffsets[p].dy;
      } else if (previousIndex < tableOffsetIndex) {
        final p = previousIndex - qrcodeOffsetIndex;
        previousY = qrCodeOffsets[p].dy;
      } else if (previousIndex < imageOffsetIndex) {
        final p = previousIndex - tableOffsetIndex;
        previousY = tableOffsets[p].dy;
      } else if (previousIndex < emojiOffsetIndex) {
        final p = previousIndex - imageOffsetIndex;
        previousY = imageOffsets[p].dy;
      } else if (previousIndex < shapeOffsetIndex) {
        final p = previousIndex - emojiOffsetIndex;
        previousY = emojiCodeOffsets[p].dy;
      } else if (previousIndex < lineOffsetIndex) {
        final p = previousIndex - shapeOffsetIndex;
        previousY = shapeOffsets[p].dy;
      } else if (previousIndex >= lineOffsetIndex) {
        final p = previousIndex - lineOffsetIndex;
        previousY = lineOffsets[p].dy;
      }

      // Calculate current gap
      final previousBottom = previousY + previousHeight;
      double currentY = 0;
      if (currentIndex < barcodeOffsetIndex) {
        currentY = textCodeOffsets[currentIndex].dy;
      } else if (currentIndex < qrcodeOffsetIndex) {
        final c = currentIndex - barcodeOffsetIndex;
        currentY = barCodeOffsets[c].dy;
      } else if (currentIndex < tableOffsetIndex) {
        final c = currentIndex - qrcodeOffsetIndex;
        currentY = qrCodeOffsets[c].dy;
      } else if (currentIndex < imageOffsetIndex) {
        final c = currentIndex - tableOffsetIndex;
        currentY = tableOffsets[c].dy;
      } else if (currentIndex < emojiOffsetIndex) {
        final c = currentIndex - imageOffsetIndex;
        currentY = imageOffsets[c].dy;
      } else if (currentIndex < shapeOffsetIndex) {
        final c = currentIndex - emojiOffsetIndex;
        currentY = emojiCodeOffsets[c].dy;
      } else if (currentIndex < lineOffsetIndex) {
        final c = currentIndex - shapeOffsetIndex;
        currentY = shapeOffsets[c].dy;
      } else if (currentIndex >= lineOffsetIndex) {
        final c = currentIndex - lineOffsetIndex;
        currentY = lineOffsets[c].dy;
      }

      final currentGap = currentY - previousBottom;

      // Only move if there's space to reduce
      if (currentGap > 0) {
        final moveAmount = min(reduction, currentGap);
        final newY = currentY - moveAmount;

        // Update Y position based on widget type
        if (currentIndex < barcodeOffsetIndex) {
          textCodeOffsets[currentIndex] = Offset(textCodeOffsets[currentIndex].dx, newY);
        } else if (currentIndex < qrcodeOffsetIndex) {
          final c = currentIndex - barcodeOffsetIndex;
          barCodeOffsets[c] = Offset(barCodeOffsets[c].dx, newY);
        } else if (currentIndex < tableOffsetIndex) {
          final c = currentIndex - qrcodeOffsetIndex;
          qrCodeOffsets[c] = Offset(qrCodeOffsets[c].dx, newY);
        } else if (currentIndex < imageOffsetIndex) {
          final c = currentIndex - tableOffsetIndex;
          tableOffsets[c] = Offset(tableOffsets[c].dx, newY);
        } else if (currentIndex < emojiOffsetIndex) {
          final c = currentIndex - imageOffsetIndex;
          imageOffsets[c] = Offset(imageOffsets[c].dx, newY);
        } else if (currentIndex < shapeOffsetIndex) {
          final c = currentIndex - emojiOffsetIndex;
          emojiCodeOffsets[c] = Offset(emojiCodeOffsets[c].dx, newY);
        } else if (currentIndex < lineOffsetIndex) {
          final c = currentIndex - shapeOffsetIndex;
          shapeOffsets[c] = Offset(shapeOffsets[c].dx, newY);
        } else if (currentIndex >= lineOffsetIndex) {
          final c = currentIndex - lineOffsetIndex;
          lineOffsets[c] = Offset(lineOffsets[c].dx, newY);
        }
      }
    }

    notifyListeners();
  }

  void increaseVerticalSpacing(BuildContext context) {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty || selectedWidgetIndices.length < 2) {
      DSnackBar.informationSnackBar(title: DTexts.instance.spaceWaring);
      return;
    }

    // Get all selected widgets and sort by Y position
    final allIndices = List<int>.from(selectedWidgetIndices);

    // Create list with position data for sorting
    List<MapEntry<int, double>> indexWithY = [];
    for (int index in allIndices) {
      // Get Y position based on widget type
      double yPos = 0;
      if (index < barcodeOffsetIndex) {
        yPos = textCodeOffsets[index].dy;
      } else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        yPos = barCodeOffsets[i].dy;
      } else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        yPos = qrCodeOffsets[i].dy;
      } else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        yPos = tableOffsets[i].dy;
      } else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        yPos = imageOffsets[i].dy;
      } else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        yPos = emojiCodeOffsets[i].dy;
      } else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        yPos = shapeOffsets[i].dy;
      } else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        yPos = lineOffsets[i].dy;
      }

      indexWithY.add(MapEntry(index, yPos));
    }

    // Sort by Y position (top to bottom)
    indexWithY.sort((a, b) => a.value.compareTo(b.value));
    final sortedIndices = indexWithY.map((e) => e.key).toList();

    // Move each subsequent widget further down to maintain equal gap increase
    const increase = 2.0;
    for (int i = 1; i < sortedIndices.length; i++) {
      final currentIndex = sortedIndices[i];
      final newYOffset = increase * i;

      // Get current Y and update based on widget type
      if (currentIndex < barcodeOffsetIndex) {
        final newY = textCodeOffsets[currentIndex].dy + newYOffset;
        textCodeOffsets[currentIndex] = Offset(textCodeOffsets[currentIndex].dx, newY);
      } else if (currentIndex < qrcodeOffsetIndex) {
        final c = currentIndex - barcodeOffsetIndex;
        final newY = barCodeOffsets[c].dy + newYOffset;
        barCodeOffsets[c] = Offset(barCodeOffsets[c].dx, newY);
      } else if (currentIndex < tableOffsetIndex) {
        final c = currentIndex - qrcodeOffsetIndex;
        final newY = qrCodeOffsets[c].dy + newYOffset;
        qrCodeOffsets[c] = Offset(qrCodeOffsets[c].dx, newY);
      } else if (currentIndex < imageOffsetIndex) {
        final c = currentIndex - tableOffsetIndex;
        final newY = tableOffsets[c].dy + newYOffset;
        tableOffsets[c] = Offset(tableOffsets[c].dx, newY);
      } else if (currentIndex < emojiOffsetIndex) {
        final c = currentIndex - imageOffsetIndex;
        final newY = imageOffsets[c].dy + newYOffset;
        imageOffsets[c] = Offset(imageOffsets[c].dx, newY);
      } else if (currentIndex < shapeOffsetIndex) {
        final c = currentIndex - emojiOffsetIndex;
        final newY = emojiCodeOffsets[c].dy + newYOffset;
        emojiCodeOffsets[c] = Offset(emojiCodeOffsets[c].dx, newY);
      } else if (currentIndex < lineOffsetIndex) {
        final c = currentIndex - shapeOffsetIndex;
        final newY = shapeOffsets[c].dy + newYOffset;
        shapeOffsets[c] = Offset(shapeOffsets[c].dx, newY);
      } else if (currentIndex >= lineOffsetIndex) {
        final c = currentIndex - lineOffsetIndex;
        final newY = lineOffsets[c].dy + newYOffset;
        lineOffsets[c] = Offset(lineOffsets[c].dx, newY);
      }
    }

    notifyListeners();
  }

  void centerVertically(BuildContext context) {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty || selectedWidgetIndices.length < 2) {
      DSnackBar.informationSnackBar(title: DTexts.instance.spaceWaring);
      return;
    }

    final allIndices = List<int>.from(selectedWidgetIndices);

    // Get bounding box
    final boundingBox = getMultiSelectBoundingBox();
    if (boundingBox == null) return;

    // Sort by Y position (top to bottom)
    List<MapEntry<int, double>> indexWithY = [];

    for (int index in allIndices) {
      double yPos = 0;

      if (index < barcodeOffsetIndex) {
        yPos = textCodeOffsets[index].dy;
      } else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        yPos = barCodeOffsets[i].dy;
      } else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        yPos = qrCodeOffsets[i].dy;
      } else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        yPos = tableOffsets[i].dy;
      } else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        yPos = imageOffsets[i].dy;
      } else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        yPos = emojiCodeOffsets[i].dy;
      } else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        yPos = shapeOffsets[i].dy;
      } else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        yPos = lineOffsets[i].dy;
      }

      indexWithY.add(MapEntry(index, yPos));
    }

    indexWithY.sort((a, b) => a.value.compareTo(b.value));
    final sortedIndices = indexWithY.map((e) => e.key).toList();

    // Calculate total height of all widgets
    double totalHeight = 0;
    for (int index in sortedIndices) {
      if (index < barcodeOffsetIndex) {
        totalHeight += updateTextHeightSize[index];
      } else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        totalHeight += updateBarcodeHeight[i];
      } else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        totalHeight += updateQrcodeSize[i];
      } else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        double tableHeight = 0;
        if (i < tablesRowHeights.length) {
          for (var rowHeight in tablesRowHeights[i]) {
            tableHeight += rowHeight;
          }
        }
        totalHeight += tableHeight;
      } else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        totalHeight += updateImageSize[i];
      } else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        totalHeight += updatedEmojiWidth[i];
      } else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        totalHeight += updateShapeHeight[i];
      } else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        totalHeight += updateSliderLineWidth[i];
      }
    }

    // Calculate available space and equal spacing
    const padding = 20.0;
    final availableSpace = boundingBox.height - padding - totalHeight;
    final spacing = sortedIndices.length > 1 ? availableSpace / (sortedIndices.length - 1) : 0;

    //print('Total height: $totalHeight, Available space: $availableSpace, Spacing: $spacing');

    // Position widgets with equal spacing
    double currentY = boundingBox.top + 10;

    for (int index in sortedIndices) {
      double widgetHeight = 0;

      // Get widget height
      if (index < barcodeOffsetIndex) {
        widgetHeight = updateTextHeightSize[index];
      } else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        widgetHeight = updateBarcodeHeight[i];
      } else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        widgetHeight = updateQrcodeSize[i];
      } else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        if (i < tablesRowHeights.length) {
          for (var rowHeight in tablesRowHeights[i]) {
            widgetHeight += rowHeight;
          }
        }
      } else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        widgetHeight = updateImageSize[i];
      } else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        widgetHeight = updatedEmojiWidth[i];
      } else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        widgetHeight = updateShapeHeight[i];
      } else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        widgetHeight = updateSliderLineWidth[i];
      }

      // Update Y position (X unchanged)
      if (index < barcodeOffsetIndex) {
        textCodeOffsets[index] = Offset(textCodeOffsets[index].dx, currentY);
      } else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        barCodeOffsets[i] = Offset(barCodeOffsets[i].dx, currentY);
      } else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        qrCodeOffsets[i] = Offset(qrCodeOffsets[i].dx, currentY);
      } else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        tableOffsets[i] = Offset(tableOffsets[i].dx, currentY);
      } else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        imageOffsets[i] = Offset(imageOffsets[i].dx, currentY);
      } else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        emojiCodeOffsets[i] = Offset(emojiCodeOffsets[i].dx, currentY);
      } else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        shapeOffsets[i] = Offset(shapeOffsets[i].dx, currentY);
      } else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        lineOffsets[i] = Offset(lineOffsets[i].dx, currentY);
      }

      // Move to next position
      currentY += widgetHeight + spacing;
    }

    //print('✅ Evenly distributed ${sortedIndices.length} widgets vertically');
    notifyListeners();
  }

  /// ================== HORIZONTAL SPACING CONTROL DECREASE, INCREASE, CENTER ==================
  void decreaseHorizontalSpacing(BuildContext context) {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty || selectedWidgetIndices.length < 2) {
      DSnackBar.informationSnackBar(title: DTexts.instance.spaceWaring);
      return;
    }

    // Get all selected widgets and sort by X position
    final allIndices = List<int>.from(selectedWidgetIndices);

    // Create list with position data for sorting
    List<MapEntry<int, double>> indexWithX = [];
    for (int index in allIndices) {
      // Get X position based on widget type
      double xPos = 0;
      if (index < barcodeOffsetIndex) {
        xPos = textCodeOffsets[index].dx;
      } else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        xPos = barCodeOffsets[i].dx;
      } else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        xPos = qrCodeOffsets[i].dx;
      } else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        xPos = tableOffsets[i].dx;
      } else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        xPos = imageOffsets[i].dx;
      } else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        xPos = emojiCodeOffsets[i].dx;
      } else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        xPos = shapeOffsets[i].dx;
      } else if (index >= lineOffsetIndex) {
        final i = index - lineOffsetIndex;
        xPos = lineOffsets[i].dx;
      }

      indexWithX.add(MapEntry(index, xPos));
    }

    // Sort by X position (left to right)
    indexWithX.sort((a, b) => a.value.compareTo(b.value));
    final sortedIndices = indexWithX.map((e) => e.key).toList();

    // Get first widget X position
    double firstWidgetX = 0;
    final firstIndex = sortedIndices[0];
    if (firstIndex < barcodeOffsetIndex) {
      firstWidgetX = textCodeOffsets[firstIndex].dx;
    } else if (firstIndex < qrcodeOffsetIndex) {
      final i = firstIndex - barcodeOffsetIndex;
      firstWidgetX = barCodeOffsets[i].dx;
    } else if (firstIndex < tableOffsetIndex) {
      final i = firstIndex - qrcodeOffsetIndex;
      firstWidgetX = qrCodeOffsets[i].dx;
    } else if (firstIndex < imageOffsetIndex) {
      final i = firstIndex - tableOffsetIndex;
      firstWidgetX = tableOffsets[i].dx;
    } else if (firstIndex < emojiOffsetIndex) {
      final i = firstIndex - imageOffsetIndex;
      firstWidgetX = imageOffsets[i].dx;
    } else if (firstIndex < shapeOffsetIndex) {
      final i = firstIndex - emojiOffsetIndex;
      firstWidgetX = emojiCodeOffsets[i].dx;
    } else if (firstIndex < lineOffsetIndex) {
      final i = firstIndex - shapeOffsetIndex;
      firstWidgetX = shapeOffsets[i].dx;
    } else if (firstIndex >= lineOffsetIndex) {
      final i = firstIndex - lineOffsetIndex;
      firstWidgetX = lineOffsets[i].dx;
    }

    // Keep first widget fixed, move others LEFT
    const reduction = 2.0;
    for (int i = 1; i < sortedIndices.length; i++) {
      final currentIndex = sortedIndices[i];

      // Text widget
      if (currentIndex < barcodeOffsetIndex) {
        final newX = max(textCodeOffsets[currentIndex].dx - reduction, firstWidgetX);
        textCodeOffsets[currentIndex] = Offset(newX, textCodeOffsets[currentIndex].dy);
      }
      // Barcode widget
      else if (currentIndex < qrcodeOffsetIndex) {
        final j = currentIndex - barcodeOffsetIndex;
        final newX = max(barCodeOffsets[j].dx - reduction, firstWidgetX);
        barCodeOffsets[j] = Offset(newX, barCodeOffsets[j].dy);
      }
      // QR Code widget
      else if (currentIndex < tableOffsetIndex) {
        final j = currentIndex - qrcodeOffsetIndex;
        final newX = max(qrCodeOffsets[j].dx - reduction, firstWidgetX);
        qrCodeOffsets[j] = Offset(newX, qrCodeOffsets[j].dy);
      }
      // Table widget
      else if (currentIndex < imageOffsetIndex) {
        final j = currentIndex - tableOffsetIndex;
        final newX = max(tableOffsets[j].dx - reduction, firstWidgetX);
        tableOffsets[j] = Offset(newX, tableOffsets[j].dy);
      }
      // Image widget
      else if (currentIndex < emojiOffsetIndex) {
        final j = currentIndex - imageOffsetIndex;
        final newX = max(imageOffsets[j].dx - reduction, firstWidgetX);
        imageOffsets[j] = Offset(newX, imageOffsets[j].dy);
      }
      // Emoji widget
      else if (currentIndex < shapeOffsetIndex) {
        final j = currentIndex - emojiOffsetIndex;
        final newX = max(emojiCodeOffsets[j].dx - reduction, firstWidgetX);
        emojiCodeOffsets[j] = Offset(newX, emojiCodeOffsets[j].dy);
      }
      // Shape widget
      else if (currentIndex < lineOffsetIndex) {
        final j = currentIndex - shapeOffsetIndex;
        final newX = max(shapeOffsets[j].dx - reduction, firstWidgetX);
        shapeOffsets[j] = Offset(newX, shapeOffsets[j].dy);
      }
      // Line widget
      else if (currentIndex >= lineOffsetIndex) {
        final j = currentIndex - lineOffsetIndex;
        final newX = max(lineOffsets[j].dx - reduction, firstWidgetX);
        lineOffsets[j] = Offset(newX, lineOffsets[j].dy);
      }
    }

    notifyListeners();
  }

  void increaseHorizontalSpacing(BuildContext context) {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty || selectedWidgetIndices.length < 2) {
      DSnackBar.informationSnackBar(title: DTexts.instance.spaceWaring);
      return;
    }

    const moveStep = 2.0;
    double maxRight = double.negativeInfinity;

    // 1️⃣ Calculate rightmost (maxRight) across all widget types
    for (final index in selectedWidgetIndices) {
      double widgetRight = 0;

      if (index < textCodeOffsets.length) {
        widgetRight = textCodeOffsets[index].dx + updateTextWidthSize[index];
      } else if (index - barcodeOffsetIndex < barCodeOffsets.length) {
        final i = index - barcodeOffsetIndex;
        widgetRight = barCodeOffsets[i].dx + updateBarcodeWidth[i];
      } else if (index - qrcodeOffsetIndex < qrCodeOffsets.length) {
        final i = index - qrcodeOffsetIndex;
        widgetRight = qrCodeOffsets[i].dx + updateQrcodeSize[i];
      } else if (index - tableOffsetIndex < tableOffsets.length) {
        final i = index - tableOffsetIndex;
        double totalWidth = tablesColumnWidths[i].fold(0.0, (sum, w) => sum + w);
        widgetRight = tableOffsets[i].dx + totalWidth;
      } else if (index - imageOffsetIndex < imageOffsets.length) {
        final i = index - imageOffsetIndex;
        widgetRight = imageOffsets[i].dx + updateImageSize[i];
      } else if (index - emojiOffsetIndex < emojiCodeOffsets.length) {
        final i = index - emojiOffsetIndex;
        widgetRight = emojiCodeOffsets[i].dx + updatedEmojiWidth[i];
      } else if (index - shapeOffsetIndex < shapeOffsets.length) {
        final i = index - shapeOffsetIndex;
        widgetRight = shapeOffsets[i].dx + updateShapeWidth[i];
      } else if (index - lineOffsetIndex < lineOffsets.length) {
        final i = index - lineOffsetIndex;
        widgetRight = lineOffsets[i].dx + updateLineWidth[i];
      }

      maxRight = max(maxRight, widgetRight);
    }

    // 2️⃣ Gradually move every widget (2px per call)
    for (final index in selectedWidgetIndices) {
      double currentRight = 0;
      double moveBy = 0;

      if (index < textCodeOffsets.length) {
        currentRight = textCodeOffsets[index].dx + updateTextWidthSize[index];
        if (currentRight < maxRight) {
          moveBy = min(moveStep, maxRight - currentRight);
          textCodeOffsets[index] = Offset(textCodeOffsets[index].dx + moveBy, textCodeOffsets[index].dy);
        }
      } else if (index - barcodeOffsetIndex < barCodeOffsets.length) {
        final i = index - barcodeOffsetIndex;
        currentRight = barCodeOffsets[i].dx + updateBarcodeWidth[i];
        if (currentRight < maxRight) {
          moveBy = min(moveStep, maxRight - currentRight);
          barCodeOffsets[i] = Offset(barCodeOffsets[i].dx + moveBy, barCodeOffsets[i].dy);
        }
      } else if (index - qrcodeOffsetIndex < qrCodeOffsets.length) {
        final i = index - qrcodeOffsetIndex;
        currentRight = qrCodeOffsets[i].dx + updateQrcodeSize[i];
        if (currentRight < maxRight) {
          moveBy = min(moveStep, maxRight - currentRight);
          qrCodeOffsets[i] = Offset(qrCodeOffsets[i].dx + moveBy, qrCodeOffsets[i].dy);
        }
      } else if (index - tableOffsetIndex < tableOffsets.length) {
        final i = index - tableOffsetIndex;
        double totalWidth = tablesColumnWidths[i].fold(0.0, (sum, w) => sum + w);
        currentRight = tableOffsets[i].dx + totalWidth;
        if (currentRight < maxRight) {
          moveBy = min(moveStep, maxRight - currentRight);
          tableOffsets[i] = Offset(tableOffsets[i].dx + moveBy, tableOffsets[i].dy);
        }
      } else if (index - imageOffsetIndex < imageOffsets.length) {
        final i = index - imageOffsetIndex;
        currentRight = imageOffsets[i].dx + updateImageSize[i];
        if (currentRight < maxRight) {
          moveBy = min(moveStep, maxRight - currentRight);
          imageOffsets[i] = Offset(imageOffsets[i].dx + moveBy, imageOffsets[i].dy);
        }
      } else if (index - emojiOffsetIndex < emojiCodeOffsets.length) {
        final i = index - emojiOffsetIndex;
        currentRight = emojiCodeOffsets[i].dx + updatedEmojiWidth[i];
        if (currentRight < maxRight) {
          moveBy = min(moveStep, maxRight - currentRight);
          emojiCodeOffsets[i] = Offset(emojiCodeOffsets[i].dx + moveBy, emojiCodeOffsets[i].dy);
        }
      } else if (index - shapeOffsetIndex < shapeOffsets.length) {
        final i = index - shapeOffsetIndex;
        currentRight = shapeOffsets[i].dx + updateShapeWidth[i];
        if (currentRight < maxRight) {
          moveBy = min(moveStep, maxRight - currentRight);
          shapeOffsets[i] = Offset(shapeOffsets[i].dx + moveBy, shapeOffsets[i].dy);
        }
      } else if (index - lineOffsetIndex < lineOffsets.length) {
        final i = index - lineOffsetIndex;
        currentRight = lineOffsets[i].dx + updateLineWidth[i];
        if (currentRight < maxRight) {
          moveBy = min(moveStep, maxRight - currentRight);
          lineOffsets[i] = Offset(lineOffsets[i].dx + moveBy, lineOffsets[i].dy);
        }
      }
    }

    notifyListeners();
  }

  void centerHorizontally(BuildContext context) {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty || selectedWidgetIndices.length < 3) {
      DSnackBar.informationSnackBar(title: DTexts.instance.spaceWaring);
      return;
    }

    final boundingBox = getMultiSelectBoundingBox();
    if (boundingBox == null) return;

    final centerX = boundingBox.center.dx;

    for (int index in selectedWidgetIndices) {
      final info = getWidgetTypeByGlobalIndex(index); // helper function we discussed
      switch (info.type) {
        case 'text':
          final w = updateTextWidthSize[info.localIndex];
          textCodeOffsets[info.localIndex] = Offset(centerX - w / 2, textCodeOffsets[info.localIndex].dy);
          break;
        case 'barcode':
          final w = updateBarcodeWidth[info.localIndex];
          barCodeOffsets[info.localIndex] = Offset(centerX - w / 2, barCodeOffsets[info.localIndex].dy);
          break;
        case 'qrcode':
          final w = updateQrcodeSize[info.localIndex];
          qrCodeOffsets[info.localIndex] = Offset(centerX - w / 2, qrCodeOffsets[info.localIndex].dy);
          break;
        case 'image':
          final w = updateImageSize[info.localIndex];
          imageOffsets[info.localIndex] = Offset(centerX - w / 2, imageOffsets[info.localIndex].dy);
          break;
        case 'table':
          double totalW = tablesColumnWidths[info.localIndex].fold(0.0, (a, b) => a + b);
          tableOffsets[info.localIndex] = Offset(centerX - totalW / 2, tableOffsets[info.localIndex].dy);
          break;
        case 'emoji':
          final w = updatedEmojiWidth[info.localIndex];
          emojiCodeOffsets[info.localIndex] = Offset(centerX - w / 2, emojiCodeOffsets[info.localIndex].dy);
          break;
        case 'shape':
          final w = updateShapeWidth[info.localIndex];
          shapeOffsets[info.localIndex] = Offset(centerX - w / 2, shapeOffsets[info.localIndex].dy);
          break;
        case 'line':
          final w = updateLineWidth[info.localIndex];
          lineOffsets[info.localIndex] = Offset(centerX - w / 2, lineOffsets[info.localIndex].dy);
          break;
      }
    }

    notifyListeners();
  }

  /// Lock/Unlock all selected widgets in multiselect mode
  void multiSelectWidgetLockToggle() {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty) return;

    for (final index in selectedWidgetIndices) {
      // TEXT
      if (index < isTextLock.length) {
        isTextLock[index] = !isTextLock[index];
      }
      // BARCODE
      else if (index - barcodeOffsetIndex < isBarcodeLock.length) {
        isBarcodeLock[index - barcodeOffsetIndex] = !isBarcodeLock[index - barcodeOffsetIndex];
      }
      // QR CODE
      else if (index - qrcodeOffsetIndex < isQrcodeLock.length) {
        isQrcodeLock[index - qrcodeOffsetIndex] = !isQrcodeLock[index - qrcodeOffsetIndex];
      }
      // TABLE
      else if (index - tableOffsetIndex < isTableLock.length) {
        isTableLock[index - tableOffsetIndex] = !isTableLock[index - tableOffsetIndex];
      }
      // IMAGE
      else if (index - imageOffsetIndex < isImageLock.length) {
        isImageLock[index - imageOffsetIndex] = !isImageLock[index - imageOffsetIndex];
      }
      // EMOJI
      else if (index - emojiOffsetIndex < isEmojiLock.length) {
        isEmojiLock[index - emojiOffsetIndex] = !isEmojiLock[index - emojiOffsetIndex];
      }
      // SHAPE
      else if (index - shapeOffsetIndex < isShapeLock.length) {
        isShapeLock[index - shapeOffsetIndex] = !isShapeLock[index - shapeOffsetIndex];
      }
      // LINE
      else if (index - lineOffsetIndex < isLineLock.length) {
        isLineLock[index - lineOffsetIndex] = !isLineLock[index - lineOffsetIndex];
      }
    }

    isMultiSelectEnabled = false;
    selectedWidgetIndices.clear();
    //showMultiSelectContainerFlag = true;
    notifyListeners();
  }

  /// Delete all selected widgets in multiselect mode
  void multiSelectWidgetDelete() {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty) return;

    // Sort in descending order (avoid index shift)
    final sortedIndices = List<int>.from(selectedWidgetIndices)..sort((a, b) => b.compareTo(a));

    for (final index in sortedIndices) {
      // TEXT
      if (index < textCodeOffsets.length) {
        if (index < textCodes.length) textCodes.removeAt(index);
        if (index < textCodeOffsets.length) textCodeOffsets.removeAt(index);
        if (index < textControllers.length) textControllers.removeAt(index);
        if (index < checkTextIdentifyWidget.length) checkTextIdentifyWidget.removeAt(index);
        if (index < updateTextBold.length) updateTextBold.removeAt(index);
        if (index < updateTextItalic.length) updateTextItalic.removeAt(index);
        if (index < updateTextUnderline.length) updateTextUnderline.removeAt(index);
        if (index < updateTextFontSize.length) updateTextFontSize.removeAt(index);
        if (index < updateTextAlignment.length) updateTextAlignment.removeAt(index);
        if (index < textContainerRotations.length) textContainerRotations.removeAt(index);
        if (index < updateTextWidthSize.length) updateTextWidthSize.removeAt(index);
        if (index < updateTextHeightSize.length) updateTextHeightSize.removeAt(index);
        if (index < textSelectedFontFamily.length) textSelectedFontFamily.removeAt(index);
        if (index < isTextLock.length) isTextLock.removeAt(index);
        if (index < prefixNumber.length) prefixNumber.removeAt(index);
        if (index < suffixNumber.length) suffixNumber.removeAt(index);
        if (index < incrementNumber.length) incrementNumber.removeAt(index);
        if (index < endPageNumber.length) endPageNumber.removeAt(index);
      }
      // BARCODE
      else if (index - barcodeOffsetIndex < barCodeOffsets.length) {
        final i = index - barcodeOffsetIndex;
        if (i < barCodes.length) barCodes.removeAt(i);
        if (i < barCodeOffsets.length) barCodeOffsets.removeAt(i);
        if (i < barcodeControllers.length) barcodeControllers.removeAt(i);
        if (i < barEncodingType.length) barEncodingType.removeAt(i);
        if (i < updateBarcodeWidth.length) updateBarcodeWidth.removeAt(i);
        if (i < updateBarcodeHeight.length) updateBarcodeHeight.removeAt(i);
        if (i < barCodesContainerRotations.length) barCodesContainerRotations.removeAt(i);
        if (i < barTextFontSize.length) barTextFontSize.removeAt(i);
        if (i < barTextBold.length) barTextBold.removeAt(i);
        if (i < barTextItalic.length) barTextItalic.removeAt(i);
        if (i < barTextUnderline.length) barTextUnderline.removeAt(i);
        if (i < isBarcodeLock.length) isBarcodeLock.removeAt(i);
        if (i < prefixNumber.length) prefixNumber.removeAt(i);
        if (i < suffixNumber.length) suffixNumber.removeAt(i);
      }
      // QR CODE
      else if (index - qrcodeOffsetIndex < qrCodeOffsets.length) {
        final i = index - qrcodeOffsetIndex;
        if (i < qrCodes.length) qrCodes.removeAt(i);
        if (i < qrCodeOffsets.length) qrCodeOffsets.removeAt(i);
        if (i < qrcodeControllers.length) qrcodeControllers.removeAt(i);
        if (i < updateQrcodeSize.length) updateQrcodeSize.removeAt(i);
        if (i < isQrcodeLock.length) isQrcodeLock.removeAt(i);
      }
      // TABLE
      else if (index - tableOffsetIndex < tableOffsets.length) {
        final i = index - tableOffsetIndex;
        if (i < tableCodes.length) tableCodes.removeAt(i);
        if (i < tableOffsets.length) tableOffsets.removeAt(i);
        if (i < tableLineWidth.length) tableLineWidth.removeAt(i);
        if (i < tablesCells.length) tablesCells.removeAtOrNull(i);
        if (i < tablesSelectedCells.length) tablesSelectedCells.removeAtOrNull(i);
        if (i < tablesColumnWidths.length) tablesColumnWidths.removeAtOrNull(i);
        if (i < tablesRowHeights.length) tablesRowHeights.removeAtOrNull(i);
        if (i < textController.length) textController.removeAtOrNull(i);
        if (i < rowCount.length) rowCount.removeAtOrNull(i);
        if (i < columnCount.length) columnCount.removeAtOrNull(i);
        if (i < tableBorderStyle.length) tableBorderStyle.removeAtOrNull(i);
        if (i < tableContainerRotations.length) tableContainerRotations.removeAtOrNull(i);
        if (i < isTableLock.length) isTableLock.removeAtOrNull(i);
      }
      // IMAGE
      else if (index - imageOffsetIndex < imageOffsets.length) {
        final i = index - imageOffsetIndex;
        if (i < imageCodes.length) imageCodes.removeAt(i);
        if (i < imageOffsets.length) imageOffsets.removeAt(i);
        if (i < updateImageSize.length) updateImageSize.removeAt(i);
        if (i < imageCodesContainerRotations.length) imageCodesContainerRotations.removeAt(i);
        if (i < isImageLock.length) isImageLock.removeAt(i);
      }
      // EMOJI
      else if (index - emojiOffsetIndex < emojiCodeOffsets.length) {
        final i = index - emojiOffsetIndex;
        if (i < emojiCodes.length) emojiCodes.removeAt(i);
        if (i < emojiCodeOffsets.length) emojiCodeOffsets.removeAt(i);
        if (i < updatedEmojiWidth.length) updatedEmojiWidth.removeAt(i);
        if (i < emojiCodesContainerRotations.length) emojiCodesContainerRotations.removeAt(i);
        if (i < isEmojiLock.length) isEmojiLock.removeAt(i);
      }
      // SHAPE
      else if (index - shapeOffsetIndex < shapeOffsets.length) {
        final i = index - shapeOffsetIndex;
        if (i < shapeCodes.length) shapeCodes.removeAt(i);
        if (i < shapeOffsets.length) shapeOffsets.removeAt(i);
        if (i < updateShapeWidth.length) updateShapeWidth.removeAt(i);
        if (i < updateShapeHeight.length) updateShapeHeight.removeAt(i);
        if (i < shapeCodesContainerRotations.length) shapeCodesContainerRotations.removeAt(i);
        if (i < isShapeLock.length) isShapeLock.removeAt(i);
      }
      // LINE
      else if (index - lineOffsetIndex < lineOffsets.length) {
        final i = index - lineOffsetIndex;
        if (i < lineCodes.length) lineCodes.removeAt(i);
        if (i < lineOffsets.length) lineOffsets.removeAt(i);
        if (i < lineCodesContainerRotations.length) lineCodesContainerRotations.removeAt(i);
        if (i < updateLineWidth.length) updateLineWidth.removeAt(i);
        if (i < updateSliderLineWidth.length) updateSliderLineWidth.removeAt(i);
        if (i < isDottedLineUpdate.length) isDottedLineUpdate.removeAt(i);
        if (i < isLineLock.length) isLineLock.removeAt(i);
      }
    }

    selectedWidgetIndices.clear();
    isMultiSelectEnabled = false;
    //showMultiSelectContainerFlag = false;

    // Save current states for all widget types to enable undo/redo
    final context = GlobalContext.context;
    if (context != null) {
      context.textEditingProvider.saveCurrentTextWidgetState();
      context.barcodeProvider.saveCurrentBarcodeState();
      context.qrCodeProvider.saveCurrentQrcodeState();
      context.tableProvider.saveCurrentTableState();
      context.imageTakeProvider.saveCurrentImageState();
      context.emojiProvider.saveCurrentEmojiState();
      context.shapeProvider.saveCurrentShapeState();
      context.lineProvider.saveCurrentLineWidgetState();
    }

    notifyListeners();
  }

  /// Multi-select Copy Function
  Future<void> multiSelectWidgetCopy() async {
    if (!isMultiSelectEnabled || selectedWidgetIndices.isEmpty) return;

    final sortedIndices = List<int>.from(selectedWidgetIndices)..sort();
    final Map<String, dynamic> allCopiedData = {};

    for (int index in sortedIndices) {
      // TEXT
      if (index < barcodeOffsetIndex) {
        (allCopiedData['textData'] ??= <Map<String, dynamic>>[]).add({
          'text': textCodes[index],
          'offset': textCodeOffsets[index],
          'width': updateTextWidthSize[index],
          'height': updateTextHeightSize[index],
          'bold': updateTextBold[index],
          'italic': updateTextItalic[index],
          'underline': updateTextUnderline[index],
          'updateTextStrikeThrough': updateTextStrikeThrough[index],
          'alignment': updateTextAlignment[index],
          'alignLeft': alignLeft[index],
          'alignCenter': alignCenter[index],
          'alignRight': alignRight[index],
          'alignStraight': alignStraight[index],
          'fontSize': updateTextFontSize[index],
          'rotation': textContainerRotations[index],
          'fontFamily': textSelectedFontFamily[index],

          /*'prefix': prefixNumber[index],
          'suffix': suffixNumber[index],
          'increment': incrementNumber[index],
          'endPage': endPageNumber[index],
          'widgetType': checkTextIdentifyWidget[index],*/
        });
      }
      // BARCODE
      else if (index < qrcodeOffsetIndex) {
        final i = index - barcodeOffsetIndex;
        (allCopiedData['barcodeData'] ??= <Map<String, dynamic>>[]).add({
          'code': barCodes[i],
          'offset': barCodeOffsets[i],
          'width': updateBarcodeWidth[i],
          'height': updateBarcodeHeight[i],

          'encodingType': barEncodingType[i],
          'bold': barTextBold[i],
          'italic': barTextItalic[i],
          'underline': barTextUnderline[i],
          'barTextStrikeThrough': barTextStrikeThrough[i],
          'fontSize': barTextFontSize[i],
          'rotation': barCodesContainerRotations[i],
          'drawText': drawText[i],

          'prefixController': prefixController[i],
          'inputController': inputController[i],
          'suffixController': suffixController[i],
          'incrementController': incrementController[i],
          'endPage': endPageController[i],
        });
      }
      // QR CODE
      else if (index < tableOffsetIndex) {
        final i = index - qrcodeOffsetIndex;
        (allCopiedData['qrcodeData'] ??= <Map<String, dynamic>>[]).add({
          'code': qrCodes[i],
          'offset': qrCodeOffsets[i],
          'size': updateQrcodeSize[i],
        });
      }
      // TABLE
      else if (index < imageOffsetIndex) {
        final i = index - tableOffsetIndex;
        (allCopiedData['tableData'] ??= <Map<String, dynamic>>[]).add({
          'code': tableCodes[i],
          'offset': tableOffsets[i],
          'cells': tablesCells[i],
          'selectedCells': tablesSelectedCells[i],
          'textController': textController[i],
          'lineWidth': tableLineWidth[i],
          'columnWidths': tablesColumnWidths[i],
          'rowHeights': tablesRowHeights[i],
          'rowCount': rowCount[i],
          'columnCount': columnCount[i],
          'borderStyle': tableBorderStyle[i],
          'rotation': tableContainerRotations[i],
        });
      }
      // IMAGE
      else if (index < emojiOffsetIndex) {
        final i = index - imageOffsetIndex;
        (allCopiedData['imageData'] ??= <Map<String, dynamic>>[]).add({
          'code': imageCodes[i],
          'offset': imageOffsets[i],
          'size': updateImageSize[i],
          'rotation': imageCodesContainerRotations[i],
        });
      }
      // EMOJI
      else if (index < shapeOffsetIndex) {
        final i = index - emojiOffsetIndex;
        (allCopiedData['emojiData'] ??= <Map<String, dynamic>>[]).add({
          'code': emojiCodes[i],
          'emoji': selectedEmojis[i],
          'offset': emojiCodeOffsets[i],
          'width': updatedEmojiWidth[i],
          'rotation': emojiCodesContainerRotations[i],
        });
      }
      // SHAPE
      else if (index < lineOffsetIndex) {
        final i = index - shapeOffsetIndex;
        (allCopiedData['shapeData'] ??= <Map<String, dynamic>>[]).add({
          'code': shapeCodes[i],
          'offset': shapeOffsets[i],
          'width': updateShapeWidth[i],
          'height': updateShapeHeight[i],
          'isSquare': isSquareUpdate[i],
          'isRoundSquare': isRoundSquareUpdate[i],
          'isCircular': isCircularUpdate[i],
          'isOvalCircular': isOvalCircularUpdate[i],
          'shapeType': shapeTypes[i],
          'lineWidth': updateShapeLineWidthSize[i],
          'rotation': shapeCodesContainerRotations[i],
          'isFixedSize': isFixedFigureSize[i],
          'trueWidth': trueShapeWidth[i],
          'trueHeight': trueShapeHeight[i],
        });
      }
      // LINE
      else {
        final i = index - lineOffsetIndex;
        (allCopiedData['lineData'] ??= <Map<String, dynamic>>[]).add({
          'code': lineCodes[i],
          'offset': lineOffsets[i],
          'width': updateLineWidth[i],
          'lineWidth': updateSliderLineWidth[i],
          'isDotted': isDottedLineUpdate[i],
          'rotation': lineCodesContainerRotations[i],
        });
      }
    }

    multiSelectClipboard = allCopiedData;
  }

  /// Multi-select Paste Function
  Future<void> multiSelectWidgetPaste() async {
    if (multiSelectClipboard == null || multiSelectClipboard!.isEmpty) return;

    selectedWidgetIndices.clear();
    const offsetShift = Offset(20, 20);
    final data = multiSelectClipboard!;

    // TEXT
    for (var textData in data['textData'] ?? []) {
      textCodes.add(textData['text']);
      textCodeOffsets.add(textData['offset'] + offsetShift);
      textFocusNodes.add(FocusNode());
      textControllers.add(TextEditingController());
      updateTextWidthSize.add(textData['width']);
      updateTextHeightSize.add(textData['height']);
      updateTextBold.add(textData['bold']);
      updateTextItalic.add(textData['italic']);
      updateTextUnderline.add(textData['underline']);
      updateTextStrikeThrough.add(textData['updateTextStrikeThrough']);
      updateTextAlignment.add(textData['alignment']);
      alignLeft.add(textData['alignLeft']);
      alignCenter.add(textData['alignCenter']);
      alignRight.add(textData['alignRight']);
      alignStraight.add(textData['alignStraight']);
      updateTextFontSize.add(textData['fontSize']);
      textSelectedFontFamily.add(textData['fontFamily']);
      textContainerRotations.add(textData['rotation']);
      isTextLock.add(false);

      /*checkTextIdentifyWidget.add(textData['widgetType']);
      prefixNumber.add(textData['prefix'] ?? '');
      suffixNumber.add(textData['suffix'] ?? '');
      incrementNumber.add(textData['increment'] ?? 1);
      endPageNumber.add(textData['endPage'] ?? 5);
      prefixController.add(TextEditingController());
      suffixController.add(TextEditingController());
      incrementController.add(TextEditingController());
      endPageController.add(TextEditingController());*/

      selectedWidgetIndices.add(textOffsetIndex + textCodes.length - 1);
    }

    // BARCODE
    for (var barcodeData in data['barcodeData'] ?? []) {
      barCodes.add(barcodeData['code']);
      barCodeOffsets.add(barcodeData['offset'] + offsetShift);
      brFocusNodes.add(FocusNode());
      barcodeControllers.add(TextEditingController());
      updateBarcodeWidth.add(barcodeData['width']);
      updateBarcodeHeight.add(barcodeData['height']);

      barEncodingType.add(barcodeData['encodingType']);
      barTextBold.add(barcodeData['bold']);
      barTextItalic.add(barcodeData['italic']);
      barTextUnderline.add(barcodeData['underline']);
      barTextStrikeThrough.add(barcodeData['barTextStrikeThrough']);
      barTextFontSize.add(barcodeData['fontSize']);
      barCodesContainerRotations.add(barcodeData['rotation']);
      isBarcodeLock.add(false);
      drawText.add(barcodeData['drawText'] ?? true);

      prefixController.add(barcodeData['prefixController'] ?? TextEditingController);
      inputController.add(barcodeData['inputController'] ?? TextEditingController);
      suffixController.add(barcodeData['suffixController'] ?? TextEditingController);
      incrementController.add(barcodeData['incrementController'] ?? TextEditingController);
      endPageController.add(barcodeData['endPage'] ?? TextEditingController);

      //drawText.add(barcodeData['drawText']);
      //selectBarcodeTypeIndex.add(barcodeData['typeIndex']);

      selectedWidgetIndices.add(barcodeOffsetIndex + barCodes.length - 1);
    }

    // QRCODE
    for (var qrcodeData in data['qrcodeData'] ?? []) {
      qrCodes.add(qrcodeData['code']);
      qrCodeOffsets.add(qrcodeData['offset'] + offsetShift);
      qrcodeControllers.add(TextEditingController());
      updateQrcodeSize.add(qrcodeData['size']);
      isQrcodeLock.add(false);

      selectedWidgetIndices.add(qrcodeOffsetIndex + qrCodes.length - 1);
    }

    // TABLE
    for (var tableData in data['tableData'] ?? []) {
      tableCodes.add(tableData['code']);
      tableOffsets.add(tableData['offset'] + offsetShift);
      tablesCells.add(tableData['cells']);
      tablesSelectedCells.add(tableData['selectedCells']);
      textController.add(tableData['textController']);
      tableLineWidth.add(tableData['lineWidth']);
      tablesColumnWidths.add(tableData['columnWidths']);
      tablesRowHeights.add(tableData['rowHeights']);
      rowCount.add(tableData['rowCount']);
      columnCount.add(tableData['columnCount']);
      tableBorderStyle.add(tableData['borderStyle']);
      tableContainerRotations.add(tableData['rotation']);
      isTableLock.add(false);

      selectedWidgetIndices.add(tableOffsetIndex + tableCodes.length - 1);
    }

    // IMAGE
    for (var imageData in data['imageData'] ?? []) {
      imageCodes.add(imageData['code']);
      imageOffsets.add(imageData['offset'] + offsetShift);
      updateImageSize.add(imageData['size']);
      imageCodesContainerRotations.add(imageData['rotation']);
      isImageLock.add(false);

      selectedWidgetIndices.add(imageOffsetIndex + imageCodes.length - 1);
    }

    // EMOJI
    for (var emojiData in data['emojiData'] ?? []) {
      emojiCodes.add(emojiData['code']);
      selectedEmojis.add(emojiData['emoji']);
      emojiCodeOffsets.add(emojiData['offset'] + offsetShift);
      updatedEmojiWidth.add(emojiData['width']);
      emojiCodesContainerRotations.add(emojiData['rotation']);
      isEmojiLock.add(false);

      selectedWidgetIndices.add(emojiOffsetIndex + emojiCodes.length - 1);
    }

    // SHAPE
    for (var shapeData in data['shapeData'] ?? []) {
      shapeCodes.add(shapeData['code']);
      shapeOffsets.add(shapeData['offset'] + offsetShift);
      updateShapeWidth.add(shapeData['width']);
      updateShapeHeight.add(shapeData['height']);
      isSquareUpdate.add(shapeData['isSquare']);
      isRoundSquareUpdate.add(shapeData['isRoundSquare']);
      isCircularUpdate.add(shapeData['isCircular']);
      isOvalCircularUpdate.add(shapeData['isOvalCircular']);
      shapeTypes.add(shapeData['shapeType']);
      updateShapeLineWidthSize.add(shapeData['lineWidth']);
      shapeCodesContainerRotations.add(shapeData['rotation']);
      isFixedFigureSize.add(shapeData['isFixedSize']);
      trueShapeWidth.add(shapeData['trueWidth']);
      trueShapeHeight.add(shapeData['trueHeight']);
      isShapeLock.add(false);

      selectedWidgetIndices.add(shapeOffsetIndex + shapeCodes.length - 1);
    }

    // LINE
    for (var lineData in data['lineData'] ?? []) {
      lineCodes.add(lineData['code']);
      lineOffsets.add(lineData['offset'] + offsetShift);
      updateLineWidth.add(lineData['width']);
      updateSliderLineWidth.add(lineData['lineWidth']);
      isDottedLineUpdate.add(lineData['isDotted']);
      lineCodesContainerRotations.add(lineData['rotation']);
      isLineLock.add(false);

      selectedWidgetIndices.add(lineOffsetIndex + lineCodes.length - 1);
    }

    isMultiSelectEnabled = true;
    //showMultiSelectContainerFlag = true;

    // Save current states for all widget types to enable undo/redo
    final context = GlobalContext.context;
    if (context != null) {
      context.textEditingProvider.saveCurrentTextWidgetState();
      context.barcodeProvider.saveCurrentBarcodeState();
      context.qrCodeProvider.saveCurrentQrcodeState();
      context.tableProvider.saveCurrentTableState();
      context.imageTakeProvider.saveCurrentImageState();
      context.emojiProvider.saveCurrentEmojiState();
      context.shapeProvider.saveCurrentShapeState();
      context.lineProvider.saveCurrentLineWidgetState();
    }

    notifyListeners();
  }
}

class WidgetIndexInfo {
  final String type;
  final int localIndex;
  WidgetIndexInfo({required this.type, required this.localIndex});
}
