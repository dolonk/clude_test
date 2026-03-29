import 'package:flutter/foundation.dart';
import '../../../utils/constants/api_constants.dart';
import '../../../utils/network_section/dhttp_services.dart';
import 'package:grozziie/data_layer/models/print_model/dot_printer_model.dart';
import 'package:grozziie/data_layer/models/print_model/thermal_printer_model.dart';

class PrintModelRepository {
  Future<List<ThermalPrintModel>> fetchPrinterModel() async {
    try {
      final response = await DHttpServices.get(endpoint: AppUrl.printModelApi);
      return (response as List)
          .map((model) => ThermalPrintModel.fromJson(model))
          .toList();
    } catch (e) {
      debugPrint('API Error (fetchPrinterModel): $e');
      rethrow;
    }
  }

  Future<List<DotPrinterModel>> dotFetchPrinterModel() async {
    try {
      final response = await DHttpServices.get(
        endpoint: AppUrl.dotPrintModelApi,
      );
      return (response as List)
          .map((model) => DotPrinterModel.fromJson(model))
          .toList();
    } catch (e) {
      debugPrint('API Error (dotFetchPrinterModel): $e');
      rethrow;
    }
  }
}
