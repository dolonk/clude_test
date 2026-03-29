import 'package:fluent_ui/fluent_ui.dart';
import '../../localization/main_texts.dart';
import '../../utils/constants/icons.dart';
import '../auth/view/login_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../../utils/constants/label_global_variable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:grozziie/utils/constants/colors.dart';
import 'package:grozziie/utils/extension/text_extension.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() => _isConnected = false);
    } else {
      setState(() {
        _isConnected = true;
        _navigateToNextScreen();
      });
    }
  }

  Future<void> _navigateToNextScreen() async {
    for (var i = 0; i < 500; i++) {
      await Future.delayed(const Duration(milliseconds: 1));
      setState(() => _progressValue = i / 100.0);
    }
    // Navigate to next screen here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUserLoggedIn) {
        Navigator.pushReplacement(context, FluentPageRoute(builder: (_) => const DashboardScreen()));
      } else {
        Navigator.pushReplacement(context, FluentPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Container(
      color: DColors.primary,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Logo Section
              SizedBox(width: 200, child: Image.asset(DIcons.appLogo, fit: BoxFit.fitWidth)),

              Text(dTexts.simplifyPrinting, style: context.bodyLarge.copyWith(color: DColors.white)),
              const SizedBox(height: 40),

              /// Connection Status
              _isConnected
                  ? Column(
                      children: [
                        ProgressBar(value: _progressValue),
                        const SizedBox(height: 3),
                        Text(dTexts.pMessage, style: context.bodyStrong.copyWith(color: Colors.white)),
                      ],
                    )
                  : Text(
                      dTexts.inMessage,
                      textAlign: TextAlign.center,
                      style: context.bodyLarge.copyWith(color: Colors.red),
                    ),
              const SizedBox(height: 60),

              /// Retry Button
              FilledButton(
                onPressed: _checkInternetConnection,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                ),
                child: Text(dTexts.getStart, style: context.bodyLarge.copyWith(color: DColors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
