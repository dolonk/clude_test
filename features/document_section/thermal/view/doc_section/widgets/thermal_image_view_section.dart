import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/utils/constants/sizes.dart';
import '../../../provider/thermal_document_provider.dart';
import 'package:grozziie/localization/main_texts.dart';

class PdfImageViewSection extends StatelessWidget {
  const PdfImageViewSection({super.key, required this.thermalPdfModel});
  final ThermalDocumentProvider thermalPdfModel;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          /// Image show section
          Column(
            spacing: 4,
            children: [
              Transform.rotate(
                angle: thermalPdfModel.rotationDegree * (pi / 180),
                child: Container(
                  width: double.infinity,
                  height: 700,
                  color: const Color(0xff004368).withAlpha(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: thermalPdfModel.isLoading
                        ? const Center(child: ProgressRing())
                        : thermalPdfModel.zoomPage
                        ? InteractiveViewer(
                            minScale: 1,
                            maxScale: 4,
                            child: Center(
                              child: Image.memory(
                                thermalPdfModel
                                    .allPdfPage[thermalPdfModel.startPage - 1],
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : Image.memory(
                            thermalPdfModel
                                .allPdfPage[thermalPdfModel.startPage - 1],
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              Text("${dTexts.pageLoading}: ${thermalPdfModel.jumToPage}"),
            ],
          ),
          const SizedBox(height: 20),

          /// Crop & page show section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // crop
              Row(
                children: [
                  /// Checkbox all crop
                  Row(
                    children: [
                      Checkbox(
                        checked: thermalPdfModel.isAllPagesCropped,
                        onChanged: (value) =>
                            thermalPdfModel.setAllPageCrop(value!),
                      ),
                      SizedBox(width: DSizes.spaceBtwItems),
                      Text(dTexts.allPage),
                    ],
                  ),
                  SizedBox(width: DSizes.spaceBtwItems),

                  /// button crop
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        thermalPdfModel.setCrop(context);
                      },
                      child: Text(dTexts.cropPdf),
                    ),
                  ),
                ],
              ),

              //Page list
              ComboBox<int>(
                value: thermalPdfModel.startPage,
                onChanged: (value) {
                  if (value != null) thermalPdfModel.jumpToPage(value);
                },
                items: List.generate(thermalPdfModel.jumToPage, (index) {
                  final pageNum = index + 1;
                  return ComboBoxItem<int>(
                    value: pageNum,
                    child: Text('${dTexts.page} $pageNum'),
                  );
                }),
                iconEnabledColor: Colors.grey,
                iconSize: 16,
              ),

              // page
              SizedBox(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: thermalPdfModel.goToPreviousPage,
                      icon: const Icon(FluentIcons.caret_hollow_mirrored),
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.grey),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(0),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text('${thermalPdfModel.startPage}'),
                      ),
                    ),
                    IconButton(
                      onPressed: thermalPdfModel.goToNextPage,
                      icon: const Icon(FluentIcons.caret_hollow),
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.grey),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
