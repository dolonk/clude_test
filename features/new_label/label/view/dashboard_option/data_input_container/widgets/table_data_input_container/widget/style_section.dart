import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../../../../../../../../utils/constants/sizes.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../../../../../../utils/constants/label_global_variable.dart';
import '../../../../../../../../new_label/label/view/dashboard_option/data_input_container/widgets/table_data_input_container/widget/custom_label_slider.dart';

class TableStyle extends StatelessWidget {
  const TableStyle({super.key, required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    if (selectedTableIndex < 0 ||
        selectedTableIndex >= tableLineWidth.length ||
        selectedTableIndex >= tablesRowHeights.length ||
        selectedTableIndex >= tablesColumnWidths.length ||
        selectedTableIndex >= tablesSelectedCells.length) {
      return const SizedBox.shrink();
    }
    final bool isCellSelected =
        tablesSelectedCells[selectedTableIndex].isNotEmpty;

    return Column(
      children: [
        /// Text Tittle section
        ListTile(
          leading: const Icon(FluentIcons.navigate_back),
          title: Text(dTexts.tableStyle, style: context.title),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 42, right: 20),
          child: Column(
            children: [
              /// Table Width
              CustomLabelSlider(
                label: dTexts.tableWidth,
                value: selectedTableIndex >= 0
                    ? tableLineWidth[selectedTableIndex]
                    : 1,
                min: 0.0,
                max: 10,
                enabled: isCellSelected,
                disabledMessage: dTexts.selectCell,
                onChanged: (double value) {
                  context.tableProvider.tableWidth(value);
                },
              ),
              const SizedBox(height: DSizes.spaceBtwItems),

              /// Row length
              CustomLabelSlider(
                label: dTexts.rowHeight,
                value:
                    isCellSelected &&
                        tablesRowHeights[selectedTableIndex].isNotEmpty
                    ? tablesRowHeights[selectedTableIndex][tablesSelectedCells[selectedTableIndex]
                          .first
                          .rowIndex]
                    : 50.0,
                min: 1,
                max: 800,
                enabled: isCellSelected,
                disabledMessage: dTexts.selectCell,
                onChanged: (value) {
                  context.tableProvider.adjustSelectedRowHeight(value);
                },
              ),
              const SizedBox(height: DSizes.spaceBtwItems),

              /// Column length
              CustomLabelSlider(
                label: dTexts.columnWidth,
                value:
                    isCellSelected &&
                        tablesColumnWidths[selectedTableIndex].isNotEmpty
                    ? tablesColumnWidths[selectedTableIndex][tablesSelectedCells[selectedTableIndex]
                          .first
                          .colIndex]
                    : 100.0,
                min: 1,
                max: 800,
                enabled: isCellSelected,
                disabledMessage: dTexts.selectCell,
                onChanged: (value) {
                  context.tableProvider.adjustSelectedColumnWidth(value);
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
