import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DotPrintModelClass {
  String? defaultHeight;
  String? type;
  String? musicValue;

  DotPrintModelClass({this.defaultHeight, this.type, this.musicValue});

  DotPrintModelClass.fromJson(Map<String, dynamic> json) {
    defaultHeight = json['defaultHeight'];
    type = json['type'];
    musicValue = json['musicValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['defaultHeight'] = defaultHeight;
    data['type'] = type;
    data['musicValue'] = musicValue;
    return data;
  }

  static Future<void> saveToLocal(List<DotPrintModelClass> models) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedModels = models.map((model) => jsonEncode(model.toJson())).toList();
    await prefs.setStringList('DotModels', encodedModels);
  }

  static Future<List<DotPrintModelClass>> loadFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedModels = prefs.getStringList('DotModels');
    if (encodedModels != null) {
      return encodedModels.map((encodedModel) => DotPrintModelClass.fromJson(jsonDecode(encodedModel))).toList();
    }
    return [];
  }
}
