import 'dart:isolate';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

///* ------------------------------- Isolated uni8list data to pixel formated --------------------------------------- */
Future<List<int>> receivedResizeDataToPixelsIsolated({
  required Uint8List imageData,
  required int width,
  required int height,
}) async {
  final receivePort = ReceivePort();

  // Start an isolate with the resize and pixel extraction function
  final isolate = await Isolate.spawn(_processResizeToPixelsInIsolate, {
    'imageData': imageData,
    'width': width,
    'height': height,
    'sendPort': receivePort.sendPort,
  });

  // Receive and return the processed pixel data from the isolate
  final pixelData = await receivePort.first as List<int>;

  // Clean up the isolate and the receive port
  receivePort.close();
  isolate.kill(priority: Isolate.immediate);

  return pixelData;
}

void _processResizeToPixelsInIsolate(Map<String, dynamic> data) {
  final rawBytes = data['imageData'] as Uint8List;
  final width = data['width'] as int;
  final height = data['height'] as int;
  final sendPort = data['sendPort'] as SendPort;

  try {
    // Decode the image from Uint8List data
    final originalImage = img.decodeImage(rawBytes);

    if (originalImage == null) throw Exception("Failed to decode image");

    // Resize the image to the specified dimensions
    final resizedImage = img.copyResize(originalImage, width: width, height: height);

    // Extract pixel data as RGB values
    final pixels = <int>[];
    for (var y = 0; y < resizedImage.height; y++) {
      for (var x = 0; x < resizedImage.width; x++) {
        final pixel = resizedImage.getPixel(x, y);

        // Extract RGB values
        pixels.addAll([pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()]);
      }
    }

    // Send the pixel data back to the main thread
    sendPort.send(pixels);
  } catch (e) {
    debugPrint("Error in isolate: $e");
    sendPort.send(<int>[]);
  }
}

///* ------------------------------- Isolated Rotated Section --------------------------------------- */
Future<List<int>> processRotateImageInIsolated({
  required Uint8List imgBytes,
  required int degrees,
  required int width,
  required int height,
}) async {
  // process rotated image according to position
  Uint8List? rotatedImageBytes = await _receivedRotatedImageInIsolate(imgBytes: imgBytes, degrees: degrees);

  // Resize the rotated image
  List<int> resizedPage = await receivedResizeDataToPixelsIsolated(
    imageData: rotatedImageBytes!,
    width: width,
    height: height,
  );

  return resizedPage;
}

Future<Uint8List?> _receivedRotatedImageInIsolate({required Uint8List imgBytes, required int degrees}) async {
  final receivePort = ReceivePort();

  // Spawn the isolate to handle rotating and encoding
  await Isolate.spawn(_processRotateImageInIsolate, {
    'imageData': imgBytes,
    'degrees': degrees,
    'sendPort': receivePort.sendPort,
  });

  // Wait for the processed image to be returned from the isolate
  return await receivePort.firstWhere((rotatedImageBytes) {
        receivePort.close();
        return rotatedImageBytes != null;
      })
      as Uint8List?;
}

void _processRotateImageInIsolate(Map<String, dynamic> data) {
  final rawBytes = data['imageData'] as Uint8List;
  final degrees = data['degrees'] as int;
  final sendPort = data['sendPort'] as SendPort;

  try {
    img.Image? originalImage = img.decodeImage(rawBytes);

    if (originalImage == null) {
      throw Exception("Failed to decode image");
    }

    // Rotate the image based on the degrees
    img.Image rotatedImage;
    switch (degrees) {
      case 90:
        rotatedImage = img.copyRotate(originalImage, angle: 90);
        break;
      case 180:
        rotatedImage = img.copyRotate(originalImage, angle: 180);
        break;
      case 270:
        rotatedImage = img.copyRotate(originalImage, angle: 270);
        break;
      default:
        rotatedImage = originalImage;
    }

    // Encode the rotated image back to Uint8List
    Uint8List rotatedImageBytes = Uint8List.fromList(img.encodePng(rotatedImage));

    // Send the processed image back to the main thread
    sendPort.send(rotatedImageBytes);
  } catch (e) {
    debugPrint("Error in decode, rotate, and encode isolate: $e");
    sendPort.send(null);
  }
}

///* ------------------------------- Auto image Crop --------------------------------------------------- */
double? globalCropX;
double? globalCropY;
double? globalCropWidth;
double? globalCropHeight;

Future<Uint8List?> autoImageCrop({
  required Uint8List pdfPage,
  required int x,
  required int y,
  required int width,
  required int height,
}) async {
  final receivePort = ReceivePort();

  final isolate = await Isolate.spawn(autoImageCropInIsolate, {
    'imageData': pdfPage,
    'x': x,
    'y': y,
    'width': width,
    'height': height,
    'sendPort': receivePort.sendPort,
  });

  // Return a resized image once received
  return await receivePort.firstWhere((resizedImageBytes) {
        receivePort.close();
        isolate.kill(priority: Isolate.immediate);
        return resizedImageBytes != null;
      })
      as Uint8List?;
}

void autoImageCropInIsolate(Map<String, dynamic> data) {
  final rawBytes = data['imageData'] as Uint8List;
  final x = data['x'] as int;
  final y = data['y'] as int;
  final width = data['width'] as int;
  final height = data['height'] as int;
  final sendPort = data['sendPort'] as SendPort;

  try {
    // Convert the raw bytes back to an Image object
    img.Image? originalImage = img.decodeImage(rawBytes);

    if (originalImage == null) throw Exception("Failed to decode image");

    // Resize the image to the new dimensions
    img.Image resizedImage = img.copyCrop(originalImage, x: x, y: y, width: width, height: height);

    // Convert the resized image back to Uint8List
    Uint8List resizedImageBytes = Uint8List.fromList(img.encodePng(resizedImage));

    // Send the resized image back to the main thread
    sendPort.send(resizedImageBytes);
  } catch (e) {
    debugPrint("Error resizing image: $e");
    sendPort.send(null);
  }
}

