import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/label_global_variable.dart';

class LocalData {
  LocalData._();

  static double thSharedPaperWidth = 100;
  static double thSharedPaperHeight = 150;
  static double dotSharedPaperWidth = 203;
  static double dotSharedPaperHeight = 279;

  /// Save any type of data automatically
  static Future<void> saveLocalData<T>(String key, T value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      debugPrint('Saving data: $key = $value');

      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(key, value);
      } else {
        throw Exception("Unsupported data type: ${value.runtimeType}");
      }
    } catch (e) {
      debugPrint("Error saving data: $e");
    }
  }

  /// Retrieve data safely
  static Future<T?> getLocalData<T>(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var value = prefs.get(key);
      return value is T ? value : null;
    } catch (e) {
      debugPrint("Error retrieving data: $e");
      return null;
    }
  }

  /// Initialize all local data
  static Future<void> initDataToVariable() async {
    try {
      debugPrint('Initializing local data...');
      thSharedPaperWidth =
          await getLocalData<double>('thSharedPaperWidth') ?? 100.0;
      thSharedPaperHeight =
          await getLocalData<double>('thSharedPaperHeight') ?? 150.0;
      dotSharedPaperWidth =
          await getLocalData<double>('dotSharedPaperWidth') ?? 203.0;
      dotSharedPaperHeight =
          await getLocalData<double>('dotSharedPaperHeight') ?? 279.0;
      isUserLoggedIn = await getLocalData<bool>('isUserLoggedIn') ?? false;
      isAdmin = await getLocalData<bool>('isAdmin') ?? false;
    } catch (e) {
      debugPrint("Error initializing local data: $e");
    }
  }

  /// Clear all local data safely
  static Future<void> destroyer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Future.delayed(const Duration(seconds: 3));
      debugPrint("All local data cleared successfully.");
    } catch (e) {
      debugPrint("Error clearing local data: $e");
    }
  }
}
