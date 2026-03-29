import 'package:fluent_ui/fluent_ui.dart';
import '../../../../common/custom_input_field.dart';
import '../../../../common/custom_header_field.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../../../../utils/constants/colors.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/common/print_settings/view/common_printer_settings.dart';
import 'package:grozziie/features/document_section/thermal/provider/thermal_document_provider.dart';

class PdfPaperSizeSection extends StatelessWidget {
  const PdfPaperSizeSection({
    super.key,
    required this.thermalPdfModel,
    required this.filePath,
  });

  final ThermalDocumentProvider thermalPdfModel;
  final List<String> filePath;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DSizes.paddingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Paper Size Section
            CustomHeaderField(
              hTittle: DTexts.instance.paperSize,
              child: Column(
                children: [
                  /// Aspect Ratio Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DSizes.paddingMd,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runSpacing: DSizes.spaceBtwItems,
                        spacing: DSizes.spaceBtwItems,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                dTexts.aspectRatio,
                                style: context.bodyStrong,
                              ),
                              const SizedBox(width: DSizes.spaceBtwItems),
                              Checkbox(
                                checked: thermalPdfModel.isAspectRatio,
                                onChanged: (value) =>
                                    thermalPdfModel.setIsAspectRatio(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(dTexts.zoomPage, style: context.bodyStrong),
                              const SizedBox(width: DSizes.spaceBtwItems),
                              Checkbox(
                                checked: thermalPdfModel.zoomPage,
                                onChanged: (value) =>
                                    thermalPdfModel.setZoomPageValue(value!),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(dTexts.saveData, style: context.bodyStrong),
                              const SizedBox(width: DSizes.spaceBtwItems),
                              Checkbox(
                                checked: thermalPdfModel.isSaveData,
                                onChanged: (value) =>
                                    thermalPdfModel.setIsSaveData(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  /// Rotation Paper Height
                  if (thermalPdfModel.rotationDegree == 90 ||
                      thermalPdfModel.rotationDegree == 270)
                    CustomInputField(
                      tittle: dTexts.height,
                      controller:
                          thermalPdfModel.paperHeightControllers[thermalPdfModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (height) {
                        thermalPdfModel.rotatedUserInputWidthHeight(
                          selectField: 'HEIGHT',
                          height: height,
                        );
                      },
                    ),
                  if (thermalPdfModel.rotationDegree == 90 ||
                      thermalPdfModel.rotationDegree == 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// Rotation Paper Width
                  if (thermalPdfModel.rotationDegree == 90 ||
                      thermalPdfModel.rotationDegree == 270)
                    CustomInputField(
                      tittle: dTexts.width,
                      controller:
                          thermalPdfModel.paperWidthControllers[thermalPdfModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (width) {
                        thermalPdfModel.rotatedUserInputWidthHeight(
                          selectField: 'WIDTH',
                          width: width,
                        );
                      },
                    ),
                  if (thermalPdfModel.rotationDegree == 90 ||
                      thermalPdfModel.rotationDegree == 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// width section
                  if (thermalPdfModel.rotationDegree != 90 &&
                      thermalPdfModel.rotationDegree != 270)
                    CustomInputField(
                      tittle: dTexts.width,
                      controller:
                          thermalPdfModel.paperWidthControllers[thermalPdfModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (width) {
                        thermalPdfModel.userInputWidthHeight(
                          selectField: 'WIDTH',
                          width: width,
                        );
                      },
                    ),
                  if (thermalPdfModel.rotationDegree != 90 &&
                      thermalPdfModel.rotationDegree != 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// Height Section
                  if (thermalPdfModel.rotationDegree != 90 &&
                      thermalPdfModel.rotationDegree != 270)
                    CustomInputField(
                      tittle: dTexts.height,
                      controller:
                          thermalPdfModel.paperHeightControllers[thermalPdfModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (height) {
                        thermalPdfModel.userInputWidthHeight(
                          selectField: 'HEIGHT',
                          height: height,
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: DSizes.spaceBtwSections),

            /// Paper Page Section
            CustomHeaderField(
              hTittle: dTexts.paperPage,
              child: Column(
                children: [
                  /// Start Page
                  CustomInputField(
                    tittle: dTexts.startP,
                    controller: thermalPdfModel.pageStartController,
                    onChange: (value) {},
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  /// End Page
                  CustomInputField(
                    tittle: dTexts.endP,
                    controller: thermalPdfModel.pageEndController,
                    onChange: (value) {
                      //thermalPdfModel.checkPaperEnd(value);
                    },
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  /// Scale
                  CustomInputField(
                    tittle: dTexts.scale,
                    controller: thermalPdfModel.scaleController,
                    onSubmitted: (value) {
                      final intValue = int.parse(value);
                      thermalPdfModel.setPaperScale(filePath, intValue);
                    },
                  ),

                  const SizedBox(height: DSizes.spaceBtwItems),
                ],
              ),
            ),
            const SizedBox(height: DSizes.spaceBtwSections),

            /// Rotation Section
            CustomHeaderField(
              hTittle: dTexts.rotationPage,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DSizes.paddingMd,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(dTexts.rotationP, style: context.bodyLarge),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          thermalPdfModel.uiChangeRotation(context);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: DColors.black),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              thermalPdfModel.rotationDegree.toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: DSizes.spaceBtwSections),

            /// Print Section
            CustomHeaderField(
              hTittle: dTexts.printSettings,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CommonPrinterSettings(
                  onPressed: () => thermalPdfModel.startPrint(context),
                  context: context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
