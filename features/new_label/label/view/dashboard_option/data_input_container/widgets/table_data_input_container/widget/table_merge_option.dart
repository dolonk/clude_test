import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../../../../../../../../../utils/constants/label_global_variable.dart';

class TableMergeOption extends StatelessWidget {
  const TableMergeOption({super.key, required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    if (selectedTableIndex < 0) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        /// Text Tittle section
        ListTile(
          leading: const Icon(FluentIcons.navigate_back),
          title: Text(dTexts.tableMergeOption, style: context.title),
        ),

        /// Table merge button
        Padding(
          padding: const EdgeInsets.only(left: 42, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 150.w,
                child: FilledButton(
                  onPressed: context.tableProvider.combineCells,
                  child: Text(
                    dTexts.combineCell,
                    maxLines: 1,
                    style: context.caption,
                  ),
                ),
              ),
              SizedBox(
                width: 100.w,
                child: FilledButton(
                  onPressed: context.tableProvider.splitCells,
                  child: Text(
                    dTexts.split,
                    maxLines: 1,
                    style: context.caption,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
