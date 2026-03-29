import '../env.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../extension/global_context.dart';
import '../snackbar_toast/snack_bar.dart';
import 'package:flutter/foundation.dart';
import '../../localization/l10n/app_localizations.dart';

class DHttpServices {
  static String _getBaseUrl(String? type) {
    String baseUrl = (type != null && type.toLowerCase() == 'p')
        ? Env.pBaseUrl
        : Env.zBaseUrl;
    // ensure no double slashes when endpoint does not start with a slash
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    return baseUrl;
  }

  // Helper method to make a GET request
  static Future<dynamic> get({String? type, required String endpoint}) async {
    final String cleanEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;
    final url = '${_getBaseUrl(type)}/$cleanEndpoint';
    final response = await http.get(Uri.parse(url));
    return _handleResponse(response, url);
  }

  // Helper method to make a POST request
  static Future<dynamic> post({
    String? type,
    required String endpoint,
    dynamic data,
  }) async {
    final String cleanEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;
    final url = '${_getBaseUrl(type)}/$cleanEndpoint';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response, url);
  }

  // Helper method to make a PUT request
  static Future<dynamic> put({
    String? type,
    required String endpoint,
    dynamic data,
  }) async {
    final String cleanEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;
    final url = '${_getBaseUrl(type)}/$cleanEndpoint';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response, url);
  }

  // Helper method to make a DELETE request
  static Future<dynamic> delete({
    String? type,
    required String endpoint,
  }) async {
    final String cleanEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;
    final url = '${_getBaseUrl(type)}/$cleanEndpoint';
    final response = await http.delete(Uri.parse(url));
    return _handleResponse(response, url);
  }

  // Handle the HTTP response
  static dynamic _handleResponse(http.Response response, String url) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return null;
    } else {
      debugPrint('HTTP Exception for $url: ${response.statusCode}');
      ServerExceptionHandler.handleError(response);
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  }
}

class ServerExceptionHandler {
  static void handleError(http.Response response) {
    var globalKey = GlobalContext.navigatorKey.currentContext;
    if (globalKey == null) {
      DSnackBar.errorSnackBar(title: "HTTP Error: ${response.statusCode}");
      return;
    }
    final globalContext = globalKey;

    String message;
    switch (response.statusCode) {
      case 400:
        message = AppLocalizations.of(globalContext)!.status400;
        break;
      case 401:
        message = "${AppLocalizations.of(globalContext)!.status401}.";
        break;
      case 404:
        message = AppLocalizations.of(globalContext)!.status404;
        break;
      case 409:
        message = "${AppLocalizations.of(globalContext)!.status409}.";
        break;
      case 429:
        message = "${AppLocalizations.of(globalContext)!.status429}.";
        break;
      case 500:
        message = "${AppLocalizations.of(globalContext)!.status500}.";
        break;
      default:
        message = "${AppLocalizations.of(globalContext)!.status500}.";
        break;
    }
    DSnackBar.errorSnackBar(title: message);
  }
}
