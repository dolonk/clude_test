import 'dart:convert';
import '../../utils/local_storage/local_data.dart';
import 'font_family_model.dart';
import 'package:flutter/services.dart';
import 'package:fluent_ui/fluent_ui.dart';

List<FontData> allFonts = [];
final Set<String> loadedFonts = {};
String languageCode = 'en';

Future<void> loadFontList() async {
  String fontListJson = 'assets/fonts/global_font/fonts.json';

  languageCode = await LocalData.getLocalData('LanguageCode') ?? 'en';
  if (languageCode == 'zh') {
    fontListJson = 'assets/fonts/china_font/fonts.json';
  } else {
    fontListJson = 'assets/fonts/global_font/fonts.json';
  }

  final String jsonString = await rootBundle.loadString(fontListJson);
  final List<dynamic> fontsJson = json.decode(jsonString)['fonts'];

  allFonts = fontsJson.map((json) => FontData.fromJson(json)).toList();

  for (final font in allFonts) {
    if (!loadedFonts.contains(font.name)) {
      await loadFontFromJson(font);
      loadedFonts.add(font.name);
    }
  }
}

Future<void> loadFontFromJson(FontData fontData) async {
  try {
    String fontListJson =
        'assets/fonts/global_font/${fontData.name}.${fontData.ext}';

    if (languageCode == 'zh') {
      fontListJson = 'assets/fonts/china_font/${fontData.name}.${fontData.ext}';
    } else {
      fontListJson =
          'assets/fonts/global_font/${fontData.name}.${fontData.ext}';
    }

    final fontLoader = FontLoader(fontData.name);
    fontLoader.addFont(rootBundle.load(fontListJson));
    await fontLoader.load();
    debugPrint('Loaded font form json: ${fontData.name}');
  } catch (e) {
    debugPrint('❌ Failed to load ${fontData.name}: $e');
  }
}
