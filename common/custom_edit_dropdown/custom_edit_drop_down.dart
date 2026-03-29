import 'package:flutter/services.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../localization/main_texts.dart';
import 'package:grozziie/utils/extension/text_extension.dart';

class CustomEditableDropdown extends StatefulWidget {
  final String initialValue;
  final List<String> items;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? placeholder;
  final String defaultValue;

  const CustomEditableDropdown({
    super.key,
    required this.initialValue,
    required this.items,
    this.onChanged,
    this.onFieldSubmitted,
    this.placeholder,
    this.defaultValue = '15',
  });

  @override
  State<CustomEditableDropdown> createState() => _CustomEditableDropdownState();
}

class _CustomEditableDropdownState extends State<CustomEditableDropdown> {
  final FlyoutController _flyoutController = FlyoutController();

  //int get _minValue => int.tryParse(widget.items.first) ?? 1;
  int get _minValue => 1;
  int get _maxValue => int.tryParse(widget.items.last) ?? 100;

  void _validateAndSubmit(String value) {
    final dTexts = DTexts.instance;
    final parsed = int.tryParse(value);

    if (parsed == null || parsed < _minValue || parsed > _maxValue) {
      showDialog(
        context: context,
        builder: (context) => ContentDialog(
          content: Text(
            dTexts.fontSizeMustBeNumber(
              min: _minValue.toString(),
              max: _maxValue.toString(),
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(dTexts.close),
            ),
          ],
        ),
      );
      widget.onChanged?.call(widget.defaultValue);
    } else {
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextBox(
        maxLines: 1,
        maxLength: 3,
        placeholder: widget.placeholder,
        controller: TextEditingController(text: widget.initialValue),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: context.body,
        onSubmitted: _validateAndSubmit,
        suffix: FlyoutTarget(
          controller: _flyoutController,
          child: IconButton(
            icon: const Icon(FluentIcons.chevron_down, size: 20),
            onPressed: () {
              _flyoutController.showFlyout(
                placementMode: FlyoutPlacementMode.bottomRight,
                builder: (context) {
                  return SizedBox(
                    height: 300,
                    child: MenuFlyout(
                      items: widget.items.map((item) {
                        return MenuFlyoutItem(
                          text: Text(item),
                          onPressed: () {
                            widget.onChanged?.call(item);
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
