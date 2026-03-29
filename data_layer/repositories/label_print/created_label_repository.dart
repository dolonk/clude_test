import 'dart:convert';
import 'dart:typed_data';
import '../../../common/crop_image_screen/image_compress.dart';
import '../../../utils/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants/label_global_variable.dart';
import '../../models/label_model/server_main_container_table.dart';
import '../../models/label_model/server_widget_container_table.dart';
import '../../../features/new_label/label/provider/main_label/label_printer_provider.dart';

class CreatedLabelRepository {
  final mainContainerGetUrl = "${Env.zBaseUrl}newVersion/mainContainers";

  final mainContainerPostUrl = "${Env.zBaseUrl}newVersion/mainContainers/add";

  final widgetContainerPostUrl =
      "${Env.zBaseUrl}newVersion/widgetContainers/add";

  String getMainContainerId(int mainContainerId) =>
      "${Env.zBaseUrl}newVersion/mainContainers/get/main/$mainContainerId";

  String updateMainContainerById(int mainContainerId) =>
      "${Env.zBaseUrl}newVersion/mainContainers/update/$mainContainerId";

  String widgetContainerGetUrl(int mainContainerId) =>
      "${Env.zBaseUrl}newVersion/widgetContainers/getMain/$mainContainerId";

  String deleteMainContainer(int mainContainerId) =>
      "${Env.zBaseUrl}newVersion/mainContainers/delete/$mainContainerId";

  String deleteWidgetContainer(int mainContainerId) =>
      "${Env.zBaseUrl}newVersion/widgetContainers/multiDelete/$mainContainerId";

