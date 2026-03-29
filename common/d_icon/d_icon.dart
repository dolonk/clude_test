import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that can display either an IconData or an SVG asset.
/// Use this instead of Icon() when you need to support both IconData and SVG paths.
class DIcon extends StatelessWidget {
  final dynamic icon; // IconData or SVG asset path (String)
  final double size;
  final Color? color;

  const DIcon(this.icon, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return SizedBox(width: size, height: size);
    }

    if (icon is IconData) {
      return Icon(icon as IconData, size: size, color: color);
    } else if (icon is String) {
      return SvgPicture.asset(
        icon as String,
        width: size,
        height: size,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      );
    }

    return SizedBox(width: size, height: size);
  }
}
