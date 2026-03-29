import 'dart:convert';
import 'dart:isolate';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../localization/main_texts.dart';
import '../../../../utils/snackbar_toast/snack_bar.dart';
import '../../../../utils/constants/label_global_variable.dart';
import '../../../../common/crop_image_screen/image_compress.dart';
import '../../../../utils/constants/colors.dart';
import '../../../new_label/label/provider/main_label/label_printer_provider.dart';
import '../../../../data_layer/models/label_model/server_main_container_table.dart';
import '../../../../data_layer/repositories/label_print/created_label_repository.dart';
import '../../../new_label/label/view/dashboard_option/templated_container/show_widget_class/table_widget_class.dart';

class ServerTeamplatedProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoadingTeamPlated = false;
  Timer? _searchDebounce;
  LabelPrinterProvider labelModel = LabelPrinterProvider();
  List<ServerMainContainerTableModel> _dotFilteredDataList = [];
  List<ServerMainContainerTableModel> _thermalFilteredDataList = [];
  List<ServerMainContainerTableModel> get thermalFilteredDataList =>
      _thermalFilteredDataList;
  List<ServerMainContainerTableModel> get dotFilteredDataList =>
      _dotFilteredDataList;

  int _thermalSelectedCategoryIndex = 0;
  int _dotSelectedCategoryIndex = 0;
  int get selectedCategoryIndex => _thermalSelectedCategoryIndex;
  int get dotSelectedCategoryIndex => _dotSelectedCategoryIndex;

  String _selectedServerCategory = "general";
  String get selectedServerCategory => _selectedServerCategory;
  set selectedServerCategory(String value) {
    _selectedServerCategory = value;
    notifyListeners();
  }

  /// Show input Dialog
  Future<void> serverSaveInputDialog(
    BuildContext rootContext,
    ui.Image saveBitmapImage,
    int paperWidth,
    int paperHeight,
    int mainConId,
    String selectedType,
    String printType,
  ) async {
    String inputText = "";
    await showDialog(
      context: rootContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        final dTexts = DTexts.instance;
        return ContentDialog(
          title: Row(
            children: [
              Icon(FluentIcons.cloud_upload, color: DColors.primary, size: 24),
              const SizedBox(width: 10),
              Text(
                selectedType == serverDatabase
                    ? DTexts.instance.updateServerTemplate
                    : DTexts.instance.saveToCloudServer,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DTexts.instance.saveDialogInstruction,
                  style: const TextStyle(color: DColors.darkGrey, fontSize: 13),
                ),
                const SizedBox(height: 20),

                // Dropdown for Category Selection
                InfoLabel(
                  label: DTexts.instance.templateCategory,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: DColors.grey.withValues(alpha: 0.5),
                      ),
                    ),
                    child: ComboBox<String>(
                      value: _selectedServerCategory,
                      isExpanded: true,
                      placeholder: Text(DTexts.instance.selectCategory),
                      items: server.map((category) {
                        IconData categoryIcon;
                        switch (category.toLowerCase()) {
                          case 'retail':
                            categoryIcon = FluentIcons.shopping_cart;
                            break;
                          case 'home':
                            categoryIcon = FluentIcons.home;
                            break;
                          case 'office':
                            categoryIcon = FluentIcons.business_card;
                            break;
                          case 'communication':
                            categoryIcon = FluentIcons.chat;
                            break;
                          default:
                            categoryIcon = FluentIcons.folder_open;
                        }
                        return ComboBoxItem<String>(
                          value: category,
                          child: Row(
                            children: [
                              Icon(
                                categoryIcon,
                                size: 16,
                                color: DColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Text(_getLocalizedCategory(category, dTexts)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _selectedServerCategory = value;
                          (dialogContext as Element).markNeedsBuild();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Text Field For Container Name
                InfoLabel(
                  label: DTexts.instance.containerName,
                  child: TextBox(
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        FluentIcons.rename,
                        size: 16,
                        color: DColors.darkGrey,
                      ),
                    ),
                    placeholder: DTexts.instance.containerNameExample,
                    textAlign: TextAlign.start,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    onChanged: (text) => inputText = text,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                selectedType == serverDatabase
                    ? Button(
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          await serverUpdateContainerData(
                            rootContext,
                            mainConId,
                            saveBitmapImage,
                          );
                          await fetchData(printerType: printType);
                        },
                        child: Text(DTexts.instance.update),
                      )
                    : Button(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(DTexts.instance.cancel),
                      ),
                Button(
                  onPressed: () {
                    if (inputText.isNotEmpty) {
                      Navigator.pop(dialogContext);
                      serverSaveContainerData(
                        rootContext: rootContext,
                        saveBitmapImage: saveBitmapImage,
                        containerName: inputText.trim(),
                        paperWidth: paperWidth,
                        paperHeight: paperHeight,
                        printerType: printType,
                      );
                      fetchData(printerType: printType);
                    } else {
                      DSnackBar.informationSnackBar(
                        title: DTexts.instance.pleaseSelectContainerName,
                      );
                    }
                  },
                  child: Text(
                    selectedType == serverDatabase
                        ? DTexts.instance.saveAs
                        : DTexts.instance.saveOnServer,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Save server data on main container and widget container
  Future<void> serverSaveContainerData({
    required BuildContext rootContext,
    required ui.Image saveBitmapImage,
    required int paperWidth,
    required int paperHeight,
    required String containerName,
    required String printerType,
  }) async {
    try {
      if (containerName.trim().isEmpty) return;

      if (containerName.isEmpty) {
        DSnackBar.informationSnackBar(title: "Please select containerName");
        return;
      }

      showDialog(
        context: rootContext,
        barrierDismissible: false,
        builder: (context) {
          return ContentDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ProgressRing(),
                const SizedBox(width: 20),
                Text(DTexts.instance.saving),
              ],
            ),
          );
        },
      );

      Uint8List? saveBitmapImageData = await labelModel.convertImageToData(
        saveBitmapImage,
      );

      Uint8List? compressedBitmapData = await compressImageIfNeeded(
        saveBitmapImageData!,
      );

      int? mainContainerId = await CreatedLabelRepository()
          .serverInsertMainContainer(
            containerName: containerName,
            containerWidth: paperWidth,
            containerHeight: paperHeight,
            saveBitmapImageData: compressedBitmapData,
            subCategories: _selectedServerCategory,
            printerType: selectPrinter,
          );

      if (mainContainerId == null || mainContainerId <= 0) {
        debugPrint("Error Server creating main container!");
        if (rootContext.mounted) Navigator.pop(rootContext);
        return;
      }

      bool success = await CreatedLabelRepository().serverInsertWidgetContainer(
        mainContainerId,
      );

      if (rootContext.mounted) Navigator.pop(rootContext);

      if (!success) {
        DSnackBar.warning(title: DTexts.instance.dataDoesNotSave);
        debugPrint("Error inserting into WidgetContainerTable");
        return;
      }

      DSnackBar.success(title: DTexts.instance.dataSavedSuccessfully);
    } catch (e) {
      if (rootContext.mounted) Navigator.pop(rootContext);
      debugPrint("Error saving container data: $e");
    }
  }

  /// Update Data
  Future<void> serverUpdateContainerData(
    BuildContext rootContext,
    int existingContainerId,
    ui.Image saveBitmapImage,
  ) async {
    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (context) {
        return ContentDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ProgressRing(),
              const SizedBox(width: 20),
              Text(DTexts.instance.updating),
            ],
          ),
        );
      },
    );

    Uint8List? saveBitmapImageData = await labelModel.convertImageToData(
      saveBitmapImage,
    );
    try {
      if (saveBitmapImageData != null) {
        Uint8List? compressedBitmapData = await compressImageIfNeeded(
          saveBitmapImageData,
        );

        List<ServerMainContainerTableModel>? existingContainers =
            await CreatedLabelRepository().getMainContainerById(
              existingContainerId,
            );

        ServerMainContainerTableModel? existingContainer =
            existingContainers!.first;

        ServerMainContainerTableModel containerToUpdate =
            ServerMainContainerTableModel(
              id: existingContainer.id?.toInt(),
              containerName: existingContainer.containerName,
              containerWidth: mainPaperWidth,
              containerHeight: mainPaperHeight,
              responsiveWidth: selectWidthD,
              responsiveHeight: selectHeightD,
              containerImageBitmapData: compressedBitmapData,
              subCategories: existingContainer.subCategories,
              printerType: existingContainer.printerType,
            );

        await CreatedLabelRepository().serverUpdateMainContainer(
          containerToUpdate,
        );

        await CreatedLabelRepository().serverDeleteWidgetContainerItem(
          existingContainerId,
        );

        bool success = await CreatedLabelRepository()
            .serverInsertWidgetContainer(existingContainerId);

        if (rootContext.mounted) Navigator.pop(rootContext);

        success
            ? DSnackBar.success(title: DTexts.instance.dataUpdateSuccessfully)
            : DSnackBar.warning(title: 'Error updating data!');
        notifyListeners();
      } else {
        if (rootContext.mounted) Navigator.pop(rootContext);
        debugPrint(
          "Error: Main container with ID $existingContainerId not found",
        );
      }
    } catch (e) {
      if (rootContext.mounted) Navigator.pop(rootContext);
      debugPrint("Error updating container data: $e");
      DSnackBar.warning(title: "Error updating container data: $e");
    }
  }

  /// Delete Data
  Future<void> serverDeleteContainer(
    BuildContext context,
    int containerId,
  ) async {
    bool isSuccess = await CreatedLabelRepository()
        .serverDeleteMainContainerItem(containerId);
    if (isSuccess) {
      DSnackBar.success(title: "Successfully Delete item");
      _thermalFilteredDataList.removeWhere(
        (container) => container.id == containerId,
      );
      _dotFilteredDataList.removeWhere(
        (container) => container.id == containerId,
      );
      notifyListeners();
    } else {
      DSnackBar.informationSnackBar(title: "Item does not delete");
    }
  }

  /// Retrieve local data for local templated
  List<String> server = [
    "general",
    "retail",
    "home",
    "office",
    "communication",
  ];

  String _getLocalizedCategory(String category, DTexts dTexts) {
    switch (category.toLowerCase()) {
      case 'all':
        return dTexts.all;
      case 'general':
        return dTexts.general;
      case 'retail':
        return dTexts.retail;
      case 'home':
        return dTexts.home;
      case 'office':
        return dTexts.office;
      case 'communication':
        return dTexts.communication;
      default:
        return category;
    }
  }

  Future<void> updateSelectedIndex({
    required int index,
    required String printerType,
  }) async {
    if (printerType == "Thermal") {
      _thermalSelectedCategoryIndex = index;
    } else {
      _dotSelectedCategoryIndex = index;
    }
    notifyListeners();

    if (index == 0) {
      await fetchData(printerType: printerType);
    } else {
      await fetchData(printerType: printerType, subCategory: server[index - 1]);
    }
  }

  Future<void> fetchData({
    required String printerType,
    String? subCategory,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final fetchedData = await CreatedLabelRepository().getMainContainer(
        printerType: printerType,
        subCategories: subCategory,
      );
      if (fetchedData != null) {
        if (printerType == "Thermal") {
          _thermalFilteredDataList = List.from(fetchedData);
        } else if (printerType == "Dot") {
          _dotFilteredDataList = List.from(fetchedData);
        }
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchLabels({
    required String printerType,
    required String query,
  }) async {
    _searchDebounce?.cancel();

    if (query.isEmpty) {
      isLoading = true;
      if (printerType == "Thermal") {
        _thermalFilteredDataList.clear();
      } else {
        _dotFilteredDataList.clear();
      }
      notifyListeners();

      if (printerType == "Thermal") {
        await updateSelectedIndex(
          index: _thermalSelectedCategoryIndex,
          printerType: printerType,
        );
      } else {
        await updateSelectedIndex(
          index: _dotSelectedCategoryIndex,
          printerType: printerType,
        );
      }
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        isLoading = true;
        notifyListeners();

        final searchResults = await CreatedLabelRepository()
            .searchMainContainer(printerType: printerType, query: query);

        if (searchResults != null) {
          if (printerType == "Thermal") {
            _thermalFilteredDataList = List.from(searchResults);
          } else if (printerType == "Dot") {
            _dotFilteredDataList = List.from(searchResults);
          }
        }
      } catch (e) {
        debugPrint("Error searching labels: $e");
        if (printerType == "Thermal") {
          _thermalFilteredDataList = [];
        } else {
          _dotFilteredDataList = [];
        }
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  TextAlign _stringToTextAlign(String alignment) {
    switch (alignment) {
      case 'TextAlign.left':
        return TextAlign.left;
      case 'TextAlign.center':
        return TextAlign.center;
      case 'TextAlign.right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }

  Future<List<List<GridCell>>> convertCellsWithRatio({
    required List<List<dynamic>> rawCells,
    required double ratioWidth,
  }) async {
    List<List<GridCell>> adjustedCells = [];

    for (var row in rawCells) {
      List<GridCell> adjustedRow = [];

      for (var jsonCell in row) {
        try {
          GridCell cell = GridCell.fromJson(jsonCell);

          adjustedRow.add(cell.copyWith(fontSize: cell.fontSize * ratioWidth));
        } catch (e) {
          debugPrint("❌ Error decoding GridCell: $e");
          adjustedRow.add(GridCell.defaultCell());
        }
      }

      adjustedCells.add(adjustedRow);
    }

    return adjustedCells;
  }

  Future<void> retrieveAllWidgetContainers(
    int mainContainerId,
    double serverGetWidth,
    double serverGetHeight,
  ) async {
    try {
      isLoadingTeamPlated = true;
      notifyListeners();

      List<dynamic> widgetContainers =
          await CreatedLabelRepository().getWidgetContainers(mainContainerId) ??
          [];

      if (widgetContainers.isEmpty) {
        debugPrint("No widget found");
        isLoadingTeamPlated = false;
        notifyListeners();
        return;
      }

      final double ratioWidth = selectWidthD / serverGetWidth;
      final double ratioHeight = selectHeightD / serverGetHeight;

      final parsedWidgets = await parseWidgetDataInIsolate({
        'widgetContainers': widgetContainers.map((e) => e.toMap()).toList(),
        'serverGetWidth': serverGetWidth,
        'serverGetHeight': serverGetHeight,
        'selectWidthD': selectWidthD,
        'selectHeightD': selectHeightD,
      });

      for (var widget in parsedWidgets) {
        final rawTablesRowHeights = widget.extra['tablesRowHeights'];
        final rawTablesColumnWidths = widget.extra['tablesColumnWidths'];

        final getTablesRowHeights = (rawTablesRowHeights != null)
            ? (jsonDecode(rawTablesRowHeights) as List)
                  .map<List<double>>(
                    (innerList) => (innerList as List)
                        .map<double>(
                          (value) => (value as num).toDouble() * ratioHeight,
                        )
                        .toList(),
                  )
                  .toList()
            : [];

        final getTablesColumnWidths = (rawTablesColumnWidths != null)
            ? (jsonDecode(rawTablesColumnWidths) as List)
                  .map<List<double>>(
                    (innerList) => (innerList as List)
                        .map<double>(
                          (value) => (value as num).toDouble() * ratioWidth,
                        )
                        .toList(),
                  )
                  .toList()
            : [];

        switch (widget.widgetType) {
          case 'Text':
            showTextEditingWidget = true;
            textCodes.add(widget.content);
            textCodeOffsets.add(widget.offset);
            selectedTextIndex = textCodes.length - 1;
            textFocusNodes.add(FocusNode());
            textControllers.add(TextEditingController());
            updateTextBold.add(widget.extra['isBold'] == 1);
            updateTextItalic.add(widget.extra['isItalic'] == 1);
            updateTextUnderline.add(widget.extra['isUnderline'] == 1);
            updateTextStrikeThrough.add(false);
            alignLeft.add(true);
            alignCenter.add(false);
            alignRight.add(false);
            alignStraight.add(false);
            updateTextAlignment.add(
              _stringToTextAlign(widget.extra['textAlignment']),
            );
            updateTextFontSize.add(widget.fontSize);
            textContainerRotations.add(widget.extra['rotation'] ?? 0.0);
            updateTextWidthSize.add(widget.width);
            updateTextHeightSize.add(widget.height);
            textSelectedFontFamily.add(
              widget.extra['fontFamily'] ?? "chinese_msyh",
            );

            /*checkTextIdentifyWidget.add(widget.extra['checkTextIdentifyWidget']);
            prefixNumber.add(widget.extra['prefix'] ?? "");
            suffixNumber.add(widget.extra['suffix'] ?? "");
            incrementNumber.add(1);
            endPageNumber.add(5);
            prefixController.add(TextEditingController());
            suffixController.add(TextEditingController());
            incrementController.add(TextEditingController());
            endPageController.add(TextEditingController());*/

            isTextLock.add(false);
            break;

          case 'Barcode':
            showBarcodeWidget = true;
            barCodes.add(widget.content);
            barCodeOffsets.add(widget.offset);
            selectedBarCodeIndex = barCodes.length - 1;
            updateBarcodeWidth.add(widget.width);
            updateBarcodeHeight.add(widget.height);
            barCodesContainerRotations.add(widget.extra['rotation'] ?? 0.0);
            barTextFontSize.add(widget.fontSize);
            barEncodingType.add(widget.extra['barEncodingType'] ?? 'code128');
            barTextBold.add(widget.extra['isBold'] == 1);
            barTextItalic.add(widget.extra['isItalic'] == 1);
            barTextUnderline.add(widget.extra['isUnderline'] == 1);
            drawText.add(widget.extra['isRectangale'] == 1);
            isBarcodeLock.add(false);

            barTextStrikeThrough.add(false);
            brFocusNodes.add(FocusNode());
            brFocusNodes[selectedBarCodeIndex].requestFocus();
            barcodeControllers.add(TextEditingController());
            prefixController.add(TextEditingController());
            inputController.add(TextEditingController(text: "1"));
            suffixController.add(TextEditingController());
            incrementController.add(TextEditingController(text: "1"));
            endPageController.add(TextEditingController(text: "5"));
            break;

          case 'Qrcode':
            showQrcodeWidget = true;
            qrCodes.add(widget.content);
            qrCodeOffsets.add(widget.offset);
            updateQrcodeSize.add(widget.width);
            qrFocusNodes.add(FocusNode());
            qrcodeControllers.add(TextEditingController());
            selectedQRCodeIndex = qrCodes.length - 1;
            isQrcodeLock.add(false);
            break;

          case 'Table':
            showTableWidget = true;
            tableCodes.add(widget.content);
            tableOffsets.add(widget.offset);
            tableContainerRotations.add(widget.extra['rotation'] ?? 0.0);
            final int safeRowCount = (widget.extra['rowCount'] is int)
                ? widget.extra['rowCount']
                : 0;
            final int safeColumnCount = (widget.extra['columnCount'] is int)
                ? widget.extra['columnCount']
                : 0;
            rowCount.add(safeRowCount);
            columnCount.add(safeColumnCount);
            try {
              final rawJson = widget.extra['tablesCells'];
              if (rawJson != null && rawJson is String && rawJson.isNotEmpty) {
                final rawCellsDecoded = jsonDecode(rawJson);
                if (rawCellsDecoded is List && rawCellsDecoded.isNotEmpty) {
                  final rawCells = rawCellsDecoded
                      .map((row) => (row as List).map((cell) => cell).toList())
                      .toList();

                  final adjustedCells = await convertCellsWithRatio(
                    rawCells: rawCells,
                    ratioWidth: ratioWidth,
                  );

                  // Fallback check if decoding gives invalid data
                  if (adjustedCells.isNotEmpty &&
                      adjustedCells.first.isNotEmpty) {
                    tablesCells.addAll(adjustedCells);
                  } else {
                    tablesCells.add([]);
                    debugPrint(
                      "⚠️ adjustedCells is empty or invalid structure",
                    );
                  }
                } else {
                  tablesCells.add([]);
                  debugPrint("⚠️ rawCellsDecoded is empty or not a list");
                }
              } else {
                tablesCells.add([]);
                debugPrint(
                  "⚠️ tablesCells string is null/empty or not a string",
                );
              }
            } catch (e, s) {
              debugPrint("❌ Error parsing tablesCells: $e\n$s");
              tablesCells.add([]);
            }
            tableTextFocusNodes.add(FocusNode());
            textController.add(TextEditingController());
            tablesRowHeights.add(
              (getTablesRowHeights.isNotEmpty
                  ? getTablesRowHeights.first
                  : [50.0, 50.0, 50.0]),
            );
            tablesColumnWidths.add(
              (getTablesColumnWidths.isNotEmpty
                  ? getTablesColumnWidths.first
                  : [100.0, 100.0, 100.0]),
            );
            tableLineWidth.add(widget.extra['widgetLineWidth'] ?? 2.0);
            tablesSelectedCells.add([]);
            textController.add(TextEditingController());
            tableBorderStyle.add(widget.extra['isRoundRectangle'] == 1);
            isTableLock.add(false);
            break;

          case 'Image':
            showImageWidget = true;
            imageCodes.add(widget.extra['selectedEmojiIcons']);
            imageOffsets.add(widget.offset);
            updateImageSize.add(widget.width);
            imageCodesContainerRotations.add(widget.extra['rotation'] ?? 0.0);
            isImageLock.add(false);
            break;

          case 'Emoji':
            showEmojiWidget = true;
            emojiCodes.add(widget.content);
            emojiCodeOffsets.add(widget.offset);
            selectedEmojis.add(widget.extra['selectedEmojiIcons']);
            emojiCodesContainerRotations.add(widget.extra['rotation'] ?? 0.0);
            updatedEmojiWidth.add(widget.width);
            isEmojiLock.add(false);
            break;

          case 'Shape':
            showShapeWidget = true;
            shapeCodes.add(widget.content);
            shapeOffsets.add(widget.offset);
            shapeTypes.add(widget.extra['shapeType'] ?? "Square");
            isSquareUpdate.add(widget.extra['isRectangle'] == 1);
            isRoundSquareUpdate.add(widget.extra['isRoundRectangle'] == 1);
            isCircularUpdate.add(widget.extra['isCircularFixed'] == 1);
            isOvalCircularUpdate.add(widget.extra['isCircularNotFixed'] == 1);
            isFixedFigureSize.add(widget.extra['isFixedFigureSize'] == 1);
            updateShapeLineWidthSize.add(
              widget.extra['widgetLineWidth'] ?? 1.0,
            );
            updateShapeWidth.add(widget.width);
            updateShapeHeight.add(widget.height);
            trueShapeWidth.add(widget.extra['trueShapeWidth'] ?? widget.width);
            trueShapeHeight.add(
              widget.extra['trueShapeHeight'] ?? widget.height,
            );
            shapeCodesContainerRotations.add(widget.extra['rotation'] ?? 0.0);
            isShapeLock.add(false);
            break;

          case 'Line':
            showLineWidget = true;
            lineCodes.add(widget.content);
            lineOffsets.add(widget.offset);
            isDottedLineUpdate.add(widget.extra['isRoundRectangle'] == 1);
            updateSliderLineWidth.add(widget.fontSize);
            lineCodesContainerRotations.add(widget.extra['rotation'] ?? 0.0);
            updateLineWidth.add(widget.width);
            isLineLock.add(false);
            break;

          case 'Background Image':
            if (widget.extra['selectedEmojiIcons'] != null) {
              showBackgroundImageWidget = true;
              selectedImage = widget.extra['selectedEmojiIcons'];
            }
            break;

          case 'Local Background Image':
            if (widget.extra['selectedEmojiIcons'] != null) {
              showBackgroundImageWidget = true;
              backgroundImage = widget.extra['selectedEmojiIcons'];
            }
            break;
        }
      }

      isLoadingTeamPlated = false;
      notifyListeners();
    } catch (e, st) {
      isLoadingTeamPlated = false;
      notifyListeners();
      debugPrint("Error getting data: $e\n$st");
    }
  }
}

class ParsedWidgetData {
  final String widgetType;
  final dynamic content;
  final Offset offset;
  final double width;
  final double height;
  final double fontSize;
  final Map<String, dynamic> extra;

  ParsedWidgetData({
    required this.widgetType,
    required this.content,
    required this.offset,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.extra,
  });

  factory ParsedWidgetData.fromMap(Map<String, dynamic> map) {
    return ParsedWidgetData(
      widgetType: map['widgetType'],
      content: map['content'],
      offset: Offset(map['offsetX'], map['offsetY']),
      width: map['width'],
      height: map['height'],
      fontSize: map['fontSize'],
      extra: Map<String, dynamic>.from(map['extra']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'widgetType': widgetType,
      'content': content,
      'offsetX': offset.dx,
      'offsetY': offset.dy,
      'width': width,
      'height': height,
      'fontSize': fontSize,
      'extra': extra,
    };
  }
}

void _parseWidgetDataIsolate(Map<String, dynamic> message) {
  final SendPort sendPort = message['sendPort'];
  final Map<String, dynamic> params = message['params'];

  final List<dynamic> widgetContainers = params['widgetContainers'] ?? [];
  final double serverGetWidth =
      (params['serverGetWidth'] as num?)?.toDouble() ?? 1.0;
  final double serverGetHeight =
      (params['serverGetHeight'] as num?)?.toDouble() ?? 1.0;
  final double selectWidthD =
      (params['selectWidthD'] as num?)?.toDouble() ?? 1.0;
  final double selectHeightD =
      (params['selectHeightD'] as num?)?.toDouble() ?? 1.0;

  final double ratioWidth = selectWidthD / serverGetWidth;
  final double ratioHeight = selectHeightD / serverGetHeight;

  List<Map<String, dynamic>> parsedList = [];

  for (var raw in widgetContainers) {
    final data = raw as Map<String, dynamic>;

    final double dx =
        ratioWidth * ((data['offsetDx'] as num?)?.toDouble() ?? 0);
    final double dy =
        ratioHeight * ((data['offsetDy'] as num?)?.toDouble() ?? 0);
    final double width =
        ratioWidth * ((data['width'] as num?)?.toDouble() ?? 0);
    final double height =
        ratioHeight * ((data['height'] as num?)?.toDouble() ?? 30);
    final double fontSize =
        ratioWidth * ((data['fontSize'] as num?)?.toDouble() ?? 14);

    final double trueShapeWidth =
        ratioWidth * ((data['trueShapeWidth'] as num?)?.toDouble() ?? width);
    final double trueShapeHeight =
        ratioHeight * ((data['trueShapeHeight'] as num?)?.toDouble() ?? height);

    parsedList.add({
      'widgetType': data['widgetType'] ?? '',
      'content': data['contentData'],
      'offsetX': dx,
      'offsetY': dy,
      'width': width,
      'height': height,
      'fontSize': fontSize,
      'extra': {
        'rotation': (data['rotation'] as num?)?.toDouble() ?? 0,
        'fontFamily': data['fontFamily'] ?? '',
        'textAlignment': data['textAlignment'] ?? 'TextAlign.left',
        'isBold': data['isBold'] ?? false,
        'isItalic': data['isItalic'] ?? false,
        'isUnderline': data['isUnderline'] ?? false,
        'shapeType': data['shapeType'],
        'isRectangle': data['isRectangale'] ?? false,
        'isRoundRectangle': data['isRoundRectangale'] ?? false,
        'isCircularFixed': data['isCircularFixed'] ?? false,
        'isCircularNotFixed': data['isCircularNotFixed'] ?? false,
        'isFixedFigureSize': data['isFixedFigureSize'] ?? false,
        'widgetLineWidth': (data['widgetLineWidth'] as num?)?.toDouble(),
        'trueShapeWidth': trueShapeWidth,
        'trueShapeHeight': trueShapeHeight,
        'selectedEmojiIcons': data['selectedEmojiIcons'],
        'checkTextIdentifyWidget': data['checkTextIdentifyWidget'],
        'prefix': data['prefix'],
        'suffix': data['suffix'],
        'rowCount': data['rowCount'],
        'columnCount': data['columnCount'],
        'tablesCells': data['tablesCells'],
        'tablesRowHeights': data['tablesRowHeights'],
        'tablesColumnWidths': data['tablesColumnWidths'],
      },
    });
  }

  sendPort.send(parsedList);
}

Future<List<ParsedWidgetData>> parseWidgetDataInIsolate(
  Map<String, dynamic> params,
) async {
  final ReceivePort receivePort = ReceivePort();

  await Isolate.spawn(_parseWidgetDataIsolate, {
    'sendPort': receivePort.sendPort,
    'params': params,
  });

  final List<Map<String, dynamic>> parsedList = await receivePort.first;

  return parsedList.map((e) => ParsedWidgetData.fromMap(e)).toList();
}
