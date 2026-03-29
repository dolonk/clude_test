import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/features/new_label/label/provider/widget/table_provider.dart';
import 'package:grozziie/utils/constants/icons.dart';
import 'package:grozziie/localization/main_texts.dart';
import '../../../../../../../../../../utils/constants/sizes.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../../../../../../../utils/constants/label_global_variable.dart';
import '../../../../../../../../../../common/new_label/common_row_widget.dart';

class TableAddDeleteColumn extends StatelessWidget {
  const TableAddDeleteColumn({super.key, required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    // Basic check to ensure a table can be operated on
    if (selectedTableIndex < 0) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        /// Table Colum Section
        ListTile(
          leading: const Icon(FluentIcons.navigate_back),
          title: Text(dTexts.tableRowOption, style: context.title),
        ),
        const SizedBox(height: DSizes.spaceBtwItems),

        // Add Row top
        CommonRowWidget(
          context: context,
          labelText: dTexts.addRowAbove,
          iconPath: DIcons.insertRow,
          isInputField: true,
          onSubmitted: (value) {
            final count = int.tryParse(value) ?? 1;
            context.tableProvider.addTableCell(
              action: TableAction.rowTop,
              count: count,
            );
          },
        ),
        const SizedBox(height: DSizes.spaceBtwItems),

        // Add Row Bottom
        CommonRowWidget(
          context: context,
          labelText: dTexts.addRowBelow,
          iconPath: DIcons.insertRow,
          isInputField: true,
          onSubmitted: (value) {
            final count = int.tryParse(value) ?? 1;
            context.tableProvider.addTableCell(
              action: TableAction.rowBottom,
              count: count,
            );
          },
        ),
        const SizedBox(height: DSizes.spaceBtwItems),

        // Delete Row
        CommonRowWidget(
          context: context,
          onPress: context.tableProvider.deleteSelectedRows,
          labelText: dTexts.deleteRow,
          iconPath: DIcons.deleteRow,
          isInputField: false,
        ),
        const SizedBox(height: DSizes.spaceBtwItems),

        /// Table Colum Section
        ListTile(
          leading: const Icon(FluentIcons.navigate_back),
          title: Text(dTexts.tableColumOption, style: context.title),
        ),
        const SizedBox(height: DSizes.spaceBtwItems),

        // Add Colum left
        CommonRowWidget(
          context: context,
          labelText: dTexts.addColumLeft,
          iconPath: DIcons.insertColumn,
          isInputField: true,
          onSubmitted: (value) {
            final count = int.tryParse(value) ?? 1;
            context.tableProvider.addTableCell(
              action: TableAction.colLeft,
              count: count,
            );
          },
        ),
        const SizedBox(height: DSizes.spaceBtwItems),

        // Add Colum Right
        CommonRowWidget(
          context: context,
          labelText: dTexts.addColumRight,
          iconPath: DIcons.insertColumn,
          isInputField: true,
          onSubmitted: (value) {
            final count = int.tryParse(value) ?? 1;
            context.tableProvider.addTableCell(
              action: TableAction.colRight,
              count: count,
            );
          },
        ),
        const SizedBox(height: DSizes.spaceBtwItems),

        // Delete Colum
        CommonRowWidget(
          context: context,
          onPress: context.tableProvider.deleteSelectedColumns,
          labelText: dTexts.deleteColumn,
          iconPath: DIcons.deleteColumn,
          isInputField: false,
        ),
      ],
    );
  }
}
