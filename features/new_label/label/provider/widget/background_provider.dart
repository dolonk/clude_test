import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../common/crop_image_screen/crop_image.dart';
import '../../../../../utils/constants/label_global_variable.dart';

class LocalBackgroundProvider extends ChangeNotifier {
  File? imageFile;
  ImagePicker imagePicker = ImagePicker();

  void setLocalBackgroundImageContainerFlag(bool flag) {
    showBackgroundImageContainerFlag = flag;
    notifyListeners();
  }

  void deletedLocalBackgroundImageContainerFlag(bool flag) {
    showBackgroundImageWidget = flag;
    backgroundImage = null;
    notifyListeners();
  }

  Future<void> selectImageFormGallery(BuildContext context) async {
    try {
      final pickedFiles = await imagePicker.pickImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 50,
        source: ImageSource.gallery,
      );

      if (pickedFiles != null) {
        if (!context.mounted) return;
        final cropImage = await openCropScreen(
          context: context,
          filePath: pickedFiles.path,
        );
        if (cropImage != null) {
          showBackgroundImageWidget = true;
          backgroundImage = cropImage.image;
          notifyListeners();
        } else {
          debugPrint("Cropped image is null");
        }
      }
    } catch (e) {
      debugPrint('Error selecting image: $e');
    }
  }
}
