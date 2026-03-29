class DotPrinterModel {
  final int? id;
  final String? pid;
  final String? modelNo;
  final String? type;
  final String? defaultHeight;
  final String? defaultWidth;
  final String? maxHeight;
  final String? maxWidth;
  final int? musicValue;
  final String? sliderImageMark;

  DotPrinterModel({
    this.id,
    this.pid,
    this.modelNo,
    this.type,
    this.defaultHeight,
    this.defaultWidth,
    this.maxHeight,
    this.maxWidth,
    this.musicValue,
    this.sliderImageMark,
  });

  factory DotPrinterModel.fromJson(Map<String, dynamic> json) {
    int? tryParseInt(dynamic value) {
      if (value == null || value == '') return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return DotPrinterModel(
      id: tryParseInt(json['id']),
      pid: json['PID']?.toString() ?? '',
      modelNo: json['modelNo']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      defaultHeight: json['defaultHeight']?.toString(),
      defaultWidth: json['defaultWidth']?.toString(),
      maxHeight: json['maxHeight']?.toString(),
      maxWidth: json['maxWidth']?.toString(),
      musicValue: tryParseInt(json['musicValue']) ?? 0,
      sliderImageMark: json['sliderImageMark']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'PID': pid,
      'modelNo': modelNo,
      'type': type,
      'defaultHeight': defaultHeight,
      'defaultWidth': defaultWidth,
      'maxHeight': maxHeight,
      'maxWidth': maxWidth,
      'musicValue': musicValue,
      'sliderImageMark': sliderImageMark,
    };
  }
}
