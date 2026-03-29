import '../../constants/colors.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DCheckBoxTheme {
  DCheckBoxTheme._();

  static final checkBoxThemeData = CheckboxThemeData(
    checkedDecoration: WidgetStateProperty.all(
      const BoxDecoration(
        color: DColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
    ),
    checkedIconColor: WidgetStateProperty.all(DColors.white),
  );
}
