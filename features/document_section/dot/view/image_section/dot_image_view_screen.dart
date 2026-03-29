import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../common/custom_body/custom_body.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../../../../common/print_settings/provider/printer_sdk_provider.dart';
import 'package:grozziie/features/document_section/dot/provider/dot_image_provider.dart';
import 'package:grozziie/features/document_section/dot/view/image_section/widget/dot_image_pre_view_section.dart';
import 'package:grozziie/features/document_section/dot/view/image_section/widget/dot_image_paper_size_section.dart';

class DotImageViewScreen extends StatefulWidget {
  const DotImageViewScreen({super.key, required this.imagePaths});
  final List<String> imagePaths;

  @override
  State<DotImageViewScreen> createState() => _DotImageViewScreenState();
}

class _DotImageViewScreenState extends State<DotImageViewScreen> {
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
        create: (_) => DotImageProvider(filePaths: widget.imagePaths),
        child: NavigationView(
          appBar: NavigationAppBar(
            title: Center(
              child: Text('Dot Printer', style: context.titleLarge),
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
              child: Consumer<DotImageProvider>(
                builder: (context, dotModel, child) {
                  return SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DotImagePaperSizeSection(dotImageModel: dotModel),
                        const SizedBox(width: DSizes.spaceBtwSections),
                        DotImagePreViewSection(dotImageModel: dotModel),
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
