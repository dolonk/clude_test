import 'package:fluent_ui/fluent_ui.dart';
import 'fluent_custom_theme/text_theme.dart';
import 'fluent_custom_theme/button_theme.dart';
import 'fluent_custom_theme/slider_theme.dart';
import 'fluent_custom_theme/checkbox_theme.dart';
import 'package:grozziie/utils/constants/colors.dart';

class DFluentTheme {
  DFluentTheme._();

  static FluentThemeData lightTheme = FluentThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: DColors.bSecondary,
    buttonTheme: DButtonTheme.fluentTheme,
    toggleButtonTheme: DButtonTheme.toggleButtonTheme,
    sliderTheme: DSliderTheme.sliderTheme,
    checkboxTheme: DCheckBoxTheme.checkBoxThemeData,
    typography: DFluentTextTheme.fluentTypography,
    fontFamily: 'Poppins',
  );
}
