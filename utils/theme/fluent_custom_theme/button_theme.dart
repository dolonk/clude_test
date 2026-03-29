import '../../constants/colors.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DButtonTheme {
  DButtonTheme._();

  static final ButtonThemeData fluentTheme = ButtonThemeData(
    filledButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(DColors.primary),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      ),
    ),
    iconButtonStyle: ButtonStyle(iconSize: WidgetStateProperty.all(22)),
  );

  static final ToggleButtonThemeData toggleButtonTheme = ToggleButtonThemeData(
    checkedButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(DColors.primary),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    ),
  );
}
