import 'package:flutter/services.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/utils/snackbar_toast/snack_bar.dart';

class CustomLabelSlider extends StatefulWidget {
  final String label;
  final double labelSize;
  final double value;
  final double min;
  final double max;
  final bool enabled;
  final String? disabledMessage;
  final ValueChanged<double> onChanged;

  const CustomLabelSlider({
    super.key,
    required this.label,
    this.labelSize = 110,
    required this.value,
    required this.min,
    required this.max,
    this.enabled = true,
    this.disabledMessage,
    required this.onChanged,
  });

  @override
  State<CustomLabelSlider> createState() => _CustomLabelSliderState();
}

class _CustomLabelSliderState extends State<CustomLabelSlider> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toStringAsFixed(1));
  }

  void _onTextChanged(String val) {
    if (val.isEmpty) return;

    final parsed = double.tryParse(val);
    if (parsed != null) {
      double finalValue = parsed;

      if (parsed > widget.max) {
        finalValue = widget.max;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.text = finalValue.toString();
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });
      }

      Future.delayed(const Duration(seconds: 1), () {
        widget.onChanged(finalValue.clamp(widget.min, widget.max));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.labelSize,
          child: Text(widget.label, style: context.bodyLarge),
        ),
        Expanded(
          child: Slider(
            min: widget.min,
            max: widget.max,
            value: widget.value,
            onChanged: (value) {
              if (widget.enabled) {
                widget.onChanged(value);
                _controller.text = value.toStringAsFixed(1);
              } else if (widget.disabledMessage != null) {
                DSnackBar.warning(title: widget.disabledMessage!);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          height: 30,
          child: TextBox(
            controller: _controller,
            textAlign: TextAlign.center,
            maxLines: 1,
            maxLength: 4,
            readOnly: !widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            onChanged: widget.enabled
                ? _onTextChanged
                : (_) {
                    if (widget.disabledMessage != null) {
                      DSnackBar.warning(title: widget.disabledMessage!);
                    }
                  },
          ),
        ),
      ],
    );
  }
}
