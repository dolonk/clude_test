import 'dart:async';
import 'package:pdfx/pdfx.dart';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../localization/main_texts.dart';
import '../../../../utils/local_storage/local_data.dart';
import '../../../../utils/snackbar_toast/snack_bar.dart';
import '../../../../common/crop_image_screen/crop_image.dart';
import '../../../../data_layer/models/crop_model/crop_model.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../common/print_settings/provider/common_sdk_variable.dart';
import '../../../../common/common_isolated_data.dart';

class ThermalDocumentProvider extends ChangeNotifier {
  late TextEditingController scaleController;
  late TextEditingController pageStartController;
  TextEditingController pageEndController = TextEditingController();
  Map<int, TextEditingController> paperWidthControllers = {};
  Map<int, TextEditingController> paperHeightControllers = {};

  // pdf variable
  bool isLoading = true;
  bool isPrintLoading = false;
  bool isPrinterStop = false;
  bool isSaveData = false;
  int startPage = 1;
  int totalPages = 0;
  int jumToPage = 0;
  List<Uint8List> allPdfPage = [];

  // calculated width height variable
  bool isAspectRatio = true;
  bool zoomPage = false;
  double percent = 0;
  double rotatedPercent = 0;
  double selectWidth = 103;
  double selectHeight = 150;
  Map<int, int> pageWidth = {};
  Map<int, int> pageHeight = {};

  // crop variable
  bool isCropTicker = false;
  bool isAllPagesCropped = false;

  // Single crop ratio
  List<bool> isSingleCrop = [];
  double singleCropPercent = 0;
  double singleCropPercentRotated = 0;

  // Tiger rotation position
  int rotationDegree = 0;

  // for tracing pdf variable
  int currentPdfIndex = 1;
  List<Map<String, int>> pdfPageRanges = [];

  ThermalDocumentProvider({required List<String> filePaths}) {
    pageStartController = TextEditingController(text: '1');
    scaleController = TextEditingController(text: '2');
    initData(filePaths: filePaths);
  }

  void setZoomPageValue(bool flag) {
    zoomPage = flag;
    notifyListeners();
  }

  void setIsAspectRatio() {
    isAspectRatio = !isAspectRatio;
    notifyListeners();
  }

  void setIsSaveData() async {
    isSaveData = !isSaveData;
    await LocalData.saveLocalData<bool>('isSaveData', isSaveData);
    notifyListeners();
  }

  void setAllPageCrop(bool value) {
    isAllPagesCropped = value;
    notifyListeners();
  }

  Future<void> _getDataLocalStorage() async {
    isSaveData = await LocalData.getLocalData('isSaveData') ?? false;
    isAspectRatio = await LocalData.getLocalData('isAspectRatio') ?? true;
    double? savedWidth = await LocalData.getLocalData('thermalPaperWidth') ?? 103;
    double? savedHeight = await LocalData.getLocalData('thermalPaperHeight') ?? 150;

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      if (isSaveData) {
        // Initialize controllers with saved data
        paperWidthControllers[pageIndex] = TextEditingController(text: savedWidth.toStringAsFixed(0));
        paperHeightControllers[pageIndex] = TextEditingController(text: savedHeight.toStringAsFixed(0));
      } else {
        _initCalculatedWidthHeight(percent: percent, pageIndex: pageIndex);
      }
    }

