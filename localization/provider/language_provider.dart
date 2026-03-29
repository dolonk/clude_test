import 'dart:ui';
import 'package:fluent_ui/fluent_ui.dart';
import '../../utils/constants/colors.dart';
import '../../localization/main_texts.dart';
import '../../common/font_load/font_load.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/utils/local_storage/local_data.dart';
import 'package:grozziie/utils/env.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  Map<String, String> fontTranslations = {};

  LanguageProvider() {
    initialData();
  }

  Future<void> initialData() async {
    _locale = await _getInitialLocale();
    fontTranslations = getFontsForLanguage(_locale.languageCode);
    Env.updateBaseUrl(_locale.languageCode);
    notifyListeners();
  }

  // Change locale manually and save to local storage
  void _changeLocale(Locale newLocale) async {
    _locale = newLocale;

    LocalData.saveLocalData<String>("LanguageCode", newLocale.languageCode);
    await loadFontList();
    fontTranslations = getFontsForLanguage(newLocale.languageCode);
    Env.updateBaseUrl(newLocale.languageCode);
    notifyListeners();
  }

  // Load the saved locale or fallback to system locale
  static Future<Locale> _getInitialLocale() async {
    final savedLanguageCode =
        await LocalData.getLocalData('LanguageCode') ?? 'en';

    // saved locale if it exists
    if (savedLanguageCode != null) {
      return Locale(savedLanguageCode);
    }

    // Otherwise, return the system locale
    final Locale systemLocale = PlatformDispatcher.instance.locale;
    if (systemLocale.languageCode == 'zh') {
      return const Locale('zh');
    } else {
      return const Locale('en');
    }
  }

  // Chinese fonts
  final Map<String, String> chineseFonts = {
    "chinese_msyh": "微软雅黑",
    "chinese_simfang": "仿宋",
    "HanYiYuanDieTiJian-1": "汉仪圆蝶体简",
    "HarmonyOS_Sans_Medium_Italic": "鸿蒙中斜体",
    "Kai_Ti_GB2312": "楷体",
    "SAMENTtrial": "试用字体",
    "simkai": "简楷体",
    "SIMSUN": "宋体",
    "Source_Han_Sans_CN_Regular": "思源黑体",
    "Source_Han_Serif_CN_Heavy": "思源宋体",
  };

  // Other fonts
  final Map<String, String> defaultFonts = {
    "JosefinSans_Regular": "JosefinSans",
    "Arimo_Regular": "Arimo",
    "BebasNeue-Regular": "BebasNeue",
    "Comfortaa-Regular": "Comfortaa",
    "DMSans_18pt-Regular": "DMSans",
    "Figtree-Regular": "Figtree",
    "FjallaOne-Regular": "FjallaOne",
    "Inter_18pt-Regular": "Inter",
    "Jost-Regular": "Jost",
    "Lato-Regular": "Lato",
    "Manrope-Regular": "Manrope",
    "Montserrat-Regular": "Montserrat",
    "NotoSans-Regular": "NotoSans",
    "OpenSans-Regular": "OpenSans",
  };

  Map<String, String> getFontsForLanguage(String languageCode) {
    return languageCode == 'zh' ? chineseFonts : defaultFonts;
  }

  // Show language selection dialog
  void showLanguageDialog(BuildContext context) {
    final dTexts = DTexts.instance;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ContentDialog(
          title: Center(
            child: Text("Select Language", style: context.titleLarge),
          ),
          content: SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(dTexts.english),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: DColors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onPressed: () {
                      _changeLocale(const Locale('en'));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(dTexts.chinese),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: DColors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onPressed: () {
                      _changeLocale(const Locale('zh'));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: Button(
                child: Text(
                  dTexts.close,
                  style: context.caption.copyWith(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
