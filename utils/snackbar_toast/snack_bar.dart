import '../extension/global_context.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DSnackBar {
  static void success({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _showInfoBar(
      title: title,
      message: message,
      severity: InfoBarSeverity.success,
      duration: duration,
    );
  }

  static void informationSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _showInfoBar(
      title: title,
      message: message,
      severity: InfoBarSeverity.info,
      duration: duration,
    );
  }

  static void errorSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _showInfoBar(
      title: title,
      message: message,
      severity: InfoBarSeverity.error,
      duration: duration,
    );
  }

  static void warning({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _showInfoBar(
      title: title,
      message: message,
      severity: InfoBarSeverity.warning,
      duration: duration,
    );
  }

  static void _showInfoBar({
    required String title,
    required String message,
    required InfoBarSeverity severity,
    required int duration,
  }) {
    final ctx = GlobalContext.context;

    if (ctx == null) {
      debugPrint('⚠️ No global context available for InfoBar!');
      return;
    }

    displayInfoBar(
      ctx,
      builder: (c, close) => InfoBar(
        title: Text(title),
        content: message.isNotEmpty ? Text(message) : null,
        severity: severity,
        isLong: true,
      ),
      alignment: Alignment.bottomCenter,
      duration: Duration(seconds: duration),
    );
  }
}
