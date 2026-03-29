import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/utils/theme/fluent_custom_theme/text_theme.dart';

extension FluentTextStyling on BuildContext {
  Typography get _typography => DFluentTextTheme.fluentTypography;

  // Display
  TextStyle get display => _typography.display!;

  // Titles
  TextStyle get titleLarge => _typography.titleLarge!;
  TextStyle get title => _typography.title!;
  TextStyle get subtitle => _typography.subtitle!;

  // Body
  TextStyle get body => _typography.body!;
  TextStyle get bodyStrong => _typography.bodyStrong!;
  TextStyle get bodyLarge => _typography.bodyLarge!;

  // Caption
  TextStyle get caption => _typography.caption!;
}
