import 'package:fluent_ui/fluent_ui.dart';
import 'models/local_widget_container_model.dart';
import 'models/local_main_widget_container_model.dart';
import '../../utils/constants/label_global_variable.dart';
import 'package:grozziie/data_layer/local_server/templated_database_helper.dart';

class LocalDataBaseSave {
  /// Insert MainContainerModelClass and return its ID
  static Future<int> insertMainContainer(
    String containerName,
    int containerWidth,
    int containerHeight,
    dynamic bitMapData,
    String printerType,
  ) async {
    MainContainerModelClass container = MainContainerModelClass(
      containerName: containerName,
      containerHeight: containerHeight,
      containerWidth: containerWidth,
      containerImageBitmapData: bitMapData,
      printerType: printerType,
    );
    return await TemplateDatabaseHelper.insertMainContainer(container);
  }

  /// Retrieve all MainContainers
  static Future<List<MainContainerModelClass>> retrieveAllMainContainers() async {
    return await TemplateDatabaseHelper.getAllMainContainers();
  }

  /// Update  MainContainer
  static Future<int> updateMainContainer(MainContainerModelClass container) async {
    return await TemplateDatabaseHelper.updateMainContainer(container);
  }

  /// Retrieve a MainContainer by its ID
  static Future<MainContainerModelClass?> getMainContainerById(int id) async {
    return await TemplateDatabaseHelper.getMainContainerById(id);
  }

  /// Delete a MainContainer
  static Future<int> deleteMainContainer(int id) async {
    return await TemplateDatabaseHelper.deleteMainContainer(id);
  }

