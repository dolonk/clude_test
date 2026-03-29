class UserModel {
  final String userName;
  final String userEmail;
  final String userPassword;
  final String deviceType;
  final String role;

  UserModel({
    required this.userName,
    required this.userEmail,
    required this.userPassword,
    this.deviceType = 'desktop',
    this.role = 'user',
  });

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "userEmail": userEmail,
      "userPassword": userPassword,
      "deviceType": deviceType,
      "role": role,
    };
  }
}
