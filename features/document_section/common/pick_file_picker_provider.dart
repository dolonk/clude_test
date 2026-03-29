import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as api;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import '../dot/view/doc_section/dot_document_screen.dart';
import '../../../utils/constants/label_global_variable.dart';
import '../thermal/view/doc_section/thermal_document_screen.dart';
import 'package:grozziie/features/document_section/dot/view/image_section/dot_image_view_screen.dart';
import 'package:grozziie/features/document_section/thermal/view/image_section/thermal_image_view_screen.dart';

class FilePickerProvider extends ChangeNotifier {
  bool isDialogOpen = false;
  bool isProcessing = false;

  /// Method to pick files and navigate to the appropriate screen based on the print type
  Future<void> pickFile({
    required BuildContext context,
    required String printType,
  }) async {
    // Prevent duplicate calls while processing
    if (isProcessing) return;

    isProcessing = true;
    notifyListeners();

    try {
      int fileIndex = 1;
      List<String> imagePaths = [];
      List<String> pdfPaths = [];
      List<String> allowedExtensions = [
        'pdf',
        'xlsx',
        'xls',
        'docx',
        'png',
        'jpg',
        'jpeg',
      ];

      // Allow user to pick multiple files
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null) {
        imagePaths.clear();
        pdfPaths.clear();

        for (var file in result.files) {
          String? filePath = file.path;
          if (filePath == null) continue;

          String extension = filePath.split('.').last.toLowerCase();

          if (['doc', 'docx', 'xlsx', 'xls'].contains(extension)) {
            try {
              if (!context.mounted) return;
              String convertedPdfPath = await convertDocxToPdf(
                context,
                filePath,
                fileIndex,
              );
              pdfPaths.add(convertedPdfPath);
              fileIndex++;
            } catch (e) {
              debugPrint('Failed to convert $filePath to PDF: $e');
            }
          } else if (['png', 'jpg', 'jpeg'].contains(extension)) {
            imagePaths.add(filePath);
          } else if (extension == 'pdf') {
            pdfPaths.add(filePath);
          }
        }

        // Navigate to the appropriate screen
        if (printType == thermalPrinter) {
          selectPrinter = thermalPrinter;
          if (imagePaths.isNotEmpty) {
            if (!context.mounted) return;
            Navigator.push(
              context,
              FluentPageRoute(
                builder: (context) =>
                    ThermalImageScreen(imagePaths: imagePaths),
              ),
            );
          } else if (pdfPaths.isNotEmpty) {
            if (!context.mounted) return;
            Navigator.push(
              context,
              FluentPageRoute(
                builder: (context) => ThermalDocumentScreen(filePath: pdfPaths),
              ),
            );
          } else {
            debugPrint('No valid files selected.');
          }
        } else if (printType == dotPrinter) {
          selectPrinter = dotPrinter;
          if (imagePaths.isNotEmpty) {
            if (!context.mounted) return;
            Navigator.push(
              context,
              FluentPageRoute(
                builder: (context) =>
                    DotImageViewScreen(imagePaths: imagePaths),
              ),
            );
          } else if (pdfPaths.isNotEmpty) {
            if (!context.mounted) return;
            Navigator.push(
              context,
              FluentPageRoute(
                builder: (context) => DotDocumentScreen(filePath: pdfPaths),
              ),
            );
          } else {
            debugPrint('No valid files selected.');
          }
        }
      } else {
        debugPrint('User canceled the file selection.');
      }
    } catch (e) {
      debugPrint('Error occurred while picking the files: $e');
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  /// Convert doc xls file to pdf
  Future<String> convertDocxToPdf(
    BuildContext context,
    String docxFilePath,
    int fileIndex,
  ) async {
    try {
      isDialogOpen = true;
      notifyListeners();

      var uri = Uri.parse(
        "https://grozziieget.zjweiting.com:3091/ToPDF-API-dev/pdf/upload",
      );
      var request = http.MultipartRequest('POST', uri);

      File file = File(docxFilePath);
      request.files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: api.basename(file.path),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        debugPrint("Uploaded successfully");
        final responseBody = await response.stream
            .transform(utf8.decoder)
            .join();
        Map<String, dynamic> result = jsonDecode(responseBody);

        if (result.containsKey('link: ') && result['link: '] != null) {
          String fileUrl = result['link: '];

          Dio dio = Dio();
          var dir = await getApplicationDocumentsDirectory();

          // Create a unique file name using the fileIndex
          String localPath = "${dir.path}/convertedFile_$fileIndex.pdf";

          await dio.download(
            fileUrl,
            localPath,
            onReceiveProgress: (rec, total) {
              debugPrint("Rec: $rec , Total: $total");
            },
          );

          isDialogOpen = false;
          notifyListeners();

          return localPath;
        } else {
          isDialogOpen = false;
          notifyListeners();
          throw Exception("The link key does not exist or is null");
        }
      } else {
        isDialogOpen = false;
        notifyListeners();
        throw Exception("Upload failed - Server error");
      }
    } catch (e) {
      isDialogOpen = false;
      notifyListeners();
      DSnackBar.warning(title: "Please try again");
      debugPrint('Error occurred while converting DOCX to PDF: $e');
      rethrow;
    }
  }
}
