import 'dart:io';
import 'package:grozziie/utils/extension/global_context.dart';
import 'package:grozziie/utils/theme/fluent_theme.dart';
import 'package:provider/provider.dart';
import 'common/font_load/font_load.dart';
import 'features/auth/provider/auth_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'features/document_section/common/pick_file_picker_provider.dart';
import 'features/new_label/label/provider/main_label/label_printer_provider.dart';
import 'features/new_label/label/provider/widget/background_provider.dart';
import 'features/new_label/label/provider/widget/line_provider.dart';
import 'features/new_label/printer_type/dot/provider/dot_paper_size_provider.dart';
import 'features/new_label/printer_type/thermal/provider/thermal_paper_size_provider.dart';
import 'features/splash/splash_screen.dart';
import 'common/redo_undo/undo_redo_manager.dart';
import 'features/teamplated/server_teamplated/provider/server_teamplated_provider.dart';
import 'localization/l10n/app_localizations.dart';
import 'package:window_manager/window_manager.dart';
import 'localization/provider/language_provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'common/clipboard_service/clipboard_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common/print_settings/view/print_loading_overlay.dart';
import 'data_layer/local_server/templated_database_helper.dart';
import 'utils/local_storage/local_data.dart';
import 'common/print_settings/provider/printer_sdk_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/new_label/label/provider/widget/emoji_provider.dart';
import 'features/new_label/label/provider/widget/text_provider.dart';
import 'features/new_label/label/provider/widget/shape_provider.dart';
import 'features/new_label/label/provider/widget/table_provider.dart';
import 'features/new_label/label/provider/multiple_widget_provider.dart';
import 'features/new_label/label/provider/widget/barcode_provider.dart';
import 'features/new_label/label/provider/widget/qr_code_provider.dart';
import 'features/new_label/label/provider/widget/image_take_provider.dart';
import 'features/new_label/label/provider/common/common_function_provider.dart';
import 'features/teamplated/local_templated/provider/local_templated_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();

  // Store data
  await loadFontList();
  await LocalData.initDataToVariable();

  // Hide Default TitleBarStyle
  if (Platform.isWindows) {
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    });
  }

  doWhenWindowReady(() {
    const initialSize = Size(1100, 700);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });

  runApp(
    MultiProvider(
      providers: [
        /// GLOBAL PROVIDERS
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
        ChangeNotifierProvider<PrinterSdkProvider>(create: (_) => PrinterSdkProvider()),

        /// LABEL SECTION PROVIDERS
        ChangeNotifierProvider<LineProvide>(create: (_) => LineProvide()),
        ChangeNotifierProvider<ShapeProvider>(create: (_) => ShapeProvider()),
        ChangeNotifierProvider<EmojiProvider>(create: (_) => EmojiProvider()),
        ChangeNotifierProvider<TableProvider>(create: (_) => TableProvider()),
        ChangeNotifierProvider<QrCodeProvider>(create: (_) => QrCodeProvider()),
        ChangeNotifierProvider<BarcodeProvider>(create: (_) => BarcodeProvider()),
        ChangeNotifierProvider<ImageTakeProvider>(create: (_) => ImageTakeProvider()),
        ChangeNotifierProvider<TextEditingProvider>(create: (_) => TextEditingProvider()),
        ChangeNotifierProvider<LabelPrinterProvider>(create: (_) => LabelPrinterProvider()),
        ChangeNotifierProvider<CommonFunctionProvider>(create: (_) => CommonFunctionProvider()),
        ChangeNotifierProvider<MultipleWidgetProvider>(create: (_) => MultipleWidgetProvider()),
        ChangeNotifierProvider<LocalBackgroundProvider>(create: (_) => LocalBackgroundProvider()),

        /// LABEL SECTION GLOBAL PROVIDERS
        ChangeNotifierProvider(create: (_) => GlobalUndoRedoManager()),
        ChangeNotifierProvider(create: (_) => GlobalClipboardManager()),
        ChangeNotifierProvider<LocalTeamplatedProvider>(create: (_) => LocalTeamplatedProvider()),
        ChangeNotifierProvider<ServerTeamplatedProvider>(create: (_) => ServerTeamplatedProvider()),

        /// Document Section Providers
        ChangeNotifierProvider<FilePickerProvider>(create: (_) => FilePickerProvider()),
        ChangeNotifierProvider<DotPaperSizeProvider>(create: (_) => DotPaperSizeProvider()),
        ChangeNotifierProvider<ThermalPaperSizeProvider>(create: (_) => ThermalPaperSizeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    TemplateDatabaseHelper.initOpenDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      builder: (context, child) {
        return Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return FluentApp(
              title: "Grozziie",
              debugShowCheckedModeBanner: false,
              navigatorKey: GlobalContext.navigatorKey,
              builder: (context, child) {
                return PrintLoadingOverlay(
                  child: Overlay(
                    initialEntries: [OverlayEntry(builder: (context) => child ?? const SizedBox.shrink())],
                  ),
                );
              },
              theme: DFluentTheme.lightTheme,
              locale: languageProvider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('zh')],
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    TemplateDatabaseHelper.closeDatabase();
    super.dispose();
  }
}
