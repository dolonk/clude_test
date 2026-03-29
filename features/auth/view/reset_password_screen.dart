import 'login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../utils/constants/colors.dart';
import '../../../../localization/main_texts.dart';
import 'package:grozziie/utils/local_storage/local_data.dart';
import 'package:grozziie/features/dashboard/dashboard_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authProvider.resetPasswordWithCode(
      code: codeController.text.trim(),
      newPassword: newPasswordController.text,
    );

    if (!mounted) return;
    if (success) {
      final fEmail = await LocalData.getLocalData('F_EMAIL');
      final success = await authProvider.signIn(fEmail, newPasswordController.text);
      if (success && mounted) {
        Navigator.pushReplacement(context, FluentPageRoute(builder: (_) => const DashboardScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          /// LEFT SIDE
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: DColors.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 200, child: Image.asset('assets/logos/icon.png')),
                  const SizedBox(height: 10),

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

          /// RIGHT SIDE
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DTexts.instance.resetPassword,
                          style: TextStyle(fontSize: 24, color: DColors.primary, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Enter the verification code sent to ${widget.email} and choose a new password.",
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        /// CODE
                        TextBox(
                          controller: codeController,
                          placeholder: 'Verification Code',
                          padding: const EdgeInsets.all(8),
                        ),

                        const SizedBox(height: 12),

                        /// PASSWORD
                        PasswordBox(
                          controller: newPasswordController,
                          placeholder: 'New Password',
                          revealMode: PasswordRevealMode.peekAlways,
                          padding: const EdgeInsets.all(8),
                        ),

                        const SizedBox(height: 12),

                        /// CONFIRM PASSWORD
                        PasswordBox(
                          controller: confirmPasswordController,
                          placeholder: 'Confirm New Password',
                          revealMode: PasswordRevealMode.peekAlways,
                          padding: const EdgeInsets.all(8),
                        ),
                        const SizedBox(height: 20),

                        FilledButton(
                          onPressed: authProvider.isLoading ? null : () => _submit(authProvider),

                          child: authProvider.isLoading
                              ? const SizedBox(width: 14, height: 14, child: ProgressRing(strokeWidth: 2))
                              : Text(DTexts.instance.resetPassword),
                        ),
                        const SizedBox(height: 20),

                        /// LOGIN LINK
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Remembered your password? ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withValues(alpha: .4),
                                ),
                              ),
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(fontWeight: FontWeight.bold, color: DColors.primary),
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
