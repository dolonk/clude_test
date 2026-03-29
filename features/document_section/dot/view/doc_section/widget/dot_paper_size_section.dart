import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../common/custom_input_field.dart';
import '../../../../common/custom_header_field.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../localization/main_texts.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/common/print_settings/view/common_printer_settings.dart';
import 'package:grozziie/features/document_section/dot/provider/dot_document_provider.dart';

class DotPaperSizeSection extends StatelessWidget {
  const DotPaperSizeSection({
    super.key,
    required this.dotDocModel,
    required this.filePath,
  });
  final DotDocumentProvider dotDocModel;
  final List<String> filePath;

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
                              checked: dotDocModel.isAspectRatio,
                              onChanged: (value) =>
                                  dotDocModel.setIsAspectRatio(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${dTexts.zoomPage}:',
                              style: context.bodyStrong,
                            ),
                            const SizedBox(width: DSizes.spaceBtwItems),
                            Checkbox(
                              checked: dotDocModel.zoomPage,
                              onChanged: (value) =>
                                  dotDocModel.setZoomPageValue(value!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  Consumer<DotDocumentProvider>(
                    builder: (context, dotValue, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DSizes.paddingMd,
                        ),
                        child: Row(
                          children: [
                            Text("Default Page:", style: context.bodyStrong),
                            const SizedBox(width: DSizes.spaceBtwItems),
                            Checkbox(
                              checked: dotValue.isDefaultCrop,
                              onChanged: (value) =>
                                  dotValue.setIsDefaultCrop(value ?? false),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  Consumer<DotDocumentProvider>(
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
                  if (dotDocModel.rotationDegree == 90 ||
                      dotDocModel.rotationDegree == 270)
                    CustomInputField(
                      tittle: dTexts.height,
                      controller:
                          dotDocModel.paperHeightControllers[dotDocModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (height) {
                        dotDocModel.rotatedUserInputWidthHeight(
                          selectField: 'HEIGHT',
                          height: height,
                        );
                      },
                    ),
                  if (dotDocModel.rotationDegree == 90 ||
                      dotDocModel.rotationDegree == 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// Rotation Paper Width
                  if (dotDocModel.rotationDegree == 90 ||
                      dotDocModel.rotationDegree == 270)
                    CustomInputField(
                      tittle: dTexts.width,
                      controller:
                          dotDocModel.paperWidthControllers[dotDocModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (width) {
                        dotDocModel.rotatedUserInputWidthHeight(
                          selectField: 'WIDTH',
                          width: width,
                        );
                      },
                    ),
                  if (dotDocModel.rotationDegree == 90 ||
                      dotDocModel.rotationDegree == 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// width section
                  if (dotDocModel.rotationDegree != 90 &&
                      dotDocModel.rotationDegree != 270)
                    CustomInputField(
                      tittle: dTexts.width,
                      controller:
                          dotDocModel.paperWidthControllers[dotDocModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (width) {
                        dotDocModel.userInputWidthHeight(
                          selectField: 'WIDTH',
                          width: width,
                        );
                      },
                    ),
                  if (dotDocModel.rotationDegree != 90 &&
                      dotDocModel.rotationDegree != 270)
                    const SizedBox(height: DSizes.spaceBtwItems),

                  /// Height Section
                  if (dotDocModel.rotationDegree != 90 &&
                      dotDocModel.rotationDegree != 270)
                    CustomInputField(
                      tittle: dTexts.height,
                      controller:
                          dotDocModel.paperHeightControllers[dotDocModel
                                  .startPage -
                              1] ??
                          TextEditingController(),
                      onChange: (height) {
                        dotDocModel.userInputWidthHeight(
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
                    controller: dotDocModel.pageStartController,
                    onChange: (value) {},
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  /// End Page
                  CustomInputField(
                    tittle: dTexts.endP,
                    controller: dotDocModel.pageEndController,
                    onChange: (value) {
                      dotDocModel.checkPaperEnd(value);
                    },
                  ),
                  const SizedBox(height: DSizes.spaceBtwItems),

                  /// Scale
                  CustomInputField(
                    tittle: dTexts.scale,
                    controller: dotDocModel.scaleController,
                    onSubmitted: (value) {
                      final intValue = int.parse(value);
                      dotDocModel.setPaperScale(filePath, intValue);
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
                          dotDocModel.uiChangeRotation(context);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: DColors.black),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(dotDocModel.rotationDegree.toString()),
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
                    dotDocModel.startPrint(context);
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
