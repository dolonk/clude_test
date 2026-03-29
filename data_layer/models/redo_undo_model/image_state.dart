import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';

class ImageState {
  final List<Uint8List> imageCodes;
  final List<Offset> imageOffsets;
  final List<double> updateImageSize;
  final List<double> imageCodesContainerRotations;
  final List<bool> isImageLock;
  final bool showImageWidget;
  final bool showImageContainerFlag;
  final bool imageBorder;
  final int selectedImageIndex;

  ImageState({
    required this.imageCodes,
    required this.imageOffsets,
    required this.updateImageSize,
    required this.imageCodesContainerRotations,
    required this.isImageLock,
    required this.showImageWidget,
    required this.showImageContainerFlag,
    required this.imageBorder,
    required this.selectedImageIndex,
  });

  /// baseline empty state
  factory ImageState.empty() {
    return ImageState(
      imageCodes: [],
      updateImageSize: [],
      imageCodesContainerRotations: [],
      imageOffsets: [],
      isImageLock: [],
      showImageWidget: false,
      showImageContainerFlag: false,
      imageBorder: false,
      selectedImageIndex: -1,
    );
  }

  ImageState copyWith({
    List<Uint8List>? imageCodes,
    List<Offset>? imageOffsets,
    List<double>? updateImageSize,
    List<double>? imageCodesContainerRotations,
    List<bool>? isImageLock,
    bool? showImageWidget,
    bool? showImageContainerFlag,
    bool? imageBorder,
    int? selectedImageIndex,
  }) {
    return ImageState(
      imageCodes: imageCodes ?? List.from(this.imageCodes),
      imageOffsets: imageOffsets ?? List.from(this.imageOffsets),
      updateImageSize: updateImageSize ?? List.from(this.updateImageSize),
      imageCodesContainerRotations:
          imageCodesContainerRotations ??
          List.from(this.imageCodesContainerRotations),
      isImageLock: isImageLock ?? List.from(this.isImageLock),
      showImageWidget: showImageWidget ?? this.showImageWidget,
      showImageContainerFlag:
          showImageContainerFlag ?? this.showImageContainerFlag,
      imageBorder: imageBorder ?? this.imageBorder,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
    );
  }
}
