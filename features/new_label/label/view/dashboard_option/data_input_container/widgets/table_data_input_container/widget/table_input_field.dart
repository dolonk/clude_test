import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../../../../../../../../../utils/constants/sizes.dart';
import '../../../../../../../../../../utils/constants/label_global_variable.dart';

class TableInputField extends StatelessWidget {
  const TableInputField({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Column(
      children: [
        /// Text Tittle section
        ListTile(
          leading: const Icon(FluentIcons.navigate_back),
          title: Text(dTexts.content, style: context.title),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 42, right: 20),
          child: Column(
            children: [
              /// Text Constant Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      dTexts.tableInputField,
                      style: context.bodyLarge,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: DSizes.spaceBtwItems * 1.5),

              /// Text Input Field Section
              if (selectedTableIndex >= 0 &&
                  selectedTableIndex < textController.length)
                SizedBox(
                  height: 100.h,
                  child: TextBox(
                    focusNode: tableTextFocusNodes[selectedTableIndex],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    controller: textController[selectedTableIndex],
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    onChanged: (value) {
                      context.tableProvider.updateSelectedCellText(value);
                    },
                    onSubmitted: (value) {
                      context.tableProvider.saveCurrentTableState();
                    },
                  ),
                ),
              const SizedBox(height: DSizes.spaceBtwItems),
            ],
          ),
        ),
      ],
    );
  }
}