    notifyListeners();
  }

  Future<void> initData({required List<String> filePaths, double scale = 2}) async {
    try {
      await _clearAllData();
      int currentStartPage = 1;

      isLoading = true;

      for (String filePath in filePaths) {
        // Load and render pages of current PDF
        final document = await PdfDocument.openFile(filePath);
        final int totalPagesForThisDoc = document.pagesCount;

        if (totalPagesForThisDoc >= 50) {
          await _renderPdfPagesFromDoc(document: document, scale: scale, start: 1, end: 10);

          Future(() async {
            await _renderPdfPagesFromDoc(document: document, scale: 2, start: 11, end: totalPagesForThisDoc);
            _onBackgroundPagesLoaded();
          });
        } else {
          await _renderPdfPagesFromDoc(document: document, scale: scale, start: 1, end: totalPagesForThisDoc);
        }

        pdfPageRanges.add({'start': currentStartPage, 'end': currentStartPage + totalPagesForThisDoc - 1});

        currentStartPage += totalPagesForThisDoc;
      }

      isSingleCrop = List<bool>.generate(allPdfPage.length, (_) => false);
      _getDataLocalStorage();

      totalPages = allPdfPage.length;
      pageEndController.text = totalPages.toString();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error Initializing PDF Files: $e');
    }
  }

  Future<void> _renderPdfPagesFromDoc({
    required PdfDocument document,
    required double scale,
    int start = 1,
    int? end,
  }) async {
    int finalEnd = end ?? document.pagesCount;

    for (int pageIndex = start; pageIndex <= finalEnd; pageIndex++) {
      final page = await document.getPage(pageIndex);

      final rendered = await page.render(
        width: page.width.toInt() * scale,
        height: page.height.toInt() * scale,
        format: PdfPageImageFormat.png,
        forPrint: true,
        backgroundColor: '#FFFFFF',
      );

      final image = rendered?.bytes;
      if (image != null) allPdfPage.add(image);

      percent = page.height / page.width;
      rotatedPercent = page.width / page.height;
      jumToPage = allPdfPage.length;

      notifyListeners();
      await page.close();
    }
  }

  /// Called when background page rendering completes for large PDFs (50+ pages)
  void _onBackgroundPagesLoaded() {
    // Update totalPages to reflect all loaded pages
    totalPages = allPdfPage.length;
    pageEndController.text = totalPages.toString();

    // Extend isSingleCrop list for newly added pages
    if (isSingleCrop.length < totalPages) {
      isSingleCrop.addAll(List<bool>.generate(totalPages - isSingleCrop.length, (_) => false));
    }

    // Initialize width/height controllers for new pages
    _getDataLocalStorage();

    notifyListeners();
  }

  Future<void> setCrop(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    // sinel crop for particular page
    if (!isAllPagesCropped) {
      await cropPdfPage(context: context, pageIndex: startPage - 1);
    }
    // Auto Crop for all page
    else {
      if (allPdfPage.isNotEmpty) {
        await cropPdfPage(context: context, pageIndex: 0);

        for (int i = 1; i < allPdfPage.length; i++) {
          if (!context.mounted) return;
          await cropPdfPage(context: context, pageIndex: i);
        }
      }
    }

    isLoading = false;
    isAllPagesCropped = false;
    notifyListeners();
  }

  Future<void> cropPdfPage({required BuildContext context, required int pageIndex}) async {
    final Uint8List getImage = allPdfPage[pageIndex];
    if (getImage.isEmpty) throw Exception("No image found for cropping.");
    CropModel? cropModel;

    // manually crop first page and  return get position
    if (!isAllPagesCropped || pageIndex == 0) {
      cropModel = await openCropScreen(context: context, imageBytes: getImage);

      if (cropModel == null) {
        isLoading = false;
        notifyListeners();
        throw Exception("Image cropping canceled or failed.");
      }

      globalCropX = cropModel.x;
      globalCropY = cropModel.y;
      globalCropWidth = cropModel.width;
      globalCropHeight = cropModel.height;

      debugPrint("Crop Area => x: $globalCropX, y: $globalCropY, width: $globalCropWidth, height: $globalCropHeight");
    }

    // check null value
    if (globalCropX == null || globalCropY == null || globalCropWidth == null || globalCropHeight == null) {
      isLoading = false;
      notifyListeners();
      throw Exception("Crop dimensions are not set. Please crop the first page manually.");
    }

    final croppedImage = await autoImageCrop(
      pdfPage: getImage,
      x: globalCropX!.toInt(),
      y: globalCropY!.toInt(),
      width: globalCropWidth!.toInt(),
      height: globalCropHeight!.toInt(),
    );

    if (croppedImage == null) throw Exception("Auto-cropping failed. Cropped image is null.");

    // Add image to main list
    allPdfPage[pageIndex] = croppedImage;

    // calculation width height to Single page
    if (!isAllPagesCropped) {
      isSingleCrop[pageIndex] = true;

      Map<int, double> croppedImageWidths = {};
      Map<int, double> croppedImageHeights = {};
      croppedImageWidths[pageIndex] = globalCropWidth!;
      croppedImageHeights[pageIndex] = globalCropHeight!;
      singleCropPercent = croppedImageHeights[pageIndex]! / croppedImageWidths[pageIndex]!;
      singleCropPercentRotated = croppedImageWidths[pageIndex]! / croppedImageHeights[pageIndex]!;

      if (rotationDegree == 90 || rotationDegree == 270) {
        _initRotatedCalculatedWidthHeight(rotatedPercent: singleCropPercentRotated, pageIndex: pageIndex);
      } else {
        _initCalculatedWidthHeight(percent: singleCropPercent, pageIndex: pageIndex);
      }
    }
    // calculation width height to all page
    else {
      if (isAllPagesCropped) {
        percent = globalCropHeight! / globalCropWidth!;
        rotatedPercent = globalCropWidth! / globalCropHeight!;
        await _setRotatedUnRotatedIntData(percent: percent, rotatedPercent: rotatedPercent);
      }
    }

    debugPrint("Page $pageIndex cropped successfully!");
  }

  void setPaperScale(List<String> filePath, int scale) async {
    if (scale < 1 || scale > 4) {
      DSnackBar.warning(title: "Invalid scale value. Please enter a value between 1 and 4.");
      return;
    }

    if (!isCropTicker) {
      await initData(filePaths: filePath, scale: scale.toDouble());
    } else {
      DSnackBar.errorSnackBar(title: "Crop mode is enabled. Please disable it to change the scale.");
    }
    notifyListeners();
  }

  void goToPreviousPage() {
    if (startPage > 1) {
      startPage--;
      pageStartController.text = startPage.toString();
      notifyListeners();
    }
  }

  void goToNextPage() {
    if (startPage < allPdfPage.length) {
      startPage++;
      pageStartController.text = startPage.toString();
      notifyListeners();
    }
  }

  void jumpToPage(int page) {
    if (page >= 1 && page <= allPdfPage.length) {
      startPage = page;
      pageStartController.text = startPage.toString();
      notifyListeners();
    }
  }

  /// #---------------------------- Un Rotation Calculated Section ----------------------------------------#
  void _initCalculatedWidthHeight({double? percent, int? pageIndex}) {
    if (percent == null || pageIndex == null) {
      debugPrint("Error: Percent or pageIndex is null.");
      return;
    }
    if (!paperWidthControllers.containsKey(pageIndex)) {
      paperWidthControllers[pageIndex] = TextEditingController();
    }
    if (!paperHeightControllers.containsKey(pageIndex)) {
      paperHeightControllers[pageIndex] = TextEditingController();
    }

    // Automatic calculated width height
    if (isAspectRatio) {
      // calculated paper height
      selectHeight = (percent * selectWidth);
      if (selectHeight > 150) selectHeight = 150;
      pageHeight[pageIndex] = selectHeight.toInt();

      // calculated paper Width
      selectWidth = (selectHeight / percent);
      if (selectWidth > 104) selectWidth = 104;
      pageWidth[pageIndex] = selectWidth.toInt();

      paperWidthControllers[pageIndex]!.text = pageWidth[pageIndex]?.toString() ?? '103';
      paperHeightControllers[pageIndex]!.text = pageHeight[pageIndex]?.toString() ?? '150';
    }
    // Default Width Height
    else {
      paperWidthControllers[pageIndex]!.text = LocalData.thSharedPaperWidth.toStringAsFixed(0);
      paperHeightControllers[pageIndex]!.text = LocalData.thSharedPaperHeight.toStringAsFixed(0);
    }
  }

  void userInputWidthHeight({required String selectField, int width = 0, int height = 0}) {
    /// Apply aspect ratio automatic get width height
    if (isAspectRatio) {
      /// Single Crop input page
      if (isSingleCrop[startPage - 1]) {
        _calculatedInputWidthHeight(selectField, width, height, singleCropPercent, startPage - 1);
      }
      /// All page input data excluding pages with isSingleCrop true
      else {
        for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
          // Skip pages where isSingleCrop is true
          if (isSingleCrop[pageIndex]) continue;
          _calculatedInputWidthHeight(selectField, width, height, percent, pageIndex);
        }
      }
    }
    /// Without Aspect Ratio
    else {
      for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
        final widthController = paperWidthControllers[pageIndex] ?? TextEditingController();
        final heightController = paperHeightControllers[pageIndex] ?? TextEditingController();

        /// Without Aspect ratio
        if (selectField.toUpperCase() == "WIDTH") {
          if (width > 103) width = 103;
          if (widthController.text != width.toString()) {
            widthController.text = width.toString();
          }
        } else if (selectField.toUpperCase() == "HEIGHT") {
          if (height > 150) height = 150;
          if (heightController.text != height.toString()) {
            heightController.text = height.toString();
          }
        }

        paperWidthControllers[pageIndex] = widthController;
        paperHeightControllers[pageIndex] = heightController;
      }
    }

    notifyListeners();
  }

  void _calculatedInputWidthHeight(String selectField, int width, int height, double percent, int pageIndex) {
    final widthController = paperWidthControllers[pageIndex] ?? TextEditingController();
    final heightController = paperHeightControllers[pageIndex] ?? TextEditingController();

    // Determine max width and height
    if (width > 103) {
      width = 103;
      widthController.text = width.toString();
    } else if (height > 150) {
      height = 150;
      heightController.text = height.toString();
    }

    // Calculate input width & height based on aspect ratio
    if (selectField.toUpperCase() == "WIDTH") {
      double inputWidth = width.toDouble();

      double calculatedHeight = inputWidth * percent;
      if (calculatedHeight > 150) calculatedHeight = 150;

      heightController.text = calculatedHeight.toStringAsFixed(0);
    } else if (selectField.toUpperCase() == "HEIGHT") {
      double inputHeight = height.toDouble();

      double calculatedWidth = inputHeight / percent;
      if (calculatedWidth > 103) calculatedWidth = 103;

      widthController.text = calculatedWidth.toStringAsFixed(0);
    }

    paperWidthControllers[pageIndex] = widthController;
    paperHeightControllers[pageIndex] = heightController;
  }

  /// #---------------------------- Rotation Calculated Section ----------------------------------------#
  void uiChangeRotation(BuildContext context) async {
    if (!isCropTicker) {
      rotationDegree += 90;
      if (rotationDegree == 360) rotationDegree = 0;

      await _setRotatedUnRotatedIntData(percent: percent, rotatedPercent: rotatedPercent);
    } else {
      DSnackBar.errorSnackBar(title: "crop mode is enabled. Please disable it to change the rotation.");
    }

    notifyListeners();
  }

  Future<void> _setRotatedUnRotatedIntData({required double percent, required double rotatedPercent}) async {
    if (rotationDegree == 90 || rotationDegree == 270) {
      for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
        _initRotatedCalculatedWidthHeight(rotatedPercent: rotatedPercent, pageIndex: pageIndex);
      }
    } else {
      for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
        _initCalculatedWidthHeight(percent: percent, pageIndex: pageIndex);
      }
    }
  }

  void _initRotatedCalculatedWidthHeight({double? rotatedPercent, int? pageIndex}) {
    if (rotatedPercent == null || pageIndex == null) {
      debugPrint("Error: Percent or pageIndex is null.");
      return;
    }

    if (!paperWidthControllers.containsKey(pageIndex)) {
      paperWidthControllers[pageIndex] = TextEditingController();
    }

    if (!paperHeightControllers.containsKey(pageIndex)) {
      paperHeightControllers[pageIndex] = TextEditingController();
    }

    // Assign width height to controller
    if (isAspectRatio) {
      // Rotated height
      double height = selectWidth * rotatedPercent;
      if (height > 103) height = 103;
      pageHeight[pageIndex] = height.toInt();

      // Rotated width
      double width = height / rotatedPercent;
      pageWidth[pageIndex] = width.toInt();

      paperWidthControllers[pageIndex]!.text = pageWidth[pageIndex]?.toString() ?? '103';
      paperHeightControllers[pageIndex]!.text = pageHeight[pageIndex]?.toString() ?? '150';
    } else {
      paperWidthControllers[pageIndex]!.text = LocalData.thSharedPaperWidth.toStringAsFixed(0);
      paperHeightControllers[pageIndex]!.text = LocalData.thSharedPaperHeight.toStringAsFixed(0);
    }
  }

  void rotatedUserInputWidthHeight({required String selectField, int width = 0, int height = 0}) {
    /// Apply aspect ratio automatic get width height
    if (isAspectRatio) {
      /// Single Crop input page
      if (isSingleCrop[startPage - 1]) {
        _rotatedCalculatedInputWidthHeight(selectField, width, height, singleCropPercentRotated, startPage - 1);
      }
      /// All page input data excluding pages with isSingleCrop true
      else {
        for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
          // Skip pages where isSingleCrop is true
          if (isSingleCrop[pageIndex]) continue;
          _rotatedCalculatedInputWidthHeight(selectField, width, height, rotatedPercent, pageIndex);
        }
      }
    }
    /// Without Aspect Ratio
    else {
      for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
        final widthController = paperWidthControllers[pageIndex] ?? TextEditingController();
        final heightController = paperHeightControllers[pageIndex] ?? TextEditingController();

        /// Without Aspect ratio
        if (selectField.toUpperCase() == "WIDTH") {
          if (width > 103) width = 103;

          if (widthController.text != width.toString()) {
            widthController.text = width.toString();
          }
        } else if (selectField.toUpperCase() == "HEIGHT") {
          if (height > 150) height = 150;

          if (heightController.text != height.toString()) {
            heightController.text = height.toString();
          }
        }

        paperWidthControllers[pageIndex] = widthController;
        paperHeightControllers[pageIndex] = heightController;
      }
    }

    notifyListeners();
  }

  void _rotatedCalculatedInputWidthHeight(
    String selectField,
    int width,
    int height,
    double rotatedPercent,
    int pageIndex,
  ) {
    final widthController = paperWidthControllers[pageIndex] ?? TextEditingController();
    final heightController = paperHeightControllers[pageIndex] ?? TextEditingController();

    // Determine max width and height
    if (width > selectWidth) {
      width = 103;
      widthController.text = width.toString();
    } else if (height > 150) {
      height = 150;
      heightController.text = height.toString();
    }

    // Calculate input width & height based on aspect ratio
    if (selectField.toUpperCase() == "WIDTH") {
      double calculatedWidth = width.toDouble();
      double calculatedHeight = calculatedWidth * rotatedPercent;

      if (calculatedWidth > 103) {
        calculatedWidth = 103;
        calculatedHeight = calculatedWidth / rotatedPercent;
      }

      if (calculatedHeight > 150) {
        calculatedHeight = 150;
        calculatedWidth = calculatedHeight * rotatedPercent;
      }

      //widthController.text = calculatedWidth.toStringAsFixed(0);
      heightController.text = calculatedHeight.toStringAsFixed(0);
    } else if (selectField.toUpperCase() == "HEIGHT") {
      double calculatedHeight = height.toDouble();
      double calculatedWidth = calculatedHeight / rotatedPercent;

      if (calculatedWidth > 103) {
        calculatedWidth = 103;
        calculatedHeight = calculatedWidth * rotatedPercent;
      }

      if (calculatedHeight > 150) {
        calculatedHeight = 150;
        calculatedWidth = calculatedHeight / rotatedPercent;
      }

      //heightController.text = calculatedHeight.toStringAsFixed(0);
      widthController.text = calculatedWidth.toStringAsFixed(0);
    }

    paperWidthControllers[pageIndex] = widthController;
    paperHeightControllers[pageIndex] = heightController;
  }

  Future<void> _saveDataToLocalStorage() async {
    if (isSaveData) {
      await LocalData.saveLocalData<bool>('isAspectRatio', isAspectRatio);
      if (paperWidthControllers.isNotEmpty && paperHeightControllers.isNotEmpty) {
        await LocalData.saveLocalData<double>(
          'thermalPaperWidth',
          double.tryParse(paperWidthControllers.values.first.text) ?? 103.0,
        );
        await LocalData.saveLocalData<double>(
          'thermalPaperHeight',
          double.tryParse(paperHeightControllers.values.first.text) ?? 150.0,
        );
      }
    }
  }

  void checkPaperEnd(int value) {
    if (value <= 0) {
      value = 0;
    } else if (value > totalPages) {
      value = totalPages;
    }

    pageEndController.text = value.toString();
    notifyListeners();
  }

  void startPrint(BuildContext context) async {
    await createBitmapImages(context);

    await _saveDataToLocalStorage();
  }

  Future<void> _clearAllData() async {
    isLoading = true;
    isPrintLoading = false;
    startPage = 1;
    totalPages = 0;
    allPdfPage.clear();

    percent = 0;
    rotatedPercent = 0;
    rotationDegree = 0;
    pageWidth.clear();
    pageHeight.clear();

    isCropTicker = false;
    isAllPagesCropped = false;
    isSingleCrop.clear();
    singleCropPercent = 0;
    singleCropPercentRotated = 0;

    pdfPageRanges.clear();
    currentPdfIndex = 1;
  }

  /// #---------------------------- Print Section ----------------------------------------#
  Future<void> createBitmapImages(BuildContext context) async {
    // Get start and end page from user input, with fallbacks
    int start = int.tryParse(pageStartController.text) ?? 1;
    int end = int.tryParse(pageEndController.text) ?? totalPages;

    // Ensure start and end are within valid page range
    start = start.clamp(1, totalPages);
    end = end.clamp(start, totalPages);

    if (start > end) {
      debugPrint("Invalid page range: start ($start) is greater than end ($end)");
      return;
    }

    // Calculate total prints = pages * copies
    int copies = int.tryParse(isPrintSetting ? pPrinterCopy.text : lPrinterCopy.text) ?? 1;
    int totalPrints = (end - start + 1) * copies;

    // Initialize printing with total count
    if (!context.mounted) return;
    context.printerSdkProvider.initPrinting(totalPrints);
    debugPrint('Start - Total prints: $totalPrints');

    try {
      // Process each page within the valid range
      for (int i = start - 1; i < end; i++) {
        // Check if cancelled
        if (!context.mounted) return;
        if (context.printerSdkProvider.isCancelled) {
          context.printerSdkProvider.completePrinting();
          return;
        }

        if (paperWidthControllers.containsKey(i) && paperHeightControllers.containsKey(i)) {
          // Get width and height for each page from controllers, or use defaults
          String widthValue = paperWidthControllers[i]?.text ?? '100';
          String heightValue = paperHeightControllers[i]?.text ?? '135';
          double paperWidth = double.tryParse(widthValue) ?? 100.0;
          double paperHeight = double.tryParse(heightValue) ?? 135.0;

          // Calculate dot values and limit within maximum dimensions
          double dotWidth = (paperWidth * 8).clamp(0, 800);
          double dotHeight = (paperHeight * 8).clamp(0, 1080);

          // Rotate or resize page as needed, then add to bitmaps if successful
          Uint8List? resizedPage;
          if ([90, 180, 270].contains(rotationDegree)) {
            resizedPage = await processRotateImage(
              imgBytes: allPdfPage[i],
              degrees: rotationDegree,
              width: dotWidth.toInt(),
              height: dotHeight.toInt(),
            );
          } else {
            resizedPage = await processResizeImage(
              pdfPage: allPdfPage[i],
              width: dotWidth.toInt(),
              height: dotHeight.toInt(),
            );
          }

          // Add the processed page or log an error if null
          if (resizedPage != null && resizedPage.isNotEmpty) {
            debugPrint('Resize Page Size ${i + 1}: Width: $dotWidth, Height: $dotHeight');

            // Send one page at a time with await - external state management
            if (!context.mounted) return;
            await context.printerSdkProvider.thermalPrintToSdk(
              imageData: resizedPage,
              paperWidth: dotWidth.toInt(),
              paperHeight: dotHeight.toInt(),
            );
          } else {
            debugPrint('Error: Resized image for Page ${i + 1} is null');
          }
        } else {
          DSnackBar.errorSnackBar(title: 'Page ${i + 1}: Missing width/height controllers');
        }
      }
      debugPrint('Print End');
      if (context.mounted) context.printerSdkProvider.completePrinting();
    } catch (e) {
      if (context.mounted) context.printerSdkProvider.completePrinting(error: e.toString());
      DSnackBar.warning(title: DTexts.instance.selectPrinter);
    }
  }

  @override
  void dispose() {
    pageStartController.dispose();
    pageEndController.dispose();
    scaleController.dispose();
    paperWidthControllers.forEach((key, controller) {
      controller.dispose();
    });
    paperHeightControllers.forEach((key, controller) {
      controller.dispose();
    });
    _clearAllData();
    super.dispose();
  }
}
