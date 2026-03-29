import 'package:flutter/services.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/utils/extension/text_extension.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    super.key,
    required this.tittle,
    this.controller,
    this.onChange,
    this.onSubmitted,
  });

  final String tittle;
  final TextEditingController? controller;
  final Function(int)? onChange;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text('$tittle:', style: context.bodyLarge),
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextBox(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: WidgetStateProperty.all(
                  BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    onChange?.call(0);
                  } else {
                    try {
                      final intValue = int.parse(value);
                      onChange?.call(intValue);
                    } catch (_) {
                      onChange?.call(0);
                    }
                  }
                },
                onSubmitted: onSubmitted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
