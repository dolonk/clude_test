import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grozziie/utils/extension/text_extension.dart';

class MenuItem extends StatelessWidget {
  final String? message;
  final dynamic icon; // IconData অথবা SVG asset path (String)
  final String? label;
  final VoidCallback? onPressed;
  final Color iconColor;

  const MenuItem({
    super.key,
    this.message,
    this.icon,
    this.label,
    this.onPressed,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;
    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Tooltip(
        message: message ?? '',
        displayHorizontally: true,
        style: const TooltipThemeData(
          textStyle: TextStyle(color: Colors.black),
          preferBelow: true,
        ),
        child: GestureDetector(
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null) _buildIcon(),
              if (label != null)
                Text(label!, style: context.caption.copyWith(color: iconColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon is IconData) {
      return Icon(icon as IconData, size: 24, color: iconColor);
    } else if (icon is String) {
      return SvgPicture.asset(
        icon as String,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    }
    return const SizedBox.shrink();
  }
}
