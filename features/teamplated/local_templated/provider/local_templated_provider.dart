import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../utils/snackbar_toast/snack_bar.dart';
import '../../../../utils/constants/label_global_variable.dart';
import 'package:grozziie/localization/main_texts.dart';
import '../../../../data_layer/local_server/insert_local_data_class.dart';
import '../../../../data_layer/local_server/templated_database_helper.dart';
import '../../../new_label/label/provider/main_label/label_printer_provider.dart';
import '../../../../data_layer/local_server/models/local_widget_container_model.dart';
import '../../../../data_layer/local_server/models/local_main_widget_container_model.dart';
import '../../../new_label/label/view/dashboard_option/templated_container/show_widget_class/table_widget_class.dart';

class LocalTeamplatedProvider extends ChangeNotifier {
  String? inputText;
  List<MainContainerModelClass> containers = [];
  LabelPrinterProvider labelModel = LabelPrinterProvider();

  /// Show input Dialog
  Future<void> localSaveInputDialog(
    BuildContext rootContext,
    ui.Image saveBitmapImage,
    int paperWidth,
    int paperHeight,
    int mainConId,
    String selectedType,
    String printType,
  ) async {
    await showDialog(
      context: rootContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        return ContentDialog(
          content: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 60,
              child: TextBox(
                textAlign: TextAlign.center,
                autofocus: true,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                onChanged: (text) => inputText = text,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  selectedType == localDatabase
                      ? Button(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await localUpdateContainerData(
                              rootContext,
                              mainConId,
                              saveBitmapImage,
                            );
                            await loadData(printerType: printType);
                          },
                          child: Text(DTexts.instance.update),
                        )
                      : Button(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(DTexts.instance.cancel),
                        ),
                  Button(
                    onPressed: () async {
                      Navigator.pop(dialogContext);

                      await localSaveContainerData(
                        rootContext: rootContext,
                        saveBitmapImage: saveBitmapImage,
                        containerName: inputText!.trim(),
                        paperWidth: paperWidth,
                        paperHeight: paperHeight,
                        printerType: printType,
                      );
                      await loadData(printerType: printType);
                    },
                    child: Text(DTexts.instance.saveLocal),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Save local data on main container and widget container
  Future<void> localSaveContainerData({
    required BuildContext rootContext,
    required ui.Image saveBitmapImage,
    required int paperWidth,
    required int paperHeight,
    required String containerName,
    required String printerType,
  }) async {
    try {
      if (containerName.trim().isEmpty) {
        return;
      }

      bool exists = await TemplateDatabaseHelper.doesContainerNameExist(
        containerName,
      );

      if (exists) {
        DSnackBar.warning(title: DTexts.instance.containerNameAlreadyExists);
        return;
      }

      Uint8List? saveBitmapImageData = await labelModel.convertImageToData(
        saveBitmapImage,
      );

      int? mainContainerId = await LocalDataBaseSave.insertMainContainer(
        containerName,
        paperWidth,
        paperHeight,
        saveBitmapImageData,
        printerType,
      );

      if (mainContainerId <= 0) {
        debugPrint("Error inserting into MainContainerTable");
        return;
      }

      bool success = await LocalDataBaseSave.insertWidgetContainer(
        mainContainerId,
      );

      if (!success) {
        DSnackBar.warning(title: DTexts.instance.dataDoesNotSave);
        debugPrint("Error inserting into WidgetContainerTable");
        return;
      }

      DSnackBar.success(title: DTexts.instance.dataSavedSuccessfully);
    } catch (e) {
      debugPrint("Error saving container data: $e");
    }
  }

  /// Update Data
  Future<void> localUpdateContainerData(
    BuildContext rootContext,
    int existingContainerId,
    ui.Image saveBitmapImage,
  ) async {
    Uint8List? saveBitmapImageData = await labelModel.convertImageToData(
      saveBitmapImage,
    );
    try {
      if (saveBitmapImageData != null) {
        MainContainerModelClass? existingContainer =
            await LocalDataBaseSave.getMainContainerById(existingContainerId);

        if (existingContainer != null) {
          MainContainerModelClass containerToUpdate = MainContainerModelClass(
            id: existingContainer.id,
            containerName: existingContainer.containerName,
            containerWidth: existingContainer.containerWidth,
            containerHeight: existingContainer.containerHeight,
            containerImageBitmapData: saveBitmapImageData,
            printerType: existingContainer.printerType,
          );
          await LocalDataBaseSave.updateMainContainer(containerToUpdate);
        } else {
          debugPrint(
            "Error: Main container with ID $existingContainerId not found",
          );
        }
      }
      List<WidgetContainerModelClass> widgetsToUpdate =
          await LocalDataBaseSave.retrieveAllWidgetContainers(
            existingContainerId,
          );

      for (var widget in widgetsToUpdate) {
        await LocalDataBaseSave.deleteWidgetContainer(widget.id ?? 0);
        debugPrint(' Previous Data Delete successfully: ${widget.id ?? 0}');
      }

      bool success = await LocalDataBaseSave.insertWidgetContainer(
        existingContainerId,
      );

      success
          ? DSnackBar.success(title: DTexts.instance.dataUpdateSuccessfully)
          : DSnackBar.warning(title: 'Error updating data!');
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating container data: $e");
      DSnackBar.warning(title: "Error updating container data: $e");
    }
  }

  /// Delete Data
  Future<void> deleteContainer(BuildContext context, int containerId) async {
    try {
      await LocalDataBaseSave.deleteMainContainer(containerId);

      // Remove the container from the local list
      containers.removeWhere((container) => container.id == containerId);

      DSnackBar.success(title: DTexts.instance.templatedDeleteSuccessfully);

      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting container: $e");
      DSnackBar.warning(title: "Error deleting container");
    }
  }

  /// Retrieve local data for local templated
  Future<void> loadData({required String printerType}) async {
    try {
      List<MainContainerModelClass> data =
          await LocalDataBaseSave.retrieveAllMainContainers();
      if (data.isNotEmpty) {
        var filteredData = data
            .where((item) => item.printerType == printerType)
            .toList();
        containers = filteredData;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error retrieving containers: $e');
    }
  }

  /// Retrieve local data for dashboard template
  Future<void> retrieveLocalAllWidgetContainers(int mainContainerId) async {
    try {
      final containerId = mainContainerId;

      List<WidgetContainerModelClass> widgetContainers =
          await LocalDataBaseSave.retrieveAllWidgetContainers(containerId);

      if (widgetContainers.isNotEmpty) {
        for (var widgetData in widgetContainers) {
          final getAddData = widgetData.contentData;
          final getOffset = Offset(widgetData.offsetDx, widgetData.offsetDy);
          final getRotation = widgetData.rotation ?? 0;
          final getWidgetWidth = widgetData.width;
          final getWidgetHeight = widgetData.height ?? 0;

          TextAlign stringToTextAlign(String alignment) {
            switch (alignment) {
              case 'left':
                return TextAlign.left;
              case 'center':
                return TextAlign.center;
              case 'right':
                return TextAlign.right;
              default:
                return TextAlign.left;
            }
          }

          switch (widgetData.widgetType) {
            case 'Text':
              showTextEditingWidget = true;
              textCodes.add(getAddData);
              textCodeOffsets.add(getOffset);
              selectedTextIndex = textCodes.length - 1;
              updateTextBold.add(bool.parse(widgetData.isBold.toString()));
              updateTextItalic.add(bool.parse(widgetData.isItalic.toString()));
              updateTextUnderline.add(
                bool.parse(widgetData.isUnderline.toString()),
              );
              updateTextAlignment.add(
                stringToTextAlign(widgetData.textAlignment ?? 'left'),
              );
              updateTextFontSize.add(widgetData.fontSize!);
              textContainerRotations.add(getRotation);
              updateTextStrikeThrough.add(
                bool.parse(widgetData.isTextStrikeThrough.toString()),
              );
              textSelectedFontFamily.add(widgetData.fontFamily ?? 'Roboto');
              updateTextWidthSize.add(getWidgetWidth);
              updateTextHeightSize.add(getWidgetHeight);
              textFocusNodes.add(FocusNode());
              textFocusNodes[selectedTextIndex].requestFocus();
              textControllers.add(TextEditingController());
              alignLeft.add(true);
              alignCenter.add(false);
              alignRight.add(false);
              alignStraight.add(false);
              isTextLock.add(false);
              break;

            case 'Barcode':
              showBarcodeWidget = true;
              barCodes.add(getAddData);
              barCodeOffsets.add(getOffset);
              selectedBarCodeIndex = barCodes.length - 1;
              updateBarcodeWidth.add(getWidgetWidth);
              updateBarcodeHeight.add(getWidgetHeight);
              barCodesContainerRotations.add(getRotation);
              barTextFontSize.add(widgetData.fontSize!);
              barEncodingType.add(widgetData.barEncodingType!);
              barTextBold.add(bool.parse(widgetData.isBold.toString()));
              barTextItalic.add(bool.parse(widgetData.isItalic.toString()));
              barTextUnderline.add(
                bool.parse(widgetData.isUnderline.toString()),
              );
              barTextStrikeThrough.add(
                bool.parse(widgetData.isTextStrikeThrough.toString()),
              );
              drawText.add(bool.parse(widgetData.isRectangale.toString()));
              brFocusNodes.add(FocusNode());
              brFocusNodes[selectedBarCodeIndex].requestFocus();
              barcodeControllers.add(TextEditingController());
              prefixController.add(TextEditingController());
              inputController.add(TextEditingController(text: "1"));
              suffixController.add(TextEditingController());
              incrementController.add(TextEditingController(text: "1"));
              endPageController.add(TextEditingController(text: "5"));
              isBarcodeLock.add(false);
              break;

            case 'Qrcode':
              showQrcodeWidget = true;
              qrCodes.add(getAddData);
              qrCodeOffsets.add(getOffset);
              updateQrcodeSize.add(getWidgetWidth);
              qrFocusNodes.add(FocusNode());
              qrcodeControllers.add(TextEditingController());
              selectedQRCodeIndex = qrCodes.length - 1;
              isQrcodeLock.add(false);
              break;

            case 'Table':
              showTableWidget = true;
              tableCodes.add(getAddData);
              tableOffsets.add(getOffset);
              tableContainerRotations.add(widgetData.rotation ?? 0.0);
              rowCount.add(widgetData.rowCount!);
              columnCount.add(widgetData.columnCount!);
              tablesCells.addAll(
                widgetData.tablesCells as List<List<GridCell>>,
              );
              tablesRowHeights.add(
                widgetData.tablesRowHeights?.first ?? [50.0, 50.0, 50.0],
              );
              tablesColumnWidths.add(
                widgetData.tablesColumnWidths?.first ?? [100.0, 100.0, 100.0],
              );
              tableLineWidth.add(widgetData.widgetLineWidth ?? 2.0);
              tablesSelectedCells.add([]);
              tableTextFocusNodes.add(FocusNode());
              textController.add(TextEditingController());
              tableBorderStyle.add(widgetData.isRoundRectangale ?? false);
              isTableLock.add(false);
              break;

            case 'Image':
              showImageWidget = true;
              imageCodes.add(widgetData.selectedEmojiIcons ?? Uint8List(0));
              imageOffsets.add(getOffset);
              updateImageSize.add(getWidgetWidth);
              imageCodesContainerRotations.add(getRotation);
              isImageLock.add(false);
              break;

            case 'Emoji':
              showEmojiWidget = true;
              emojiCodes.add(getAddData);
              emojiCodeOffsets.add(getOffset);
              emojiCodesContainerRotations.add(getRotation);
              updatedEmojiWidth.add(getWidgetWidth);
              selectedEmojis.add(widgetData.selectedEmojiIcons);
              isEmojiLock.add(false);
              break;

            case 'Shape':
              showShapeWidget = true;
              shapeCodes.add(getAddData);
              shapeOffsets.add(getOffset);
              shapeCodesContainerRotations.add(getRotation);
              updateShapeWidth.add(getWidgetWidth);
              updateShapeHeight.add(getWidgetHeight);
              shapeTypes.add(widgetData.shapeTypes ?? 'Square');
              isSquareUpdate.add(
                bool.parse(widgetData.isRectangale.toString()),
              );
              isRoundSquareUpdate.add(
                bool.parse(widgetData.isRoundRectangale.toString()),
              );
              isCircularUpdate.add(
                bool.parse(widgetData.isCircularFixed.toString()),
              );
              isOvalCircularUpdate.add(
                bool.parse(widgetData.isCircularNotFixed.toString()),
              );
              updateShapeLineWidthSize.add(widgetData.widgetLineWidth ?? 2);
              isFixedFigureSize.add(
                bool.parse(widgetData.isFixedFigureSize.toString()),
              );
              trueShapeWidth.add(widgetData.trueShapeWidth!);
              trueShapeHeight.add(widgetData.trueShapeHeight!);
              isShapeLock.add(false);
              break;

            case 'Line':
              showLineWidget = true;
              lineCodes.add(getAddData);
              lineOffsets.add(getOffset);
              lineCodesContainerRotations.add(getRotation);
              updateSliderLineWidth.add(widgetData.widgetLineWidth ?? 2.0);
              isDottedLineUpdate.add(widgetData.isRoundRectangale ?? false);
              updateLineWidth.add(getWidgetWidth);
              isLineLock.add(false);
              selectedLineIndex = lineCodes.length - 1;
              break;

            case 'Background':
              showBackgroundImageWidget = true;
              backgroundImage = widgetData.selectedEmojiIcons;
              break;
          }
        }
        notifyListeners();
      } else {
        debugPrint(
          'No widget containers found for Main Container ID: $containerId',
        );
      }
    } catch (e) {
      debugPrint('Error retrieving containers: $e');
    }
  }
}
