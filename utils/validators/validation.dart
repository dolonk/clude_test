class DValidation {
  /// Empty Text Validation
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Email validation
  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email is required.';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }

    return null;
  }

  /// Password validation
  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // check for number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // check for special number
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  /// Phone number validation
  static String? validationPhoneNumberPk(String? value) {
    if (value!.isEmpty) {
      return 'phone number is required.';
    }

    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required)';
    }

    return null;
  }

  /// Phone number validation
  static String? validationPhoneNumberBd(String? value) {
    if (value!.isEmpty) {
      return 'phone number is required.';
    }

    final phoneRegExp = RegExp(r'^(?:\+8801|8801|01)?\d{9}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format. A Bangladeshi phone number must have 11 digits with an optional +8801, 8801, or 01';
    }

    return null;
  }
}
