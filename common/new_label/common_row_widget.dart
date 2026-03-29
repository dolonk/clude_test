import 'package:flutter/services.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../utils/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grozziie/utils/extension/text_extension.dart';

class CommonRowWidget extends StatefulWidget {
  const CommonRowWidget({
    super.key,
    required this.context,
    required this.labelText,
    required this.iconPath,
    required this.isInputField,
    this.onPress,
    this.onSubmitted,
  });

  final BuildContext context;
  final String labelText;
  final String iconPath;
  final bool isInputField;
  final VoidCallback? onPress;
  final Function(String)? onSubmitted;

  @override
  State<CommonRowWidget> createState() => _CommonRowWidgetState();
}

class _CommonRowWidgetState extends State<CommonRowWidget> {
  String currentValue = '1';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 42, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InfoLabel(label: widget.labelText, labelStyle: context.bodyLarge),
          widget.isInputField
              ? SizedBox(
                  width: 100,
                  height: 34,
                  child: TextBox(
                    placeholder: '1',
                    placeholderStyle: context.bodyLarge,
                    textAlign: TextAlign.center,
                    style: context.bodyLarge,
                    maxLines: 1,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      currentValue = value;
                    },
                    suffix: GestureDetector(
                      onTap: () {
                        widget.onSubmitted!(currentValue);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: ImageIcon(
                          AssetImage(widget.iconPath),
                          size: 25,
                          color: DColors.primary,
                        ),
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: widget.onPress,
                  child: Image.asset(
                    widget.iconPath,
                    width: 25.w,
                    height: 25.h,
                  ),
                ),
        ],
      ),
    );
  }
}
