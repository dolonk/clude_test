import 'package:flutter/material.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import '../../../utils/constants/label_global_variable.dart';
import '../../../data_layer/models/user_model/user_model.dart';
import '../../../data_layer/repositories/auth_repository/auth_repository.dart';
import '../../../utils/local_storage/local_data.dart';
import '../../../localization/main_texts.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> checkAdmin(String email) async {
    const String adminEmail = 'admintht@gmail.com';

    if (email == adminEmail) {
      isAdmin = true;
      return true;
    } else {
      isAdmin = false;
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);

    bool isAdminUser = await checkAdmin(email);

    if (!isAdminUser) {
      return await customerLogin(email, password);
    } else {
      return await adminLogin(email, password);
    }
  }

  Future<bool> customerLogin(String email, String password) async {
    final response = await _authRepository.signIn(email: email, password: password);

    _setLoading(false);

    if (response != null) {
      isUserLoggedIn = true;
      await LocalData.saveLocalData<bool>('isUserLoggedIn', true);
      return true;
    } else {
      DSnackBar.errorSnackBar(title: DTexts.instance.loginFailed);
      return false;
    }
  }

  Future<bool> adminLogin(String email, String password) async {
    final response = await _authRepository.signIn(email: email, password: password);

    _setLoading(false);

    if (response != null) {
      isUserLoggedIn = true;
      await LocalData.saveLocalData<bool>('isUserLoggedIn', true);
      await LocalData.saveLocalData<bool>('isAdmin', true);
      return true;
    } else {
      DSnackBar.errorSnackBar(title: DTexts.instance.adminLoginFailed);
      return false;
    }
  }

  Future<bool> signUp(UserModel user) async {
    _setLoading(true);

    final response = await _authRepository.signUp(user);

    _setLoading(false);

    if (response != null) {
      isUserLoggedIn = true;
      await LocalData.saveLocalData<bool>('isUserLoggedIn', true);
      return true;
    } else {
      DSnackBar.errorSnackBar(title: DTexts.instance.registrationFailed);
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    _setLoading(true);
    final response = await _authRepository.forgotPassword(email: email);
    _setLoading(false);

    if (_isResponseSuccess(response)) {
      DSnackBar.success(title: DTexts.instance.forgotPasswordSuccess);
      await LocalData.saveLocalData<String>('F_EMAIL', email);
      return true;
    } else {
      final message = response?['message'] ?? DTexts.instance.forgotPasswordFailed;
      DSnackBar.errorSnackBar(title: message);
      return false;
    }
  }

  Future<bool> resetPasswordWithCode({required String code, required String newPassword}) async {
    _setLoading(true);
    final response = await _authRepository.resetPasswordWithCode(code: code, newPassword: newPassword);
    _setLoading(false);

    if (_isResponseSuccess(response)) {
      DSnackBar.success(title: DTexts.instance.passwordResetSuccess);
      return true;
    } else {
      final message = response?['message'] ?? DTexts.instance.passwordResetFailed;
      DSnackBar.errorSnackBar(title: message);
      return false;
    }
  }

  bool _isResponseSuccess(Map<String, dynamic>? response) {
    if (response == null) return false;

    final status = response['status'];
    final success = response['success'];
    final code = response['code'] ?? response['statusCode'];

    final isStatusOk = status == 'success' || status == 'ok';
    final isSuccessTrue = success == true;
    final isCodeOk = code == 200 || code == 201;

    return isStatusOk || isSuccessTrue || isCodeOk;
  }
}
