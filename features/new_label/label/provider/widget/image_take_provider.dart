import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../common/clipboard_service/clipboard_service.dart';
import '../common/common_function_provider.dart';
import '../../../../../utils/extension/global_context.dart';
import '../../../../../common/redo_undo/undo_redo_manager.dart';
import '../../../../../common/crop_image_screen/crop_image.dart';
import '../../../../../utils/constants/label_global_variable.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../../data_layer/models/redo_undo_model/image_state.dart';

class ImageTakeProvider extends ChangeNotifier {
  CommonFunctionProvider commonModel = CommonFunctionProvider();

  bool _isResizing = false;

  ImagePicker imagePicker = ImagePicker();
  double imageContainerHeight = 100.0;
  double minImageContainerHeight = 50.0;
  int _pasteCount = 0;

  /// ==================== UNDO / REDO ====================
  void saveCurrentImageState() {
    final context = GlobalContext.context;
    if (context == null) return;

    final snapshot = ImageState(
      imageCodes: List.from(imageCodes),
      imageOffsets: List.from(imageOffsets),
      updateImageSize: List.from(updateImageSize),
      imageCodesContainerRotations: List.from(imageCodesContainerRotations),
      isImageLock: List.from(isImageLock),
      showImageWidget: showImageWidget,
      showImageContainerFlag: showImageContainerFlag,
      imageBorder: imageBorder,
      selectedImageIndex: selectedImageIndex,
    );

    context.undoRedoProvider.addAction(
      ActionState(type: "Image", state: snapshot, restore: (s) => _restoreImageState(s as ImageState)),
    );
  }

  void _restoreImageState(ImageState state) {
    imageCodes = List.from(state.imageCodes);
    imageOffsets = List.from(state.imageOffsets);
    updateImageSize = List.from(state.updateImageSize);
    imageCodesContainerRotations = List.from(state.imageCodesContainerRotations);
    isImageLock = List.from(state.isImageLock);
    showImageWidget = state.showImageWidget;
    showImageContainerFlag = state.showImageContainerFlag;
    imageBorder = state.imageBorder;
    selectedImageIndex = state.selectedImageIndex;
    notifyListeners();
  }

  /// ==================== COPY / PASTE ====================
  Future<void> copyImageWidget() async {
    final context = GlobalContext.context;
    if (context == null) return;
    _pasteCount = 0;

    final snapshot = ImageState(
      imageCodes: [imageCodes[selectedImageIndex]],
      imageOffsets: [imageOffsets[selectedImageIndex]],
      updateImageSize: [updateImageSize[selectedImageIndex]],
      imageCodesContainerRotations: [imageCodesContainerRotations[selectedImageIndex]],
      isImageLock: [isImageLock[selectedImageIndex]],
      showImageWidget: true,
      showImageContainerFlag: true,
      imageBorder: imageBorder,
      selectedImageIndex: selectedImageIndex,
    );

    context.copyPasteProvider.copy(ClipboardItem(type: "image", state: snapshot));
  }

  Future<void> pasteImageWidget(ClipboardItem clipboard) async {
    commonModel.clearAllBorder();
    final context = GlobalContext.context;
    if (context == null) return;

    if (clipboard.state is! ImageState) return;
    final pastedState = clipboard.state as ImageState;
    _pasteCount++;
    Offset shift = Offset(10.0 * _pasteCount, 50.0 * _pasteCount);

    imageCodes.addAll(pastedState.imageCodes);
    imageOffsets.addAll(pastedState.imageOffsets.map((offset) => offset + shift).toList());
    updateImageSize.addAll(pastedState.updateImageSize);
    imageCodesContainerRotations.addAll(pastedState.imageCodesContainerRotations);
    isImageLock.add(false);
    imageBorder = true;
    selectedImageIndex = imageCodes.length - 1;

    context.copyPasteProvider.clear();
    saveCurrentImageState();
    notifyListeners();
  }

  /// ==================== CORE ACTIONS ====================
  void setShowImageWidget(bool flag) {
    showImageWidget = flag;
    saveCurrentImageState();
    notifyListeners();
  }