  /// Insert widgetContainer data
  static Future<bool> insertWidgetContainer(int mainContainerId) async {
    List<WidgetContainerModelClass> widgetModelList = [];
    try {
      widgetModelList.clear();

      if (showTextEditingWidget) {
        for (int i = 0; i < textCodes.length; i++) {
          WidgetContainerModelClass widgetContainerModel = WidgetContainerModelClass(
            mainContainerId: mainContainerId,
            widgetType: 'Text',
            contentData: textCodes[i],
            offsetDx: textCodeOffsets[i].dx,
            offsetDy: textCodeOffsets[i].dy,
            rotation: textContainerRotations[i],
            width: updateTextWidthSize[i],
            height: updateTextHeightSize[i],
            isBold: updateTextBold[i],
            isItalic: updateTextItalic[i],
            isUnderline: updateTextUnderline[i],
            fontSize: updateTextFontSize[i],
            textAlignment: updateTextAlignment[i].toString(),
            fontFamily: textSelectedFontFamily[i],

            isTextStrikeThrough: updateTextStrikeThrough[i],
          );

          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showBarcodeWidget) {
        for (var i = 0; i < barCodes.length; i++) {
          WidgetContainerModelClass widgetContainerModel = WidgetContainerModelClass(
            mainContainerId: mainContainerId,
            widgetType: 'Barcode',
            contentData: barCodes[i],
            offsetDx: barCodeOffsets[i].dx,
            offsetDy: barCodeOffsets[i].dy,
            barEncodingType: barEncodingType[i],
            width: updateBarcodeWidth[i],
            height: updateBarcodeHeight[i],
            rotation: barCodesContainerRotations[i],
            isRectangale: drawText[i],
            isBold: barTextBold[i],
            isItalic: barTextItalic[i],
            isUnderline: barTextUnderline[i],
            isTextStrikeThrough: barTextStrikeThrough[i],
            fontSize: barTextFontSize[i],
          );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showQrcodeWidget) {
        for (var i = 0; i < qrCodes.length; i++) {
          WidgetContainerModelClass widgetContainerModel = WidgetContainerModelClass(
            mainContainerId: mainContainerId,
            widgetType: 'Qrcode',
            contentData: qrCodes[i],
            offsetDx: qrCodeOffsets[i].dx,
            offsetDy: qrCodeOffsets[i].dy,
            width: updateQrcodeSize[i],
          );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showTableWidget) {
        for (var i = 0; i < tableCodes.length; i++) {
          WidgetContainerModelClass widgetContainerModel = WidgetContainerModelClass(
            mainContainerId: mainContainerId,
            widgetType: 'Table',
            contentData: tableCodes[i],
            offsetDx: tableOffsets[i].dx,
            offsetDy: tableOffsets[i].dy,
            width: 0,
            rotation: tableContainerRotations[i],
            rowCount: rowCount[i],
            columnCount: columnCount[i],
            widgetLineWidth: tableLineWidth[i],
            tablesCells: [tablesCells[i]],
            tablesRowHeights: [tablesRowHeights[i]],
            tablesColumnWidths: [tablesColumnWidths[i]],
            isRoundRectangale: tableBorderStyle[i],
          );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showImageWidget) {
        for (var i = 0; i < imageCodes.length; i++) {
          WidgetContainerModelClass widgetContainerModel = WidgetContainerModelClass(
            mainContainerId: mainContainerId,
            widgetType: 'Image',
            contentData: "",
            offsetDx: imageOffsets[i].dx,
            offsetDy: imageOffsets[i].dy,
            rotation: imageCodesContainerRotations[i],
            width: updateImageSize[i],
            selectedEmojiIcons: imageCodes[i],
          );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showEmojiWidget) {
        for (var i = 0; i < emojiCodes.length; i++) {
          WidgetContainerModelClass widgetContainerModel = WidgetContainerModelClass(
            mainContainerId: mainContainerId,
            widgetType: 'Emoji',
            contentData: emojiCodes[i],
            offsetDx: emojiCodeOffsets[i].dx,
            offsetDy: emojiCodeOffsets[i].dy,
            rotation: emojiCodesContainerRotations[i],
            width: updatedEmojiWidth[i],
            selectedEmojiIcons: selectedEmojis[i],
          );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showShapeWidget) {
        for (var i = 0; i < shapeCodes.length; i++) {
          WidgetContainerModelClass widgetContainerModel = WidgetContainerModelClass(
            mainContainerId: mainContainerId,
            widgetType: 'Shape',
            contentData: shapeCodes[i],
            offsetDx: shapeOffsets[i].dx,
            offsetDy: shapeOffsets[i].dy,
            shapeTypes: shapeTypes[i],
            isRectangale: isSquareUpdate[i],
            isRoundRectangale: isRoundSquareUpdate[i],
            isCircularFixed: isCircularUpdate[i],
            isCircularNotFixed: isOvalCircularUpdate[i],
            widgetLineWidth: updateShapeLineWidthSize[i],
            width: updateShapeWidth[i],
            height: updateShapeHeight[i],
            isFixedFigureSize: isFixedFigureSize[i],
            trueShapeWidth: trueShapeWidth[i],
            trueShapeHeight: trueShapeHeight[i],
            rotation: shapeCodesContainerRotations[i],
          );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showLineWidget) {
        for (var i = 0; i < lineCodes.length; i++) {
          WidgetContainerModelClass widgetContainerModel = WidgetContainerModelClass(
            mainContainerId: mainContainerId,
            widgetType: "Line",
            contentData: lineCodes[i],
            offsetDx: lineOffsets[i].dx,
            offsetDy: lineOffsets[i].dy,
            width: updateLineWidth[i],
            rotation: lineCodesContainerRotations[i],
            isRoundRectangale: isDottedLineUpdate[i], // isRoundRectangle use for saving isDottedLineUpdate bool value
            fontSize: updateSliderLineWidth[i], // fontSize use for saving updateSliderLineWidth bool value
          );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showBackgroundImageWidget && backgroundImage != null) {
        WidgetContainerModelClass widgetContainerModel = WidgetContainerModelClass(
          mainContainerId: mainContainerId,
          widgetType: 'Background',
          contentData: "",
          offsetDx: 0,
          offsetDy: 0,
          width: 0,
          selectedEmojiIcons: backgroundImage,
        );
        widgetModelList.add(widgetContainerModel);
      }

      for (var widget in widgetModelList) {
        await TemplateDatabaseHelper.insertWidgetContainer(widget);
      }

      return true;
    } catch (e) {
      debugPrint("Error inserting data: $e");
      return false;
    }
  }

  /// Retrieve all WidgetContainers for a specific MainContainer
  static Future<List<WidgetContainerModelClass>> retrieveAllWidgetContainers(int mainContainerId) async {
    return await TemplateDatabaseHelper.getWidgetContainersForMainContainer(mainContainerId);
  }

  /// Delete a WidgetContainer
  static Future<int> deleteWidgetContainer(int id) async {
    return await TemplateDatabaseHelper.deleteWidgetContainer(id);
  }
}
