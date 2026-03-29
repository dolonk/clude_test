import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../../utils/constants/colors.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../../../../../common/print_settings/provider/printer_sdk_provider.dart';
import 'package:grozziie/features/document_section/thermal/provider/thermal_document_provider.dart';
import 'package:grozziie/features/document_section/thermal/view/doc_section/widgets/thermal_image_view_section.dart';
import 'package:grozziie/features/document_section/thermal/view/doc_section/widgets/thermal_paper_size_section.dart';

import '../../../../../common/custom_body/custom_body.dart';

class ThermalDocumentScreen extends StatefulWidget {
  const ThermalDocumentScreen({super.key, required this.filePath});
  final List<String> filePath;

  @override
  State<ThermalDocumentScreen> createState() => _ThermalDocumentScreenState();
}

class _ThermalDocumentScreenState extends State<ThermalDocumentScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrinterSdkProvider>(
        context,
        listen: false,
      ).togglePrintSetting(true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return ChangeNotifierProvider(
      create: (_) => ThermalDocumentProvider(filePaths: widget.filePath),
      child: CustomBody(
        child: NavigationView(
          appBar: NavigationAppBar(
            title: Center(
              child: Text(
                dTexts.documentPrint,
                style: context.titleLarge.copyWith(color: DColors.primary),
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: DColors.white,
                    spreadRadius: 5,
                    blurRadius: 3,
                    blurStyle: BlurStyle.solid,
                  ),
                ],
              ),
              child: Consumer<ThermalDocumentProvider>(
                builder: (context, pdfModel, child) {
                  return SingleChildScrollView(
                    child: Row(
                      children: [
                        /// Pdf PaperSize Section
                        PdfPaperSizeSection(
                          thermalPdfModel: pdfModel,
                          filePath: widget.filePath,
                        ),

                        /// Pdf ImageView Section
                        PdfImageViewSection(thermalPdfModel: pdfModel),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
