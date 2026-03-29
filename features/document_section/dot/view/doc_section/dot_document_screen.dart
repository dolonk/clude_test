import 'package:grozziie/localization/main_texts.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../provider/dot_document_provider.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../common/custom_body/custom_body.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../../../../common/print_settings/provider/printer_sdk_provider.dart';
import 'package:grozziie/features/document_section/dot/view/doc_section/widget/dot_paper_size_section.dart';
import 'package:grozziie/features/document_section/dot/view/doc_section/widget/dot_image_view_section.dart';

class DotDocumentScreen extends StatefulWidget {
  const DotDocumentScreen({super.key, required this.filePath});
  final List<String> filePath;

  @override
  State<DotDocumentScreen> createState() => _DotDocumentScreenState();
}

class _DotDocumentScreenState extends State<DotDocumentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrinterSdkProvider>(
        context,
        listen: false,
      ).togglePrintSetting(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBody(
      child: ChangeNotifierProvider(
        create: (_) => DotDocumentProvider(filePaths: widget.filePath),
        child: NavigationView(
          appBar: NavigationAppBar(
            title: Center(
              child: Text(
                DTexts.instance.dotDocument,
                style: context.titleLarge,
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
              child: Consumer<DotDocumentProvider>(
                builder: (context, pdfModel, child) {
                  return SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DotPaperSizeSection(
                          dotDocModel: pdfModel,
                          filePath: widget.filePath,
                        ),
                        const SizedBox(width: DSizes.spaceBtwSections),
                        DotImageViewSection(dotDocModel: pdfModel),
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
