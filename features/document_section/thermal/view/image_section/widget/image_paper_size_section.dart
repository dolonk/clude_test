import 'package:fluent_ui/fluent_ui.dart';
import '../../../../common/custom_input_field.dart';
import '../../../../common/custom_header_field.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/colors.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/common/print_settings/view/common_printer_settings.dart';
import 'package:grozziie/features/document_section/thermal/provider/thermal_image_provider.dart';

class ImagePaperSizeSection extends StatelessWidget {
  const ImagePaperSizeSection({super.key, required this.imageModel});

  final ThermalImageProvider imageModel;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Paper Size Section
            CustomHeaderField(
              hTittle: dTexts.paperSize,
              child: Column(
                children: [
                  /// Aspect Ratio
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      spacing: 8,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${dTexts.aspectRatio}    ',
                              style: context.bodyStrong,
                            ),
                            Checkbox(
                              checked: imageModel.isAspectRatio,
                              onChanged: (value) =>
                                  imageModel.setIsAspectRatio(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Save data", style: context.bodyStrong),
                            const SizedBox(width: DSizes.spaceBtwItems),
                            Checkbox(
                              checked: imageModel.isSaveData,
                              onChanged: (value) => imageModel.setIsSaveData(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  /// Rotation Paper Height
                  if (imageModel.rotationDegree == 90 ||
                      imageModel.rotationDegree == 270)
                    CustomInputField(
                      tittle: dTexts.height,
                      controller:
                          imageModel.paperHeightControllers[imageModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (height) {
                        imageModel.rotatedUserInputWidthHeight(
                          selectField: 'HEIGHT',
                          height: height,
                        );
                      },
                    ),
                  if (imageModel.rotationDegree == 90 ||
                      imageModel.rotationDegree == 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// Rotation Paper Width
                  if (imageModel.rotationDegree == 90 ||
                      imageModel.rotationDegree == 270)
                    CustomInputField(
                      tittle: dTexts.width,
                      controller:
                          imageModel.paperWidthControllers[imageModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (width) {
                        imageModel.rotatedUserInputWidthHeight(
                          selectField: 'WIDTH',
                          width: width,
                        );
                      },
                    ),
                  if (imageModel.rotationDegree == 90 ||
                      imageModel.rotationDegree == 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// width section
                  if (imageModel.rotationDegree != 90 &&
                      imageModel.rotationDegree != 270)
                    CustomInputField(
                      tittle: dTexts.width,
                      controller:
                          imageModel.paperWidthControllers[imageModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (width) {
                        imageModel.userInputWidthHeight(
                          selectField: 'WIDTH',
                          width: width,
                        );
                      },
                    ),
                  if (imageModel.rotationDegree != 90 &&
                      imageModel.rotationDegree != 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// Height Section
                  if (imageModel.rotationDegree != 90 &&
                      imageModel.rotationDegree != 270)
                    CustomInputField(
                      tittle: dTexts.height,
                      controller:
                          imageModel.paperHeightControllers[imageModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (height) {
                        imageModel.userInputWidthHeight(
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
                    controller: imageModel.pageStartController,
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  /// End Page
                  CustomInputField(
                    tittle: dTexts.endP,
                    controller: imageModel.pageEndController,
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(dTexts.rotationP, style: context.bodyStrong),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => imageModel.uiChangeRotation(context),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: DColors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(imageModel.rotationDegree.toString()),
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
                  onPressed: () {
                    imageModel.startPrint(context);
                  },
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
