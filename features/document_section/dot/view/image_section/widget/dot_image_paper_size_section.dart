import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../common/custom_input_field.dart';
import '../../../../common/custom_header_field.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../localization/main_texts.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../../../../../common/print_settings/view/common_printer_settings.dart';
import 'package:grozziie/features/document_section/dot/provider/dot_image_provider.dart';

class DotImagePaperSizeSection extends StatelessWidget {
  const DotImagePaperSizeSection({super.key, required this.dotImageModel});
  final DotImageProvider dotImageModel;

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
                    padding: const EdgeInsets.symmetric(
                      horizontal: DSizes.paddingMd,
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Row(
                          children: [
                            Text(dTexts.aspectRatio, style: context.bodyStrong),
                            const SizedBox(width: DSizes.spaceBtwItems),
                            Checkbox(
                              checked: dotImageModel.isAspectRatio,
                              onChanged: (value) =>
                                  dotImageModel.setIsAspectRatio(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Zoom Page:', style: context.bodyStrong),
                            const SizedBox(width: DSizes.spaceBtwItems),
                            Checkbox(
                              checked: dotImageModel.zoomPage,
                              onChanged: (value) =>
                                  dotImageModel.setZoomPageValue(value!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  Consumer<DotImageProvider>(
                    builder: (context, dotValue, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DSizes.paddingMd,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 110,
                              child: Text(
                                "select paper:",
                                style: context.bodyLarge,
                              ),
                            ),
                            Expanded(
                              child: ComboBox<String>(
                                value: dotValue.selectedPaperHeight,
                                placeholder: Text(
                                  dTexts.selectModel,
                                  style: context.bodyStrong,
                                ),
                                isExpanded: true,
                                items: (dotValue.dotModels ?? [])
                                    .map(
                                      (model) => ComboBoxItem<String>(
                                        value: model.defaultHeight,
                                        child: Text(
                                          model.defaultHeight ?? '',
                                          style: context.body,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    dotValue.setPaperHeight(value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  /// Rotation Paper Height
                  if (dotImageModel.rotationDegree == 90 ||
                      dotImageModel.rotationDegree == 270)
                    CustomInputField(
                      tittle: dTexts.height,
                      controller:
                          dotImageModel.paperHeightControllers[dotImageModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (height) {
                        dotImageModel.rotatedUserInputWidthHeight(
                          selectField: 'HEIGHT',
                          height: height,
                        );
                      },
                    ),
                  if (dotImageModel.rotationDegree == 90 ||
                      dotImageModel.rotationDegree == 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// Rotation Paper Width
                  if (dotImageModel.rotationDegree == 90 ||
                      dotImageModel.rotationDegree == 270)
                    CustomInputField(
                      tittle: dTexts.width,
                      controller:
                          dotImageModel.paperWidthControllers[dotImageModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (width) {
                        dotImageModel.rotatedUserInputWidthHeight(
                          selectField: 'WIDTH',
                          width: width,
                        );
                      },
                    ),
                  if (dotImageModel.rotationDegree == 90 ||
                      dotImageModel.rotationDegree == 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// width section
                  if (dotImageModel.rotationDegree != 90 &&
                      dotImageModel.rotationDegree != 270)
                    CustomInputField(
                      tittle: dTexts.width,
                      controller:
                          dotImageModel.paperWidthControllers[dotImageModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (width) {
                        dotImageModel.userInputWidthHeight(
                          selectField: 'WIDTH',
                          width: width,
                        );
                      },
                    ),
                  if (dotImageModel.rotationDegree != 90 &&
                      dotImageModel.rotationDegree != 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// Height Section
                  if (dotImageModel.rotationDegree != 90 &&
                      dotImageModel.rotationDegree != 270)
                    CustomInputField(
                      tittle: dTexts.height,
                      controller:
                          dotImageModel.paperHeightControllers[dotImageModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (height) {
                        dotImageModel.userInputWidthHeight(
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
                    controller: dotImageModel.pageStartController,
                    onChange: (value) {},
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  /// End Page
                  CustomInputField(
                    tittle: dTexts.endP,
                    controller: dotImageModel.pageEndController,
                    onChange: (value) {
                      dotImageModel.checkPaperEnd(value);
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
                          dotImageModel.uiChangeRotation(context);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: DColors.black),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              dotImageModel.rotationDegree.toString(),
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
                  onPressed: () {
                    dotImageModel.startPrint(context);
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
