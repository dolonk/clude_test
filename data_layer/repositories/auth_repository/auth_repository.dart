import 'package:flutter/foundation.dart';
import '../../../utils/network_section/dhttp_services.dart';
import '../../models/user_model/user_model.dart';

class AuthRepository {
  Future<Map<String, dynamic>?> signUp(UserModel user) async {
    try {
      // Make the POST request
      final response = await DHttpServices.post(type: "p", endpoint: 'api/dev/user/signUp2', data: user.toJson());

      return response as Map<String, dynamic>?;
    } catch (error) {
      debugPrint("An unexpected error occurred. Please try again. ${error.toString()}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> signIn({required String email, required String password}) async {
    try {
      final data = {"userEmail": email, "userPassword": password};

      // Make the POST request
      final response = await DHttpServices.post(type: "p", endpoint: 'api/dev/user/signIn2', data: data);

      return response as Map<String, dynamic>?;
    } catch (error) {
      debugPrint("An unexpected error occurred. Please try again. ${error.toString()}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> forgotPassword({required String email}) async {
    try {
      final response = await DHttpServices.post(type: "p", endpoint: 'api/dev/user/forgot-password?email=$email');
      return response as Map<String, dynamic>?;
    } catch (error) {
      debugPrint("An unexpected error occurred. Please try again. ${error.toString()}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> resetPasswordWithCode({required String code, required String newPassword}) async {
    try {
      final response = await DHttpServices.post(
        type: "p",
        endpoint: 'api/dev/user/reset-password?code=$code&newPassword=$newPassword',
      );
      return response as Map<String, dynamic>?;
    } catch (error) {
      debugPrint("An unexpected error occurred. Please try again. ${error.toString()}");
      return null;
    }
  }
}
