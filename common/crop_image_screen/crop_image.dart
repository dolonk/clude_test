import 'dart:io';
import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/colors.dart';
import 'package:crop_your_image/crop_your_image.dart';
import '../../data_layer/models/crop_model/crop_model.dart';

Future<CropModel?> openCropScreen({
  required BuildContext context,
  Uint8List? imageBytes,
  String? filePath,
}) async {
  Uint8List? imageData;

  if (imageBytes != null) {
    imageData = imageBytes;
  } else if (filePath != null) {
    File file = File(filePath);
    if (await file.exists()) {
      imageData = await file.readAsBytes();
    } else {
      debugPrint("File does not exist.");
      return null;
    }
  } else {
    debugPrint("No image source provided.");
    return null;
  }

  if (!context.mounted) return null;
  final croppedResult = await Navigator.push(
    context,
    FluentPageRoute(
      builder: (context) => ImageCropScreen(imageBytes: imageData!),
    ),
  );

  if (croppedResult != null) {
    return CropModel(
      image: croppedResult["image"],
      x: croppedResult["x"],
      y: croppedResult["y"],
      width: croppedResult["width"],
      height: croppedResult["height"],
    );
  }
  return null;
}

class ImageCropScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const ImageCropScreen({super.key, required this.imageBytes});

  @override
  ImageCropScreenState createState() => ImageCropScreenState();
}

class ImageCropScreenState extends State<ImageCropScreen> {
  final cropController = CropController();
  Map<String, dynamic>? cropInfo;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        backgroundColor: DColors.primary,
        title: Center(
          child: Text(
            "Crop Your Image",
            style: context.titleLarge.apply(color: DColors.white),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, null),
          icon: const Icon(FluentIcons.chrome_close, color: DColors.white),
        ),
        actions: IconButton(
          onPressed: () => cropController.crop(),
          icon: const Icon(FluentIcons.accept_medium, color: DColors.white),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(DSizes.paddingMd),
        child: Crop(
          image: widget.imageBytes,
          controller: cropController,
          initialRectBuilder: InitialRectBuilder.withBuilder((
            viewportRect,
            imageRect,
          ) {
            return imageRect;
          }),
          onCropped: (croppedData) {
            if (croppedData is CropSuccess) {
              final croppedImage = croppedData.croppedImage;
              if (cropInfo != null) {
                cropInfo!["image"] = croppedImage;
                Navigator.pop(context, cropInfo);
              }
            } else if (croppedData is CropFailure) {
              debugPrint("Crop failed: ${croppedData.cause}");
            }
          },
          progressIndicator: const ProgressRing(activeColor: Colors.white),
          onMoved: (viewportRect, imageRect) {
            cropInfo = {
              "x": imageRect.left,
              "y": imageRect.top,
              "width": imageRect.width,
              "height": imageRect.height,
            };
          },
        ),
      ),
    );
  }
}
