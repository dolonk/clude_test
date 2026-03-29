class ThermalPrintModel {
  int? id;
  String? modelNo;
  int? defaultHight;
  int? defaultWidth;
  int? maxHight;
  int? maxWidth;
  String? pidNo;
  String? command;

  ThermalPrintModel({
    this.id,
    this.modelNo,
    this.defaultHight,
    this.defaultWidth,
    this.maxHight,
    this.maxWidth,
    this.pidNo,
    this.command,
  });

  ThermalPrintModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelNo = json['modelNo'];
    defaultHight = json['defaultHight'];
    defaultWidth = json['defaultWidth'];
    maxHight = json['maxHight'];
    maxWidth = json['maxWidth'];
    pidNo = json['pidNo'];
    command = json['command'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['modelNo'] = modelNo;
    data['defaultHight'] = defaultHight;
    data['defaultWidth'] = defaultWidth;
    data['maxHight'] = maxHight;
    data['maxWidth'] = maxWidth;
    data['pidNo'] = pidNo;
    data['command'] = command;
    return data;
  }
}
