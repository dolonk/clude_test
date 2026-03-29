class Env {
  Env._();
  static const String pBaseUrl = 'https://grozziieget.zjweiting.com:3091/CustomerService-Chat';
  static String zBaseUrl = 'https://grozziieget.zjweiting.com:8033/tht/';

  static void updateBaseUrl(String languageCode) {
    if (languageCode == 'zh') {
      zBaseUrl = 'https://jiapuv.com:8033/tht/';
    } else {
      zBaseUrl = 'https://grozziieget.zjweiting.com:8033/tht/';
    }
  }
}
