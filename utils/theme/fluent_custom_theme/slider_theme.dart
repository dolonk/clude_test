import '../../constants/colors.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DSliderTheme {
  DSliderTheme._();

  static final SliderThemeData sliderTheme = SliderThemeData(
    activeColor: WidgetStateProperty.all(DColors.primary),
    thumbColor: WidgetStateProperty.all(DColors.primary),
  );
}