  /// post section
  Future<http.Response> postMainContainer(
    ServerMainContainerTableModel mainContainer,
  ) async {
    return await http.post(
      Uri.parse(mainContainerPostUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(mainContainer.toMap()),
    );
  }

  Future<http.Response> postWidgetContainer(
    ServerWidgetContainerTableModel widgetContainer,
  ) async {
    final jsonBody = jsonEncode(widgetContainer.toMap());

    final response = await http.post(
      Uri.parse(widgetContainerPostUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonBody,
    );

    return response;
  }

  /// insert section
  Future<int?> serverInsertMainContainer({
    required String containerName,
    required int containerWidth,
    required int containerHeight,
    required Uint8List saveBitmapImageData,
    required String subCategories,
    required String printerType,
  }) async {
    try {
      ServerMainContainerTableModel container = ServerMainContainerTableModel(
        containerName: containerName,
        containerWidth: containerWidth,
        containerHeight: containerHeight,
        responsiveWidth: selectWidthD,
        responsiveHeight: selectHeightD,
        containerImageBitmapData: saveBitmapImageData,
        subCategories: subCategories,
        printerType: printerType,
      );
      final response = await postMainContainer(container);
      if (response.statusCode == 201) {
        final serverId = jsonDecode(response.body)['result']['insertId'];
        return serverId;
      } else {
        debugPrint('Error saving to server: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint("Error inserting main container data: $e");
      return null;
    }
  }

  /// Widget container post request save function
  Future<bool> serverInsertWidgetContainer(int mainContainerId) async {
    List<ServerWidgetContainerTableModel> widgetModelList = [];
    try {
      widgetModelList.clear();

      if (showTextEditingWidget) {
        for (int i = 0; i < textCodes.length; i++) {
          ServerWidgetContainerTableModel widgetContainerModel =
              ServerWidgetContainerTableModel(
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

                // prefix: prefixNumber[i],
                // suffix: suffixNumber[i],
                checkTextIdentifyWidget: checkTextIdentifyWidget[i],
              );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showBarcodeWidget) {
        for (var i = 0; i < barCodes.length; i++) {
          ServerWidgetContainerTableModel
          widgetContainerModel = ServerWidgetContainerTableModel(
            mainContainerId: mainContainerId,
            widgetType: 'Barcode',
            contentData: barCodes[i],
            offsetDx: barCodeOffsets[i].dx,
            offsetDy: barCodeOffsets[i].dy,
            barEncodingType: barEncodingType[i],
            height: updateBarcodeHeight[i],
            width: updateBarcodeWidth[i],
            rotation: barCodesContainerRotations[i],
            isRectangale:
                drawText[i], // isRectangale this variable i save for the drawText[i] data
            isBold: barTextBold[i],
            isItalic: barTextItalic[i],
            isUnderline: barTextUnderline[i],
            fontSize: barTextFontSize[i],
          );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showQrcodeWidget) {
        for (var i = 0; i < qrCodes.length; i++) {
          ServerWidgetContainerTableModel widgetContainerModel =
              ServerWidgetContainerTableModel(
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
          ServerWidgetContainerTableModel widgetContainerModel =
              ServerWidgetContainerTableModel(
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
          Uint8List? compressedBitmapData = await compressImageIfNeeded(
            imageCodes[i],
          );
          ServerWidgetContainerTableModel widgetContainerModel =
              ServerWidgetContainerTableModel(
                mainContainerId: mainContainerId,
                widgetType: 'Image',
                contentData: "",
                selectedEmojiIcons: compressedBitmapData,
                offsetDx: imageOffsets[i].dx,
                offsetDy: imageOffsets[i].dy,
                rotation: imageCodesContainerRotations[i],
                width: updateImageSize[i],
              );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showEmojiWidget) {
        for (var i = 0; i < emojiCodes.length; i++) {
          Uint8List? compressedBitmapData = await compressImageIfNeeded(
            selectedEmojis[i],
          );
          ServerWidgetContainerTableModel widgetContainerModel =
              ServerWidgetContainerTableModel(
                mainContainerId: mainContainerId,
                widgetType: 'Emoji',
                contentData: emojiCodes[i],
                offsetDx: emojiCodeOffsets[i].dx,
                offsetDy: emojiCodeOffsets[i].dy,
                rotation: emojiCodesContainerRotations[i],
                width: updatedEmojiWidth[i],
                selectedEmojiIcons: compressedBitmapData,
              );
          widgetModelList.add(widgetContainerModel);
        }
      }

      if (showShapeWidget) {
        for (var i = 0; i < shapeCodes.length; i++) {
          ServerWidgetContainerTableModel widgetContainerModel =
              ServerWidgetContainerTableModel(
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
          ServerWidgetContainerTableModel
          widgetContainerModel = ServerWidgetContainerTableModel(
            mainContainerId: mainContainerId,
            widgetType: "Line",
            contentData: lineCodes[i],
            offsetDx: lineOffsets[i].dx,
            offsetDy: lineOffsets[i].dy,
            width: updateLineWidth[i],
            rotation: lineCodesContainerRotations[i],
            isRoundRectangale:
                isDottedLineUpdate[i], // isRoundRectangle use for saving isDottedLineUpdate bool value
            fontSize:
                updateSliderLineWidth[i], // fontSize use for saving updateSliderLineWidth bool value
          );
          widgetModelList.add(widgetContainerModel);
        }
      }

      /*
      if (showBackgroundImageWidget) {
        ServerWidgetContainerTableModel widgetContainerModel = ServerWidgetContainerTableModel(
          mainContainerId: mainContainerId,
          widgetType: "Background Image",
          contentData: "",
          offsetDx: 0,
          offsetDy: 0,
          width: 0,
          selectedEmojiIcons: selectedImage,
        );
        widgetModelList.add(widgetContainerModel);
        debugPrint('save background $selectedImage');
      }*/

      for (final widgetContainer in widgetModelList) {
        final widgetResponse = await postWidgetContainer(widgetContainer);
        if (widgetResponse.statusCode != 200) {
          debugPrint('Data Save successfully: $widgetResponse');
        }
      }
      return true;
    } catch (e) {
      debugPrint("Error inserting data: $e");
      return false;
    }
  }

  /// updated section
  Future<bool> serverUpdateMainContainer(
    ServerMainContainerTableModel containerToUpdate,
  ) async {
    final response = await http.put(
      Uri.parse(updateMainContainerById(containerToUpdate.id!)),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(containerToUpdate.toMap()),
    );
    // Optionally print the response for debugging
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response.statusCode == 200;
  }

  /// get section
  Future<List<ServerMainContainerTableModel>?> getMainContainer({
    required String printerType,
    dynamic subCategories,
  }) async {
    String url = subCategories != null
        ? "$mainContainerGetUrl/printerTypeSubCategories/filter?printerType=$printerType&subCategories=$subCategories"
        : "$mainContainerGetUrl/printerTypeSubCategories/filter?printerType=$printerType&subCategories=";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['result'];
      List<ServerMainContainerTableModel> containers = jsonData
          .map((item) => ServerMainContainerTableModel.fromJson(item))
          .toList();
      return containers;
    } else {
      debugPrint(
        'Failed to load main container with status code: ${response.statusCode}',
      );
      return null;
    }
  }

  Future<List<ServerMainContainerTableModel>?> searchMainContainer({
    required String printerType,
    required String query,
  }) async {
    String url =
        "${Env.zBaseUrl}newVersion/mainContainers/filter/searchByContainerName?printerType=$printerType&containerName=$query";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['result'];
      List<ServerMainContainerTableModel> containers = jsonData
          .map((item) => ServerMainContainerTableModel.fromJson(item))
          .toList();
      return containers;
    } else {
      debugPrint(
        'Failed to search main container with status code: ${response.statusCode}',
      );
      return null;
    }
  }

  Future<List<ServerMainContainerTableModel>?> getMainContainerById(
    int containerId,
  ) async {
    final response = await http.get(
      Uri.parse((getMainContainerId(containerId))),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<ServerMainContainerTableModel> containers = jsonData
          .map((item) => ServerMainContainerTableModel.fromJson(item))
          .toList();
      return containers;
    } else {
      debugPrint(
        'Failed to load main container with status code: ${response.statusCode}',
      );
      return null;
    }
  }

  Future<List<ServerWidgetContainerTableModel>?> getWidgetContainers(
    int mainContainerId,
  ) async {
    final response = await http.get(
      Uri.parse(widgetContainerGetUrl(mainContainerId)),
    );
    if (response.statusCode == 200) {
      var list = json.decode(response.body);
      if (list is List) {
        final List<ServerWidgetContainerTableModel> serverWidgetContainers =
            list
                .map((item) => ServerWidgetContainerTableModel.fromJson(item))
                .toList();
        return serverWidgetContainers;
      } else {
        throw Exception("Failed to retrieve widget containers.");
      }
    } else {
      debugPrint('Failed to load widget containers');
      return null;
    }
  }

  /// delete section
  Future<bool> serverDeleteMainContainerItem(int containerId) async {
    final url = Uri.parse((deleteMainContainer(containerId)));
    http.Response response;
    try {
      response = await http.delete(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return false;
    }
  }

  Future<bool> serverDeleteWidgetContainerItem(int containerId) async {
    final url = Uri.parse((deleteWidgetContainer(containerId)));
    http.Response response;
    try {
      response = await http.delete(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return false;
    }
  }
}
