import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widget/barcode_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../../localization/main_texts.dart';
import '../../../../../utils/snackbar_toast/snack_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grozziie/utils/constants/sizes.dart';
import '../../../print_preview_dialog/print_setup_dialog.dart';
import '../../../../../common/print_select_header/common_label_paper_size.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import 'package:grozziie/utils/constants/label_global_variable.dart';
import 'package:grozziie/features/new_label/printer_type/dot/provider/dot_paper_size_provider.dart';

double selectWidthD = 0;
double selectHeightD = 0;

class LabelPrinterProvider extends ChangeNotifier {
  GlobalKey globalKey = GlobalKey();

  /// Variable
  int paperWidth = 0;
  int paperHeight = 0;
  double selectWidth = 0;
  double selectHeight = 0;
  double showPercentageUi = 1.0;
  List<Uint8List> bitmapList = [];
  int currentImageIndex = 0;
  int totalImages = 0;

  /// Zoom In Out Calculation Function
  void calculateLabelDimensions(double paperWidth, double paperHeight) {
    double maxScreenWidth = 900 * showPercentageUi;
    double maxScreenHeight = 700 * showPercentageUi;

    // screen ratio
    double ratio = paperWidth / paperHeight;

    // Calculate dimensions based on available space and aspect ratio
    double calculatedHeight = maxScreenHeight;
    double calculatedWidth = calculatedHeight * ratio;

    // Adjust if width exceeds available width
    if (calculatedWidth > maxScreenWidth) {
      calculatedWidth = maxScreenWidth;
      calculatedHeight = calculatedWidth / ratio;
    }

    //if (calculatedWidth > maxScreenWidth) calculatedWidth = maxScreenWidth;

    // set paper height
    selectWidth = calculatedWidth;
    selectHeight = calculatedHeight;
    selectWidthD = calculatedWidth;
    selectHeightD = calculatedHeight;
    notifyListeners();
  }

  /// Zoom In Function
  void increment(double paperWidth, double paperHeight) {
    if (showPercentageUi < 2) {
      showPercentageUi = min(showPercentageUi + 0.1, 2);
      calculateLabelDimensions(paperWidth, paperHeight);
    }
    notifyListeners();
  }

  /// Zoom Out Function
  void decrement(double paperWidth, double paperHeight) {
    if (showPercentageUi > 1.0) {
      showPercentageUi = max(showPercentageUi - 0.1, 1.0);
      calculateLabelDimensions(paperWidth, paperHeight);
    }
    notifyListeners();
  }

  /// next function
  void nextImage() {
    if (currentImageIndex < totalImages - 1) {
      currentImageIndex++;
    } else {
      currentImageIndex = 0;
    }
    notifyListeners();
  }

  /// previous function
  void previousImage() {
    if (currentImageIndex > 0) {
      currentImageIndex--;
    } else {
      currentImageIndex = totalImages - 1;
    }
    notifyListeners();
  }

  /// clear Serial number variable
  void clearSerialNumberVariable() {
    bitmapList.clear();
    currentImageIndex = 0;
    totalImages = 0;
  }

