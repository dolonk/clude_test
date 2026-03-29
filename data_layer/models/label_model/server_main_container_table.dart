import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ServerMainContainerTableModel {
  final int? id;
  final String containerName;
  final int containerHeight;
  final int containerWidth;
  final double? responsiveWidth;
  final double? responsiveHeight;
  final Uint8List? containerImageBitmapData;
  final String? subCategories;
  final String? printerType;

  ServerMainContainerTableModel({
    this.id,
    required this.containerName,
    required this.containerHeight,
    required this.containerWidth,
    this.responsiveWidth,
    this.responsiveHeight,
    this.containerImageBitmapData,
    this.subCategories,
    this.printerType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'containerName': containerName,
      'containerHeight': containerHeight,
      'containerWidth': containerWidth,
      'responsiveWidth': responsiveWidth,
      'responsiveHeight': responsiveHeight,
      'containerImageBitmapData': containerImageBitmapData,
      'subCategories': subCategories,
      'printerType': printerType,
    };
  }

  factory ServerMainContainerTableModel.fromJson(Map<String, dynamic> json) {
    return ServerMainContainerTableModel(
      id: json['id'],
      containerName: json['containerName'] ?? '',
      containerHeight: json['containerHeight'] ?? 0,
      containerWidth: json['containerWidth'] ?? 0,
      responsiveWidth: json['responsiveWidth'] != null
          ? (json['responsiveWidth'] as num).toDouble()
          : null,
      responsiveHeight: json['responsiveHeight'] != null
          ? (json['responsiveHeight'] as num).toDouble()
          : null,
      containerImageBitmapData: parseSelectedEmojiIcons(json),
      subCategories: json['subCategories'],
      printerType: json['printerType'],
    );
  }

  static Uint8List? parseSelectedEmojiIcons(Map<String, dynamic> map) {
    try {
      var selectedEmojiData = map['containerImageBitmapData'];
      if (selectedEmojiData is String && selectedEmojiData.isNotEmpty) {
        if (selectedEmojiData.startsWith('[') &&
            selectedEmojiData.endsWith(']')) {
          String trimmedData = selectedEmojiData.substring(
            1,
            selectedEmojiData.length - 1,
          );
          List<int> byteList = trimmedData
              .split(',')
              .map((e) => int.parse(e.trim()))
              .toList();
          return Uint8List.fromList(byteList);
        } else {
          return base64Decode(selectedEmojiData);
        }
      } else if (selectedEmojiData is Uint8List) {
        return selectedEmojiData;
      } else {
        debugPrint(
          'Unexpected type for selectedEmojiIcons: ${selectedEmojiData.runtimeType}',
        );
      }
    } catch (e) {
      debugPrint('Error while parsing selectedEmojiIcons: $e');
    }
    return null;
  }
}
