import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../common/custom_body/custom_body.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../../../../../common/print_settings/provider/printer_sdk_provider.dart';
import 'package:grozziie/features/document_section/thermal/provider/thermal_image_provider.dart';
import 'package:grozziie/features/document_section/thermal/view/image_section/widget/image_pre_view_section.dart';
import 'package:grozziie/features/document_section/thermal/view/image_section/widget/image_paper_size_section.dart';

class ThermalImageScreen extends StatefulWidget {
  const ThermalImageScreen({super.key, required this.imagePaths});
  final List<String> imagePaths;

  @override
  State<ThermalImageScreen> createState() => _ThermalImageScreenState();
}

class _ThermalImageScreenState extends State<ThermalImageScreen> {
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
      create: (_) => ThermalImageProvider(filePaths: widget.imagePaths),
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
              child: Consumer<ThermalImageProvider>(
                builder: (context, imageModel, child) {
                  return SingleChildScrollView(
                    child: Row(
                      children: [
                        /// Pdf PaperSize Section
                        ImagePaperSizeSection(imageModel: imageModel),

                        /// Pdf ImageView Section
                        ImagePreviewSection(imageModel: imageModel),
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
