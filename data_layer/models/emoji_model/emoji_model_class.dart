import 'package:grozziie/utils/constants/api_constants.dart';

class EmojiModelClass {
  String? th;
  String? ms;
  String? fil;
  String? idn;
  String? vi;
  String? zh;
  String? en;
  int? id;
  String? icon;

  EmojiModelClass({
    this.th,
    this.ms,
    this.fil,
    this.idn,
    this.vi,
    this.zh,
    this.en,
    this.id,
  });

  EmojiModelClass.fromJson(Map<String, dynamic> json) {
    th = json['th'];
    ms = json['ms'];
    fil = json['fil'];
    idn = json['idn'];
    vi = json['vi'];
    zh = json['zh'];
    en = json['en'];
    id = json['id'];
    icon = json['icon'] != null
        ? '${AppUrl.baseUrl}/images/${json['icon']}'
        : 'assets/images/default_icon.png';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['th'] = th;
    data['ms'] = ms;
    data['fil'] = fil;
    data['idn'] = idn;
    data['vi'] = vi;
    data['zh'] = zh;
    data['en'] = en;
    data['id'] = id;
    data['icon'] = icon;
    return data;
  }
}