  /// convert widget to created image
  Future<ui.Image?> convertWidgetToImage(int paperWidth) async {
    try {
      double imageZoomIn = paperWidth * 8 / selectWidth;
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: imageZoomIn);
      return image;
    } catch (e) {
      debugPrint('Error capturing container convert to bitmap: $e');
      return null;
    }
  }

  /// convert image to uni8list
  Future<Uint8List?> convertImageToData(ui.Image image) async {
    try {
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error converting image to data: $e');
      return null;
    }
  }

  /// show Printer dialog
  Future<void> printSettingDialog(BuildContext context, int paperWidth, int paperHeight) async {
    final currentContext = context;
    clearSerialNumberVariable();

    bool wasBackgroundVisible = showBackgroundImageWidget;
    if (wasBackgroundVisible) {
      showBackgroundImageWidget = false;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 150));
    }

    try {
      if (!currentContext.mounted) return;
      if (context.read<BarcodeProvider>().isCheckedSerialNumber && barCodes.isNotEmpty) {
        String prefix = prefixController[selectedBarCodeIndex].text;
        String suffix = suffixController[selectedBarCodeIndex].text;
        int inputValue = int.parse(inputController[selectedBarCodeIndex].text);
        int incrementValue = int.parse(incrementController[selectedBarCodeIndex].text);
        int endPageValue = int.parse(endPageController[selectedTextIndex].text);
        int result = inputValue;

        for (int page = 1; page <= endPageValue; page++) {
          result += incrementValue;
          barCodes[selectedBarCodeIndex] = prefix + result.toString() + suffix;
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 50));

          // Generate the image after the UI update.
          final image = await convertWidgetToImage(paperWidth);
          if (image != null) {
            final imageData = await convertImageToData(image);
            if (imageData != null) {
              bitmapList.add(imageData);
            }
          }
        }

        totalImages = bitmapList.length;
        if (currentContext.mounted) {
          showDialog(
            context: context,
            builder: (_) => PrintSetupDialog(imageValue: bitmapList, paperWidth: paperWidth, paperHeight: paperHeight),
          );
        }
      } else {
        final image = await convertWidgetToImage(paperWidth);
        if (image != null) {
          final imageData = await convertImageToData(image);
          if (imageData != null) {
            bitmapList.add(imageData);
            totalImages = bitmapList.length;

            if (currentContext.mounted) {
              showDialog(
                context: context,
                builder: (_) =>
                    PrintSetupDialog(imageValue: bitmapList, paperWidth: paperWidth, paperHeight: paperHeight),
              );
            }
          }
        }
      }
    } finally {
      if (wasBackgroundVisible) {
        showBackgroundImageWidget = true;
        notifyListeners();
      }
    }
  }

  /// Label Setup
  Future<void> thermalLabelSetup(BuildContext context) async {
    TextEditingController widthController = TextEditingController(text: paperWidth.toString());
    TextEditingController heightController = TextEditingController(text: paperHeight.toString());
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return ContentDialog(
          title: Center(child: Text(DTexts.instance.labelSetup, style: context.titleLarge)),
          content: SizedBox(
            height: 110.h,
            child: Column(
              children: [
                const SizedBox(height: DSizes.defaultSpace),

                /// Paper Width Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 100, child: Text(DTexts.instance.widthM)),
                    Expanded(
                      child: TextBox(
                        controller: widthController,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        maxLines: 1,
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DSizes.defaultSpace),

                /// Paper Height Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 100, child: Text(DTexts.instance.heightM)),
                    Expanded(
                      child: TextBox(
                        controller: heightController,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        maxLines: 1,
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  child: Text(DTexts.instance.cancel, style: context.bodyStrong),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
                Button(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(color: DColors.primary),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(DColors.white),
                  ),
                  child: Text(
                    DTexts.instance.labelSet,
                    style: context.bodyStrong.copyWith(color: DColors.primary, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    int? widthValue = int.tryParse(widthController.text);
                    int? heightValue = int.tryParse(heightController.text);

                    if (widthValue! <= context.thermalPaperSizeProvider.maxWidth &&
                        heightValue! <= context.thermalPaperSizeProvider.maxHeight) {
                      Navigator.pop(dialogContext);
                      paperWidth = widthValue;
                      paperHeight = heightValue;
                      calculateLabelDimensions(paperWidth.toDouble(), paperHeight.toDouble());
                      notifyListeners();
                    } else {
                      DSnackBar.warning(title: DTexts.instance.invalidInput, message: DTexts.instance.lErrorMessage);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> dotLabelSetup(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return ContentDialog(
          title: Center(child: Text(DTexts.instance.labelSetup, style: context.titleLarge)),
          content: Consumer<DotPaperSizeProvider>(
            builder: (context, dotP, child) {
              return SizedBox(
                height: 180.h,
                child: Column(
                  children: [
                    /// Select Paper Size Section
                    CommonLabelPaperSize(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // select text tittle
                          Text(DTexts.instance.paperSize, style: context.bodyLarge),

                          ComboBox<String>(
                            value: dotP.paperSizeList.isNotEmpty
                                ? dotP.paperSizeList[dotP.selectedPaperIndex].defaultHeight
                                : null,
                            placeholder: Text(DTexts.instance.selectPaperSize, style: context.bodyStrong),
                            items: dotP.paperSizeList.map((size) {
                              return ComboBoxItem<String>(
                                value: size.defaultHeight,
                                child: Text(size.defaultHeight ?? "", style: context.body),
                              );
                            }).toList(),
                            onChanged: (value) => dotP.setPaperSizeFromText(value),
                            //onChanged: (value) => setPaperSizeFromText(dialogContext, value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DSizes.spaceBtwSections),

                    /// Paper Width Section
                    CommonLabelPaperSize(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // text width tittle
                          Text(DTexts.instance.widthM, style: context.bodyLarge),

                          // input width field
                          Container(
                            width: 120,
                            height: 35,
                            color: DColors.primary.withValues(alpha: (0.1 * 255)),
                            child: TextBox(
                              readOnly: true,
                              placeholder: dotP.widthText.toString(),
                              textAlign: TextAlign.center,
                              style: context.bodyStrong,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DSizes.spaceBtwSections),

                    /// Paper Height Section
                    CommonLabelPaperSize(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // text width tittle
                          Text(DTexts.instance.heightM, style: context.bodyLarge),

                          // input width field
                          Container(
                            width: 120,
                            height: 35,
                            color: DColors.primary.withValues(alpha: (0.1 * 255)),
                            child: TextBox(
                              readOnly: true,
                              placeholder: dotP.heightText.toString(),
                              textAlign: TextAlign.center,
                              style: context.bodyStrong,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  child: Text(DTexts.instance.cancel, style: context.bodyStrong),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
                Button(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(color: DColors.primary),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(DColors.white),
                  ),
                  child: Text(
                    DTexts.instance.labelSet,
                    style: context.bodyStrong.copyWith(color: DColors.primary, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    paperWidth = context.dotPaperSizeProvider.widthText;
                    paperHeight = context.dotPaperSizeProvider.heightText;
                    Navigator.pop(dialogContext);
                    notifyListeners();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// List Clean Function
  Future<void> cleanLabelList(BuildContext context) async {
    /// Background Section
    backgroundImage = null;
    showBackgroundImageWidget = false;

    /// Text Section
    textCodes.clear();
    textCodeOffsets.clear();
    textFocusNodes.clear();
    textControllers.clear();
    textContainerRotations.clear();
    updateTextBold.clear();
    updateTextItalic.clear();
    updateTextUnderline.clear();
    updateTextStrikeThrough.clear();
    updateTextAlignment.clear();
    alignLeft.clear();
    alignCenter.clear();
    alignRight.clear();
    alignStraight.clear();
    textSelectedFontFamily.clear();
    updateTextFontSize.clear();
    updateTextWidthSize.clear();
    updateTextHeightSize.clear();
    isTextLock.clear();
    showTextEditingContainerFlag = false;

    /// Barcode Section
    barCodes.clear();
    barCodeOffsets.clear();
    barCalculatedWidth.clear();
    brFocusNodes.clear();
    barcodeControllers.clear();
    barCodesContainerRotations.clear();
    updateBarcodeWidth.clear();
    updateBarcodeHeight.clear();
    barEncodingType.clear();
    barTextFontSize.clear();
    barTextBold.clear();
    barTextItalic.clear();
    barTextUnderline.clear();
    barTextStrikeThrough.clear();
    prefixController.clear();
    inputController.clear();
    suffixController.clear();
    incrementController.clear();
    endPageController.clear();
    selectBarcodeTypeIndex.clear();
    isBarcodeLock.clear();
    drawText.clear();
    prefixNumber.clear();
    suffixNumber.clear();
    incrementNumber.clear();
    endPageNumber.clear();
    showBarcodeContainerFlag = false;

    /// Qrcode Section
    qrCodes.clear();
    qrCodeOffsets.clear();
    qrFocusNodes.clear();
    qrcodeControllers.clear();
    updateQrcodeSize.clear();
    isQrcodeLock.clear();
    showQrcodeContainerFlag = false;

    /// Table Section
    tableCodes.clear();
    tableOffsets.clear();
    rowCount.clear();
    columnCount.clear();
    tableLineWidth.clear();
    tablesCells.clear();
    tableTextFocusNodes.clear();
    tablesRowHeights.clear();
    tablesColumnWidths.clear();
    tablesSelectedCells.clear();
    textController.clear();
    tableContainerRotations.clear();
    tableBorderStyle.clear();
    isTableLock.clear();
    showTableWidget = false;
    showTableContainerFlag = false;

    /// Image Section
    imageCodes.clear();
    imageOffsets.clear();
    updateImageSize.clear();
    imageCodesContainerRotations.clear();
    isImageLock.clear();
    showImageContainerFlag = false;

    /// Emoji Section
    emojiCodes.clear();
    selectedEmojis.clear();
    emojiCodeOffsets.clear();
    updatedEmojiWidth.clear();
    emojiCodesContainerRotations.clear();
    emojiBorder = false;
    showEmojiWidget = false;
    showEmojiContainerFlag = false;
    isEmojiLock.clear();
    selectedEmojiCategory = null;

    /// Shape Section
    shapeCodes.clear();
    shapeOffsets.clear();
    updateShapeWidth.clear();
    updateShapeHeight.clear();
    isSquareUpdate.clear();
    isRoundSquareUpdate.clear();
    isCircularUpdate.clear();
    isOvalCircularUpdate.clear();
    shapeTypes.clear();
    updateShapeLineWidthSize.clear();
    shapeCodesContainerRotations.clear();
    isFixedFigureSize.clear();
    trueShapeWidth.clear();
    trueShapeHeight.clear();
    shapeBorder = false;
    fixedShapeSize = false;
    showShapeWidget = false;
    isShapeLock.clear();
    showShapeContainerFlag = false;

    /// Line Widget Variable
    lineCodes.clear();
    lineOffsets.clear();
    lineCodesContainerRotations.clear();
    updateSliderLineWidth.clear();
    isDottedLineUpdate.clear();
    updateLineWidth.clear();
    isLineLock.clear();
    showLineWidget = false;
    showLineContainerFlag = false;
    lineBorder = false;

    /// Misc
    checkTextIdentifyWidget = ['text'];

    /// clear undo redo history
    context.undoRedoProvider.clearHistory();
    context.copyPasteProvider.clear();

    /// clear multiple select widget
    isMultiSelectEnabled = false;
    selectedWidgetIndices.clear();
    //showMultiSelectContainerFlag = false;

    /// For Back Screen
    Navigator.pop(context);
  }
}
