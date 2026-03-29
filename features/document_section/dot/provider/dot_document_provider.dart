import 'dart:convert';
import 'package:pdfx/pdfx.dart';
import '../../../../utils/env.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../localization/main_texts.dart';
import '../../../../utils/local_storage/local_data.dart';
import '../../../../utils/snackbar_toast/snack_bar.dart';
import '../../../../common/crop_image_screen/crop_image.dart';
import '../../../../utils/constants/label_global_variable.dart';
import '../../../../data_layer/models/crop_model/crop_model.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../common/print_settings/provider/common_sdk_variable.dart';
import '../../../../common/common_isolated_data.dart';
import '../../../../data_layer/models/document_print/dot_model_class.dart';

class DotDocumentProvider extends ChangeNotifier {
  TextEditingController scaleController = TextEditingController();
  TextEditingController pageStartController = TextEditingController();
  TextEditingController pageEndController = TextEditingController();
  Map<int, TextEditingController> paperWidthControllers = {};
  Map<int, TextEditingController> paperHeightControllers = {};

  // server api variable
  List<DotPrintModelClass>? dotModels;
  int selectedPaperHeightIndex = 0;
  String selectedPaperHeight = '279.4mm(holes 22)';
  final minusFiveHeight = 5.0;
  int selectPaperM = 0;

  // pdf variable
  bool isLoading = true;
  bool isPrintLoading = false;
  bool isPrinterStop = false;
  bool isDefaultCrop = true;
  int startPage = 1;
  int totalPages = 0;
  int jumToPage = 0;
  List<Uint8List> allPdfPage = [];
  List<Uint8List> originalPdfPage = [];

  // calculated width height variable
  bool isAspectRatio = true;
  bool zoomPage = false;
  double percent = 0;
  double rotatedPercent = 0;
  int selectWidth = 0;
  int selectHeight = 0;
  Map<int, int> pageWidth = {};
  Map<int, int> pageHeight = {};

  // crop variable
  bool isCropTicker = false;
  bool isAllPagesCropped = false;

  // Single crop ratio
  List<bool> isSingleCrop = [];
  double singleCropPercent = 0;
  double singleCropPercentRotated = 0;
  double autoCropPercent = 0;

  // Tiger rotation position
  int rotationDegree = 0;

  // for tracing pdf variable
  int currentPdfIndex = 1;
  List<Map<String, int>> pdfPageRanges = [];

  DotDocumentProvider({required List<String> filePaths}) {
    pageStartController = TextEditingController(text: '1');
    scaleController = TextEditingController(text: '2');

    initData(filePaths: filePaths);
  }

  // local data form local storage
  Future<void> _getDataLocalStorage() async {
    isDefaultCrop = await LocalData.getLocalData('isDefaultCropDot') ?? true;
    isAspectRatio = await LocalData.getLocalData('isAspectRatio') ?? true;
    selectedPaperHeightIndex = await LocalData.getLocalData('selectedPaperIndex') ?? 0;
    selectedPaperHeight = await LocalData.getLocalData('selectedPaperHeight') ?? '279.4mm(holes 22)';

    double? savedWidth = await LocalData.getLocalData('dotSharedPaperWidth');
    double? savedHeight = await LocalData.getLocalData('dotSharedPaperHeight');
    if (savedWidth != null && savedHeight != null) {
      paperWidthControllers.clear();
      paperHeightControllers.clear();

      // Initialize controllers with saved data
      for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
        paperWidthControllers[pageIndex] = TextEditingController(text: savedWidth.toStringAsFixed(0));
        paperHeightControllers[pageIndex] = TextEditingController(text: savedHeight.toStringAsFixed(0));
      }
    }

