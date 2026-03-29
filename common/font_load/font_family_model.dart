class FontData {
  final String name;
  final String ext;

  FontData({required this.name, required this.ext});

  factory FontData.fromJson(Map<String, dynamic> json) {
    return FontData(name: json['name'] as String, ext: json['ext'] as String);
  }
}
