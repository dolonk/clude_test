import '../../constants/colors.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DFluentTextTheme {
  DFluentTextTheme._();

  static Typography fluentTypography = const Typography.raw(
    // Display
    display: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: DColors.dark,
    ),

    // Titles
    titleLarge: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: DColors.dark,
      overflow: TextOverflow.ellipsis,
    ),
    title: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: DColors.dark,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: DColors.dark,
      overflow: TextOverflow.ellipsis,
    ),

    // Body
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: DColors.textPrimary,
      overflow: TextOverflow.ellipsis,
    ),
    bodyStrong: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: DColors.textPrimary,
      overflow: TextOverflow.ellipsis,
    ),
    body: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: DColors.textSecondary,
      overflow: TextOverflow.ellipsis,
    ),

    // Caption
    caption: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