    notifyListeners();
  }

  void setZoomPageValue(bool flag) {
    zoomPage = flag;
    notifyListeners();
  }

  void setIsAspectRatio() {
    isAspectRatio = !isAspectRatio;
    notifyListeners();
  }

  void setIsDefaultCrop(bool value) async {
    isDefaultCrop = value;
    await LocalData.saveLocalData<bool>('isDefaultCropDot', isDefaultCrop);

    isLoading = true;
    notifyListeners();

    await cropPdfPagesBySize(cropImage: originalPdfPage);

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      if ([90, 180, 270].contains(rotationDegree)) {
        await _setRotatedUnRotatedIntData(percent: percent, rotatedPercent: rotatedPercent);
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void setAllPageCrop(bool value) {
    isAllPagesCropped = value;
    notifyListeners();
  }

  Future<List<DotPrintModelClass>> _getDotHeightModel() async {
    try {
      isLoading = true;

      // Call the API to fetch data
      final response = await http.get(Uri.parse('${Env.zBaseUrl}/allWifiModelInfo'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        // Convert JSON response to a list of DotPrintModelClass
        List<DotPrintModelClass> models = jsonResponse.map((model) => DotPrintModelClass.fromJson(model)).toList();

        // Filter models with type "Dot"
        List<DotPrintModelClass> dotModels = models.where((model) => model.type == dotPrinter).toList();

        // Save data locally
        await DotPrintModelClass.saveToLocal(dotModels);

        return dotModels;
      } else {
        debugPrint('API call failed with status code: ${response.statusCode}');

        // Load data from local storage on failure
        return DotPrintModelClass.loadFromLocal();
      }
    } catch (e) {
      debugPrint('Failed to load model info from API: $e');
      // Load data from local storage on error
      return DotPrintModelClass.loadFromLocal();
    }
  }

  void setPaperHeight(String? value) async {
    if (value != null && value.isNotEmpty) {
      selectedPaperHeight = value;
      selectedPaperHeightIndex = dotModels!.indexWhere((model) => model.defaultHeight == value);
      if (selectedPaperHeightIndex == -1) {
        selectedPaperHeightIndex = 0;
      }

      await cropPdfPagesBySize(cropImage: originalPdfPage);

      for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
        if (isCropTicker) {
          await _initCalculatedWidthHeight(percent: singleCropPercent, pageIndex: pageIndex);
        }

        if ([90, 180, 270].contains(rotationDegree)) {
          await _setRotatedUnRotatedIntData(percent: percent, rotatedPercent: rotatedPercent);
        }
      }

      notifyListeners();
    } else {
      debugPrint("Selected paper height is null or empty.");
    }
  }

  Future<void> cropPdfPagesBySize({required List<Uint8List> cropImage}) async {
    for (int i = 0; i < cropImage.length; i++) {
      final originalBytes = cropImage[i];
      final originalImage = img.decodeImage(originalBytes);

      if (originalImage == null) {
        debugPrint("Image $i decode failed");
        continue;
      }

      if (!isDefaultCrop) {
        isLoading = true;
        notifyListeners();

        double isAutoCropPercent = originalImage.height / originalImage.width;
        autoCropPercent = isAutoCropPercent;
        await _initCalculatedWidthHeight(percent: isAutoCropPercent, pageIndex: i);
        allPdfPage[i] = originalBytes;

        isLoading = false;
        notifyListeners();
        continue;
      }

      String apiHeight = selectedPaperHeight.split('mm')[0];
      double getHeight = double.tryParse(apiHeight) ?? 0.0;

      int width = originalImage.width;
      int height = originalImage.height;

      double cropPercent = (getHeight / 279.4);
      double cropValue = 1 - cropPercent;

      int cropHeight = (height * (1 - cropValue)).toInt();

      isLoading = true;
      notifyListeners();

      Uint8List? croppedBytes = await autoCropImagePaperHeight(
        pdfPage: originalBytes,
        width: width,
        height: cropHeight,
      );

      final cropImage1 = img.decodeImage(croppedBytes!);

      if (cropImage1 == null) {
        debugPrint("Image $i decode failed");
        continue;
      }

      int cropWidth1 = cropImage1.width;
      int cropHeight1 = cropImage1.height;
      double isAutoCropPercent = cropHeight1 / cropWidth1;
      autoCropPercent = isAutoCropPercent;

      await _initCalculatedWidthHeight(percent: isAutoCropPercent, pageIndex: i);

      allPdfPage[i] = croppedBytes;

      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initData({required List<String> filePaths, double scale = 2}) async {
    try {
      await _clearAllData();
      int currentStartPage = 1;

      // Fetch data with fallback to local storage
      dotModels = await _getDotHeightModel();

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
      await _getDataLocalStorage();

      totalPages = allPdfPage.length;
      pageEndController.text = totalPages.toString();

      await cropPdfPagesBySize(cropImage: originalPdfPage);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error Initializing PDF Files: $e');
      DSnackBar.errorSnackBar(title: 'Error Initializing PDF Files', message: e.toString());
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
      if (image != null) originalPdfPage.add(image);

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

    // Initialize width/height controllers and crop for new pages
    _getDataLocalStorage();
    cropPdfPagesBySize(cropImage: originalPdfPage);

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

    if (croppedImage == null) {
      throw Exception("Auto-cropping failed. Cropped image is null.");
    }

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
    if (startPage < totalPages) {
      startPage++;
      pageStartController.text = startPage.toString();
      notifyListeners();
    }
  }

  void jumpToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      startPage = page;
      pageStartController.text = startPage.toString();
      notifyListeners();
    }
  }

  /// #---------------------------- Un Rotation Calculated Section ----------------------------------------#
  Future<void> _initCalculatedWidthHeight({double? percent, int? pageIndex}) async {
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

    String apiHeight = selectedPaperHeight.split('mm')[0];
    double getHeight = double.tryParse(apiHeight) ?? 0.0;
    selectPaperM = getHeight.toInt() - minusFiveHeight.toInt();

    if (getHeight > 0) {
      if (isAspectRatio) {
        // paper Height
        double height = getHeight.toDouble();
        if (getHeight > 279) getHeight = 279;
        selectHeight = height.toInt() - minusFiveHeight.toInt();
        pageHeight[pageIndex] = height.toInt() - minusFiveHeight.toInt();

        // paper Width
        double calculatedWidth = (selectHeight / percent);
        if (calculatedWidth > 203) {
          calculatedWidth = 203;
          selectWidth = 203;
          selectHeight = (calculatedWidth * percent).toInt();
        }
        // paper height
        else {
          selectWidth = calculatedWidth.toInt();
          selectHeight = selectHeight;
        }

        pageHeight[pageIndex] = selectHeight;
        pageWidth[pageIndex] = selectWidth.toInt();

        // Assign width height to controller
        paperWidthControllers[pageIndex]!.text = pageWidth[pageIndex]?.toString() ?? '203';
        paperHeightControllers[pageIndex]!.text = pageHeight[pageIndex]?.toString() ?? '279';
      } else {
        paperWidthControllers[pageIndex]!.text = LocalData.dotSharedPaperWidth.toStringAsFixed(0);
        paperHeightControllers[pageIndex]!.text = LocalData.dotSharedPaperHeight.toStringAsFixed(0);
      }
    }
    notifyListeners();
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
          _calculatedInputWidthHeight(selectField, width, height, autoCropPercent, pageIndex);
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
          if (width > 203) width = 203;
          if (widthController.text != width.toString()) {
            widthController.text = width.toString();
          }
        } else if (selectField.toUpperCase() == "HEIGHT") {
          if (height > 279) height = 279;
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
    if (width > 203) {
      width = 203;
      widthController.text = width.toString();
    } else if (height > selectPaperM) {
      height = selectPaperM;
      heightController.text = height.toString();
    }

    // // Calculate input width & height based on aspect ratio
    if (selectField.toUpperCase() == "WIDTH") {
      double inputWidth = width.toDouble();

      double calculatedHeight = inputWidth * percent;
      if (calculatedHeight > selectHeight) calculatedHeight = selectHeight.toDouble();

      heightController.text = calculatedHeight.toStringAsFixed(0);
    } else if (selectField.toUpperCase() == "HEIGHT") {
      double inputHeight = height.toDouble();

      double calculatedWidth = inputHeight / percent;
      if (calculatedWidth > selectWidth) calculatedWidth = selectWidth.toDouble();

      widthController.text = calculatedWidth.toStringAsFixed(0);
    }

    paperWidthControllers[pageIndex] = widthController;
    paperHeightControllers[pageIndex] = heightController;
  }

  /// #---------------------------- Rotation Calculated Section ----------------------------------------#
  void uiChangeRotation(BuildContext context) async {
    if (!isCropTicker) {
      rotationDegree += 90;
      if (rotationDegree == 360) {
        rotationDegree = 0;
      }
      await _setRotatedUnRotatedIntData(percent: percent, rotatedPercent: rotatedPercent);
    } else {
      DSnackBar.warning(title: "Can not rotated");
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

    final widthController = paperWidthControllers[pageIndex] ?? TextEditingController();
    final heightController = paperHeightControllers[pageIndex] ?? TextEditingController();

    String apiHeight = selectedPaperHeight.split('mm')[0];
    double getHeight = double.tryParse(apiHeight) ?? 0.0;

    if (getHeight > 0) {
      // Automatic calculated width height
      if (isAspectRatio) {
        // Rotated height
        double height = selectWidth * rotatedPercent;
        if (height > 203) height = 203;
        pageHeight[pageIndex] = height.toInt();

        // Rotated width
        double width = height / rotatedPercent;
        pageWidth[pageIndex] = width.toInt();

        paperWidthControllers[pageIndex]!.text = pageWidth[pageIndex]?.toString() ?? '203';
        paperHeightControllers[pageIndex]!.text = pageHeight[pageIndex]?.toString() ?? '279';
      }
      // Default Width Height
      else {
        heightController.text = selectHeight.toStringAsFixed(0);
        widthController.text = selectWidth.toStringAsFixed(0);
      }
      paperWidthControllers[pageIndex] = widthController;
      paperHeightControllers[pageIndex] = heightController;
    }
  }

  void rotatedUserInputWidthHeight({required String selectField, int width = 0, int height = 0}) {
    /// Apply aspect ratio automatic get width height
    if (isAspectRatio) {
      /// Single Crop input page
      if (isSingleCrop[startPage - 1]) {
        _rotatedCalculatedInputWidthHeight(selectField, width, height, rotatedPercent, startPage - 1);
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
          if (width > 203) width = 203;

          if (widthController.text != width.toString()) {
            widthController.text = width.toString();
          }
        } else if (selectField.toUpperCase() == "HEIGHT") {
          if (height > 279) height = 279;

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
      width = selectWidth;
      widthController.text = selectWidth.toString();
    } else if (height > selectHeight) {
      height = selectHeight;
      heightController.text = selectHeight.toString();
    }

    // Calculate input width & height based on aspect ratio
    if (selectField.toUpperCase() == "WIDTH") {
      double inputWidth = width.toDouble();
      double inputHeight = inputWidth / rotatedPercent;

      if (inputHeight > selectHeight) {
        inputHeight = selectHeight.toDouble();
        inputWidth = inputHeight / rotatedPercent;
      }
      //widthController.text = inputWidth.toStringAsFixed(0);
      heightController.text = inputHeight.toStringAsFixed(0);
    } else if (selectField.toUpperCase() == "HEIGHT") {
      double inputHeight = height.toDouble();
      double inputWidth = inputHeight / rotatedPercent;
      if (inputWidth > selectWidth) {
        inputWidth = selectWidth.toDouble();
        inputHeight = inputWidth * rotatedPercent;
      }
      //heightController.text = inputHeight.toStringAsFixed(0);
      widthController.text = inputWidth.toStringAsFixed(0);
    }

    paperWidthControllers[pageIndex] = widthController;
    paperHeightControllers[pageIndex] = heightController;
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

  Future<void> _saveDataToLocalStorage() async {
    await LocalData.saveLocalData<bool>('isDefaultCropDot', isDefaultCrop);
    await LocalData.saveLocalData<bool>('isAspectRatio', isAspectRatio);
    await LocalData.saveLocalData<int>('selectedPaperIndex', selectedPaperHeightIndex);
    await LocalData.saveLocalData<String>('selectedPaperHeight', selectedPaperHeight);
    if (paperWidthControllers.isNotEmpty && paperHeightControllers.isNotEmpty) {
      await LocalData.saveLocalData<double>(
        'dotSharedPaperWidth',
        double.tryParse(paperWidthControllers.values.first.text) ?? 203.0,
      );
      await LocalData.saveLocalData<double>(
        'dotSharedPaperHeight',
        double.tryParse(paperHeightControllers.values.first.text) ?? 279.0,
      );
    }
  }

  void startPrint(BuildContext context) async {
    await _createBitmapImages(context);

    await _saveDataToLocalStorage();
  }

  Future<void> _clearAllData() async {
    isLoading = true;
    isPrintLoading = false;
    startPage = 1;
    totalPages = 0;
    allPdfPage.clear();
    originalPdfPage.clear();

    percent = 0;
    rotatedPercent = 0;
    rotationDegree = 0;
    selectWidth = 103;
    selectHeight = 150;
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
  Future<void> _createBitmapImages(BuildContext context) async {
    int start = int.tryParse(pageStartController.text) ?? 1;
    int end = int.tryParse(pageEndController.text) ?? totalPages;

    double defaultWidth = 7.0936;
    double defaultHeight = 5.6693;

    String apiHeight = selectedPaperHeight.split('mm')[0];
    double getHeight = double.tryParse(apiHeight) ?? 0.0;
    double paperSize = defaultHeight * getHeight;

    // Calculate total prints = pages * copies
    int copies = int.tryParse(isPrintSetting ? pPrinterCopy.text : lPrinterCopy.text) ?? 1;
    int totalPrints = (end - start + 1) * copies;

    // Initialize printing with total count
    if (!context.mounted) return;
    context.printerSdkProvider.initPrinting(totalPrints);

    debugPrint('Start - Total prints: $totalPrints');

    try {
      for (int i = start - 1; i < end; i++) {
        // Check if cancelled
        if (!context.mounted) return;
        if (context.printerSdkProvider.isCancelled) {
          context.printerSdkProvider.completePrinting();
          return;
        }

        if (paperWidthControllers.containsKey(i) && paperHeightControllers.containsKey(i)) {
          String widthValue = paperWidthControllers[i]?.text ?? '203';
          String heightValue = paperHeightControllers[i]?.text ?? '279';
          double paperWidth = double.tryParse(widthValue) ?? 203.0;
          double paperHeight = double.tryParse(heightValue) ?? 279.0;

          // Calculate dot values and limit within maximum dimensions
          double dotWidth = (paperWidth * defaultWidth).clamp(0, 1440);
          double dotHeight = (paperHeight * defaultHeight).clamp(0, 1980);

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

          if (resizedPage != null) {
            debugPrint('Processed Page ${i + 1}: Width: $dotWidth, Height: $dotHeight');

            // Send one page at a time with await - external state management
            if (!context.mounted) return;
            await context.printerSdkProvider.dotPrintToSdk(
              imageData: resizedPage,
              paperWidth: dotWidth.toInt(),
              paperHeight: dotHeight.toInt(),
              printH: paperSize.toInt(),
            );
          } else {
            debugPrint('Error: Resized image for Page ${i + 1} is null');
          }
        } else {
          DSnackBar.warning(title: 'Page ${i + 1}: Missing width/height controllers');
        }
      }
      if (context.mounted) context.printerSdkProvider.completePrinting();
    } catch (e) {
      if (context.mounted) context.printerSdkProvider.completePrinting(error: e.toString());
      DSnackBar.warning(title: DTexts.instance.selectPrinter);
    }
  }
}