// Resize Image
Future<Uint8List?> processResizeImage({required Uint8List pdfPage, required int width, required int height}) async {
  final receivePort = ReceivePort();

  final isolate = await Isolate.spawn(resizeImageInIsolate, {
    'imageData': pdfPage,
    'width': width,
    'height': height,
    'sendPort': receivePort.sendPort,
  });

  // Return a resized image once received
  return await receivePort.firstWhere((resizedImageBytes) {
        receivePort.close();
        isolate.kill(priority: Isolate.immediate);
        return resizedImageBytes != null;
      })
      as Uint8List?;
}

void resizeImageInIsolate(Map<String, dynamic> data) {
  final rawBytes = data['imageData'] as Uint8List;
  final width = data['width'] as int;
  final height = data['height'] as int;
  final sendPort = data['sendPort'] as SendPort;

  try {
    // Convert the raw bytes back to an Image object
    img.Image? originalImage = img.decodeImage(rawBytes);

    if (originalImage == null) throw Exception("Failed to decode image");

    // Resize the image to the new dimensions
    img.Image resizedImage = img.copyResize(originalImage, width: width, height: height);

    // Convert the resized image back to Uint8List
    Uint8List resizedImageBytes = Uint8List.fromList(img.encodePng(resizedImage));

    // Send the resized image back to the main thread
    sendPort.send(resizedImageBytes);
  } catch (e) {
    debugPrint("Error resizing image: $e");
    sendPort.send(null);
  }
}

// Rotated image process isolated
Future<Uint8List?> processRotateImage({
  required Uint8List imgBytes,
  required int degrees,
  required int width,
  required int height,
}) async {
  // process rotated image according to position
  Uint8List? rotatedImageBytes = await rotatedImageInIsolate(imgBytes: imgBytes, degrees: degrees);

  // Resize the rotated image
  Uint8List? resizedPage = await processResizeImage(pdfPage: rotatedImageBytes!, width: width, height: height);

  return resizedPage;
}

Future<Uint8List?> rotatedImageInIsolate({required Uint8List imgBytes, required int degrees}) async {
  final receivePort = ReceivePort();

  // Spawn the isolate to handle rotating and encoding
  await Isolate.spawn(rotateImageInIsolate, {
    'imageData': imgBytes,
    'degrees': degrees,
    'sendPort': receivePort.sendPort,
  });

  // Wait for the processed image to be returned from the isolate
  return await receivePort.firstWhere((rotatedImageBytes) {
        receivePort.close();
        return rotatedImageBytes != null;
      })
      as Uint8List?;
}

void rotateImageInIsolate(Map<String, dynamic> data) {
  final rawBytes = data['imageData'] as Uint8List;
  final degrees = data['degrees'] as int;
  final sendPort = data['sendPort'] as SendPort;

  try {
    img.Image? originalImage = img.decodeImage(rawBytes);

    if (originalImage == null) {
      throw Exception("Failed to decode image");
    }

    // Rotate the image based on the degrees
    img.Image rotatedImage;
    switch (degrees) {
      case 90:
        rotatedImage = img.copyRotate(originalImage, angle: 90);
        break;
      case 180:
        rotatedImage = img.copyRotate(originalImage, angle: 180);
        break;
      case 270:
        rotatedImage = img.copyRotate(originalImage, angle: 270);
        break;
      default:
        rotatedImage = originalImage;
    }

    // Encode the rotated image back to Uint8List
    Uint8List rotatedImageBytes = Uint8List.fromList(img.encodePng(rotatedImage));

    // Send the processed image back to the main thread
    sendPort.send(rotatedImageBytes);
  } catch (e) {
    debugPrint("Error in decode, rotate, and encode isolate: $e");
    sendPort.send(null);
  }
}

// Crop Image
Future<Uint8List?> autoCropImagePaperHeight({
  required Uint8List pdfPage,
  required int width,
  required int height,
}) async {
  final receivePort = ReceivePort();

  final isolate = await Isolate.spawn(_autoCropImagePaperHeightInIsolate, {
    'imageData': pdfPage,
    'width': width,
    'height': height,
    'sendPort': receivePort.sendPort,
  });

  // Return a resized image once received
  return await receivePort.firstWhere((resizedImageBytes) {
        receivePort.close();
        isolate.kill(priority: Isolate.immediate);
        return resizedImageBytes != null;
      })
      as Uint8List?;
}

void _autoCropImagePaperHeightInIsolate(Map<String, dynamic> data) {
  final rawBytes = data['imageData'] as Uint8List;
  final width = data['width'] as int;
  final height = data['height'] as int;
  final sendPort = data['sendPort'] as SendPort;

  try {
    // Convert the raw bytes back to an Image object
    img.Image? originalImage = img.decodeImage(rawBytes);

    if (originalImage == null) throw Exception("Failed to decode image");

    // Resize the image to the new dimensions
    img.Image resizedImage = img.copyCrop(originalImage, x: 0, y: 0, width: width, height: height);

    // Convert the resized image back to Uint8List
    Uint8List resizedImageBytes = Uint8List.fromList(img.encodePng(resizedImage));

    // Send the resized image back to the main thread
    sendPort.send(resizedImageBytes);
  } catch (e) {
    debugPrint("Error resizing image: $e");
    sendPort.send(null);
  }
}
