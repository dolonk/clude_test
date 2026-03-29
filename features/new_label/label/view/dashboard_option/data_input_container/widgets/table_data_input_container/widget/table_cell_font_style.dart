import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../../../utils/constants/sizes.dart';
import 'package:grozziie/localization/main_texts.dart';
import '../../../../../../../../../utils/constants/colors.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../../../../../../../../utils/local_storage/local_data.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../../../../../../utils/constants/label_global_variable.dart';
import 'custom_label_slider.dart';

class TableCellFontStyle extends StatelessWidget {
  const TableCellFontStyle({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;

    if (selectedTableIndex < 0 ||
        selectedTableIndex >= tableBorderStyle.length) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        /// Font Tittle
        ListTile(
          leading: const Icon(FluentIcons.navigate_back),
          title: Text(dTexts.fontStyle, style: context.title),
        ),
        const SizedBox(height: DSizes.spaceBtwItems),

        /// Style section
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 20),
          child: Column(
            children: [
              /// table border style
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Line Type", style: context.bodyLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.tableProvider
                            .setIsDottedLineUpdateFlag(false),
                        child: SizedBox(
                          width: 44.w,
                          height: 24.h,
                          child:
                              (selectedTableIndex >= 0 &&
                                  selectedTableIndex <
                                      tableBorderStyle.length &&
                                  !tableBorderStyle[selectedTableIndex])
                              ? ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    DColors.primary,
                                    BlendMode.srcATop,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/label_section/table/g_line.png',
                                  ),
                                )
                              : ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    DColors.black,
                                    BlendMode.srcATop,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/label_section/table/g_line.png',
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: DSizes.spaceBtwItems),
                      GestureDetector(
                        onTap: () => context.tableProvider
                            .setIsDottedLineUpdateFlag(true),
                        child: SizedBox(
                          height: 20.h,
                          width: 50.w,
                          child:
                              (selectedTableIndex >= 0 &&
                                  selectedTableIndex <
                                      tableBorderStyle.length &&
                                  tableBorderStyle[selectedTableIndex])
                              ? ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    DColors.primary,
                                    BlendMode.srcATop,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/label_section/table/dot_line.png',
                                  ),
                                )
                              : ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
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
              const SizedBox(height: DSizes.spaceBtwItems),

              /// font rotated section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Font Rotated", style: context.bodyLarge),
                  IconButton(
                    icon: const Icon(FluentIcons.rotate90_clockwise, size: 24),
                    onPressed: () => context.tableProvider.fontRotateFunction(),
                  ),
                ],
              ),
              const SizedBox(height: DSizes.spaceBtwItems),

              /// Font selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 90.w,
                    child: InfoLabel(
                      label: dTexts.font,
                      labelStyle: context.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: ComboBox<String>(
                      value: context.commonProvider
                          .getTranslatedFontValueForDropdown(
                            context.tableProvider
                                    .getSelectedCell()
                                    ?.fontFamily ??
                                "",
                            context.languageProvider.fontTranslations,
                          ),
                      items: context.languageProvider.fontTranslations.entries
                          .map((entry) {
                            return ComboBoxItem<String>(
                              value: entry.value,
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontFamily: entry.key,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (newFontTranslated) {
                        if (newFontTranslated != null) {
                          final fontKey = context
                              .languageProvider
                              .fontTranslations
                              .entries
                              .firstWhere(
                                (entry) => entry.value == newFontTranslated,
                              )
                              .key;

                          LocalData.saveLocalData<String>(
                            "FontFamily",
                            fontKey,
                          );
                          context.tableProvider.updateFontFamily(
                            context,
                            fontKey,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DSizes.spaceBtwItems),

              /// Font Size
              CustomLabelSlider(
                label: dTexts.size,
                labelSize: 70.h,
                value: context.tableProvider.getSelectedCell()?.fontSize ?? 6.0,
                min: 1,
                max: 100,
                enabled: tablesSelectedCells[selectedTableIndex].isNotEmpty,
                disabledMessage: dTexts.selectCell,
                onChanged: (double value) {
                  context.tableProvider.updateFontSize(value);
                  context.tableProvider.saveCurrentTableState();
                },
              ),
              const SizedBox(height: DSizes.spaceBtwItems),

              /// Font Alignment
              Row(
                children: [
                  SizedBox(
                    width: 90.w,
                    child: InfoLabel(
                      label: dTexts.align,
                      labelStyle: context.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ToggleButton(
                          checked:
                              context.tableProvider
                                  .getCurrentCell(
                                    selectedTableIndex,
                                    selectedRowIndex,
                                    selectedColIndex,
                                  )
                                  ?.alignment ==
                              Alignment.centerLeft,
                          onChanged: (v) {
                            context.tableProvider.changeAlignment(
                              Alignment.centerLeft,
                              textAlign: TextAlign.left,
                            );
                          },
                          child: const Icon(FluentIcons.align_left),
                        ),
                        ToggleButton(
                          checked:
                              context.tableProvider
                                  .getCurrentCell(
                                    selectedTableIndex,
                                    selectedRowIndex,
                                    selectedColIndex,
                                  )
                                  ?.alignment ==
                              Alignment.center,
                          onChanged: (v) {
                            context.tableProvider.changeAlignment(
                              Alignment.center,
                              textAlign: TextAlign.center,
                            );
                          },
                          child: const Icon(FluentIcons.text_align_bottom),
                        ),
                        ToggleButton(
                          checked:
                              context.tableProvider
                                  .getCurrentCell(
                                    selectedTableIndex,
                                    selectedRowIndex,
                                    selectedColIndex,
                                  )
                                  ?.alignment ==
                              Alignment.centerRight,
                          onChanged: (v) {
                            context.tableProvider.changeAlignment(
                              Alignment.centerRight,
                              textAlign: TextAlign.right,
                            );
                          },
                          child: const Icon(FluentIcons.align_right),
                        ),
                        ToggleButton(
                          checked:
                              context.tableProvider
                                  .getCurrentCell(
                                    selectedTableIndex,
                                    selectedRowIndex,
                                    selectedColIndex,
                                  )
                                  ?.alignment ==
                              Alignment.bottomCenter,
                          onChanged: (v) {
                            context.tableProvider.changeAlignment(
                              Alignment.bottomCenter,
                            );
                          },
                          child: const Icon(FluentIcons.align_justify),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DSizes.spaceBtwItems),

              /// Font Style Button
              Row(
                children: [
                  SizedBox(
                    width: 90.w,
                    child: InfoLabel(
                      label: dTexts.style,
                      labelStyle: context.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ToggleButton(
                          checked:
                              context.tableProvider
                                  .getCurrentCell(
                                    selectedTableIndex,
                                    selectedRowIndex,
                                    selectedColIndex,
                                  )
                                  ?.isBold ??
                              false,
                          onChanged: (value) {
                            final isCurrentlyBold =
                                context.tableProvider
                                    .getCurrentCell(
                                      selectedTableIndex,
                                      selectedRowIndex,
                                      selectedColIndex,
                                    )
                                    ?.isBold ??
                                false;
                            context.tableProvider.tableToggleBold(
                              !isCurrentlyBold,
                            );
                          },
                          child: const Icon(FluentIcons.bold),
                        ),
                        ToggleButton(
                          checked:
                              context.tableProvider
                                  .getCurrentCell(
                                    selectedTableIndex,
                                    selectedRowIndex,
                                    selectedColIndex,
                                  )
                                  ?.isItalic ??
                              false,
                          onChanged: (value) {
                            final isCurrentlyItalic =
                                context.tableProvider
                                    .getCurrentCell(
                                      selectedTableIndex,
                                      selectedRowIndex,
                                      selectedColIndex,
                                    )
                                    ?.isItalic ??
                                false;
                            context.tableProvider.tableToggleItalic(
                              !isCurrentlyItalic,
                            );
                          },
                          child: const Icon(FluentIcons.italic),
                        ),
                        ToggleButton(
                          checked:
                              context.tableProvider
                                  .getCurrentCell(
                                    selectedTableIndex,
                                    selectedRowIndex,
                                    selectedColIndex,
                                  )
                                  ?.isUnderline ??
                              false,
                          onChanged: (value) {
                            final isCurrentlyUnderline =
                                context.tableProvider
                                    .getCurrentCell(
                                      selectedTableIndex,
                                      selectedRowIndex,
                                      selectedColIndex,
                                    )
                                    ?.isUnderline ??
                                false;
                            context.tableProvider.tableToggleUnderline(
                              !isCurrentlyUnderline,
                            );
                          },
                          child: const Icon(FluentIcons.underline),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
