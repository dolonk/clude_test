import 'package:flutter/gestures.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/utils/constants/colors.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:provider/provider.dart';
import '../../../common/custom_body/custom_body.dart';
import '../../dashboard/dashboard_screen.dart';
import '../provider/auth_provider.dart';
import 'forgot_password_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBody(
      child: NavigationView(
        content: Center(
          child: CustomSplitScreenLoginDialogContent(
            onSuccess: () {
              Navigator.pushReplacement(context, FluentPageRoute(builder: (_) => const DashboardScreen()));
            },
          ),
        ),
      ),
    );
  }
}

class CustomSplitScreenLoginDialogContent extends StatefulWidget {
  final VoidCallback? onSuccess;
  const CustomSplitScreenLoginDialogContent({super.key, this.onSuccess});

  @override
  State<CustomSplitScreenLoginDialogContent> createState() => _CustomSplitScreenLoginDialogContentState();
}

class _CustomSplitScreenLoginDialogContentState extends State<CustomSplitScreenLoginDialogContent> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                color: DColors.primary,
              ),
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

          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 24, color: DColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),

                  TextBox(
                    controller: emailController,
                    placeholder: 'Email',
                    padding: const EdgeInsets.all(8),
                    decoration: WidgetStateProperty.all(
                      BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                        color: Colors.grey.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  PasswordBox(
                    controller: passwordController,
                    placeholder: 'Password',
                    revealMode: PasswordRevealMode.peekAlways,
                    padding: const EdgeInsets.all(8),
                    decoration: WidgetStateProperty.all(
                      BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                        color: Colors.grey.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            FluentPageRoute(builder: (_) => const ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          'Forget Password?',
                          style: TextStyle(fontWeight: FontWeight.w500, color: DColors.primary, fontSize: 14),
                        ),
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
                                final password = passwordController.text;

                                if (email.isEmpty || password.isEmpty) return;

                                final success = await authProvider.signIn(email, password);
                                if (success && context.mounted) {
                                  if (widget.onSuccess != null) {
                                    widget.onSuccess!();
                                  }
                                }
                              },
                        child: authProvider.isLoading
                            ? const SizedBox(width: 14, height: 14, child: ProgressRing(strokeWidth: 2.0))
                            : Text(DTexts.instance.logIn),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't Have account? ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black.withValues(alpha: 0.4),
                          ),
                        ),
                        TextSpan(
                          text: 'Create Account',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DColors.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                FluentPageRoute(builder: (_) => const RegistrationScreen()),
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
    );
  }
}
