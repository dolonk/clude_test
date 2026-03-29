import 'login_screen.dart';
import 'reset_password_screen.dart';
import 'package:flutter/gestures.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../utils/constants/colors.dart';
import '../../../../localization/main_texts.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import 'package:grozziie/common/custom_body/custom_body.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomBody(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: DColors.primary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Simplify printing",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(width: 300, child: Image.asset('assets/logos/printer.png')),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot Password",
                      style: TextStyle(fontSize: 24, color: DColors.primary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Please enter your email to receive a verification code.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20.0),
                    TextBox(
                      controller: emailController,
                      placeholder: 'Email',
                      padding: const EdgeInsets.all(8),
                      decoration: WidgetStateProperty.all(
                        BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          color: Colors.grey.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return FilledButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  final email = emailController.text.trim();

                                  if (email.isEmpty) {
                                    DSnackBar.errorSnackBar(title: "Please enter your email.");
                                    return;
                                  }

                                  final success = await authProvider.forgotPassword(email: email);
                                  if (success && context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      FluentPageRoute(builder: (_) => ResetPasswordScreen(email: email)),
                                    );
                                  }
                                },
                          child: authProvider.isLoading
                              ? const SizedBox(width: 14, height: 14, child: ProgressRing(strokeWidth: 2.0))
                              : Text(DTexts.instance.sendVerificationCode),
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Remembered your password? ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black.withValues(alpha: 0.4),
                            ),
                          ),
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DColors.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  FluentPageRoute(builder: (_) => const LoginScreen()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
