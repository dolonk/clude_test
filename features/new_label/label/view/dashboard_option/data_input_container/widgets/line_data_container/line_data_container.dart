import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../../../../utils/constants/sizes.dart';
import '../../../../../../../../utils/constants/colors.dart';
import '../../../../../../../../localization/main_texts.dart';
import '../../../../../../../../utils/extension/text_extension.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../../../../../utils/constants/label_global_variable.dart';
import '../table_data_input_container/widget/custom_label_slider.dart';

class LineDataInputContainer extends StatelessWidget {
  final BuildContext context;
  const LineDataInputContainer({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    if (selectedLineIndex < 0 ||
        (isDottedLineUpdate.isNotEmpty &&
            selectedLineIndex >= isDottedLineUpdate.length) ||
        (updateSliderLineWidth.isNotEmpty &&
            selectedLineIndex >= updateSliderLineWidth.length)) {
      if (selectedLineIndex < 0) return const SizedBox.shrink();
    }

    // Stricter check if usage implies these arrays MUST have data at index
    if (selectedLineIndex < 0 ||
        selectedLineIndex >= isDottedLineUpdate.length ||
        selectedLineIndex >= updateSliderLineWidth.length) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        ListTile(
          leading: const Icon(FluentIcons.navigate_back),
          title: Text(dTexts.line, style: context.title),
        ),
        const SizedBox(height: DSizes.spaceBtwItems),

        Padding(
          padding: const EdgeInsets.only(left: 50, right: 20),
          child: Column(
            children: [
              // Line Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Line Type", style: context.bodyLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.lineProvider
                            .setIsDottedLineUpdateFlag(false),
                        child: SizedBox(
                          width: 44,
                          height: 24,
                          child:
                              ((isDottedLineUpdate.isNotEmpty &&
                                      selectedLineIndex <
                                          isDottedLineUpdate.length)
                                  ? isDottedLineUpdate[selectedLineIndex]
                                  : false)
                              ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    DColors.primary,
                                    BlendMode.srcATop,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/label_section/table/g_line.png',
                                  ),
                                )
                              : ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    DColors.black,
                                    BlendMode.srcATop,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/label_section/table/g_line.png',
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: DSizes.spaceBtwItems),

                      GestureDetector(
                        onTap: () => context.lineProvider
                            .setIsDottedLineUpdateFlag(true),
                        child: SizedBox(
                          height: 20,
                          width: 50,
                          child:
                              (isDottedLineUpdate.isNotEmpty &&
                                  selectedLineIndex <
                                      isDottedLineUpdate.length &&
                                  isDottedLineUpdate[selectedLineIndex])
                              ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    DColors.primary,
                                    BlendMode.srcATop,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/label_section/table/dot_line.png',
                                  ),
                                )
                              : ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    DColors.black,
                                    BlendMode.srcATop,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/label_section/table/dot_line.png',
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: DSizes.spaceBtwSections),

              // Line slider
              CustomLabelSlider(
                label: "Line Width",
                value:
                    (selectedLineIndex >= 0 &&
                        selectedLineIndex < updateSliderLineWidth.length)
                    ? updateSliderLineWidth[selectedLineIndex]
                    : 1,
                min: 0.2,
                max: 10,
                onChanged: (double value) {
                  context.lineProvider.setSliderValue(value);
                },
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
            ],
          ),
        ),
      ],
    );
  }
}
