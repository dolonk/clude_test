import 'dart:typed_data';

class MainContainerModelClass {
  final int? id;
  final String containerName;
  final int containerHeight;
  final int containerWidth;
  final Uint8List? containerImageBitmapData;
  final String? subCategories;
  final String? printerType;

  MainContainerModelClass({
    this.id,
    required this.containerName,
    required this.containerHeight,
    required this.containerWidth,
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
      'containerImageBitmapData': containerImageBitmapData,
      'subCategories': subCategories,
      'printerType': printerType,
    };
  }

  static MainContainerModelClass fromMap(Map<String, dynamic> map) {
    return MainContainerModelClass(
      id: map['id'],
      containerName: map['containerName'],
      containerHeight: map['containerHeight'],
      containerWidth: map['containerWidth'],
      containerImageBitmapData: map['containerImageBitmapData'],
      subCategories: map['subCategories'],
      printerType: map['printerType'],
    );
  }
}