  Future<void> selectImageFormGallery(BuildContext context) async {
    try {
      final pickedFiles = await imagePicker.pickImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 20,
        source: ImageSource.gallery,
      );

      if (pickedFiles != null) {
        if (!context.mounted) return;
        final cropImage = await openCropScreen(context: context, filePath: pickedFiles.path);
        if (cropImage != null) {
          setShowImageWidget(true);
          generateImageCode(cropImage.image);
        } else {
          debugPrint("Cropped image is null");
        }
      }
    } catch (e) {
      debugPrint('Error selecting image: $e');
    }
  }

  void generateImageCode(Uint8List cropImage) {
    commonModel.generateBorderOff('image', true);

    imageCodes.add(cropImage);
    imageOffsets.add(Offset(0, (imageCodes.length * 5).toDouble()));
    imageCodesContainerRotations.add(0);
    updateImageSize.add(100);
    isImageLock.add(false);

    selectedImageIndex = imageCodes.length - 1;
    saveCurrentImageState();
    notifyListeners();
  }

  void deleteImageCode(int imageIndex) {
    if (imageIndex >= 0 && imageIndex < imageCodes.length) {
      imageCodes.removeAt(imageIndex);
      if (imageIndex < imageOffsets.length) {
        imageOffsets.removeAt(imageIndex);
      }
      if (imageIndex < imageCodesContainerRotations.length) {
        imageCodesContainerRotations.removeAt(imageIndex);
      }
      if (imageIndex < updateImageSize.length) {
        updateImageSize.removeAt(imageIndex);
      }

      if (imageIndex < isImageLock.length) {
        isImageLock.removeAt(imageIndex);
      }

      selectedImageIndex = imageCodes.isEmpty ? -1 : (imageIndex.clamp(0, imageCodes.length - 1));
      commonModel.generateBorderOff('image', false);
      saveCurrentImageState();
      notifyListeners();
    }
  }

  /// ==================== RESIZE HANDLING ====================
  void handleResizeGestureStart() {
    if (!_isResizing) {
      _isResizing = true;
      saveCurrentImageState();
    }
  }

  void handleResizeGesture(DragUpdateDetails details, int? imageIndex) {
    if (selectedImageIndex == imageIndex) {
      final newImageSize = updateImageSize[selectedImageIndex] + details.delta.dx;
      updateImageSize[selectedImageIndex] = newImageSize >= minImageContainerHeight
          ? newImageSize
          : minImageContainerHeight;
    }
    notifyListeners();
  }

  void handleResizeGestureEnd() {
    if (_isResizing) {
      saveCurrentImageState();
      _isResizing = false;
    }
  }
}

/* Future<Uint8List> convertToThermalBW(Uint8List imageBytes, {int threshold = 200}) async {
    // Decode image
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) return imageBytes;

    // Convert to grayscale
    img.Image grayscale = img.grayscale(originalImage);

    // Create new BW image
    img.Image bwImage = img.Image(width: grayscale.width, height: grayscale.height);

    const int windowSize = 1; // neighborhood size
    for (int y = 0; y < grayscale.height; y++) {
      for (int x = 0; x < grayscale.width; x++) {
        int sum = 0, count = 0;
        for (int dy = -windowSize; dy <= windowSize; dy++) {
          for (int dx = -windowSize; dx <= windowSize; dx++) {
            final nx = x + dx;
            final ny = y + dy;
            if (nx >= 0 && nx < grayscale.width && ny >= 0 && ny < grayscale.height) {
              sum += img.getLuminance(grayscale.getPixel(nx, ny)).toInt();
              count++;
            }
          }
        }
        final avgLuma = sum ~/ count;
        final luma = img.getLuminance(grayscale.getPixel(x, y));
        bwImage.setPixelRgba(
          x,
          y,
          luma < avgLuma ? 0 : 255,
          luma < avgLuma ? 0 : 255,
          luma < avgLuma ? 0 : 255,
          255,
        );
      }
    }

    return Uint8List.fromList(img.encodePng(bwImage));
  }*/
