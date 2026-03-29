import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import '../../../common/custom_body/custom_body.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import 'package:provider/provider.dart';
import '../../../data_layer/models/user_model/user_model.dart';
import '../../../../localization/main_texts.dart';
import '../../dashboard/dashboard_screen.dart';
import '../provider/auth_provider.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBody(
      child: NavigationView(
        content: Center(
          child: CustomSplitScreenRegDialogContent(
            onSuccess: () {
              Navigator.pushReplacement(context, FluentPageRoute(builder: (_) => const DashboardScreen()));
            },
          ),
        ),
      ),
    );
  }
}

class CustomSplitScreenRegDialogContent extends StatefulWidget {
  final VoidCallback? onSuccess;
  const CustomSplitScreenRegDialogContent({super.key, this.onSuccess});

  @override
  State<CustomSplitScreenRegDialogContent> createState() => _CustomSplitScreenRegDialogContentState();
}

class _CustomSplitScreenRegDialogContentState extends State<CustomSplitScreenRegDialogContent> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
      child: Row(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
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
                    "Create New Account",
                    style: TextStyle(fontSize: 24, color: DColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),

                  TextBox(
                    controller: usernameController,
                    placeholder: 'Username',
                    padding: const EdgeInsets.all(8),
                    decoration: WidgetStateProperty.all(
                      BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                        color: Colors.grey.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

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
                  const SizedBox(height: 16.0),

                  PasswordBox(
                    controller: confirmPasswordController,
                    placeholder: 'Confirm Password',
                    revealMode: PasswordRevealMode.peekAlways,
                    padding: const EdgeInsets.all(8),
                    decoration: WidgetStateProperty.all(
                      BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
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
                                final username = usernameController.text.trim();
                                final email = emailController.text.trim();
                                final password = passwordController.text;
                                final confirmPassword = confirmPasswordController.text;

                                if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                                  DSnackBar.errorSnackBar(title: "Please fill in all fields.");
                                  return;
                                }

                                if (password != confirmPassword) {
                                  DSnackBar.errorSnackBar(title: "Passwords do not match.");
                                  return;
                                }

                                final userModel = UserModel(
                                  userName: username,
                                  userEmail: email,
                                  userPassword: password,
                                );

                                final success = await authProvider.signUp(userModel);
                                if (success && context.mounted) {
                                  if (widget.onSuccess != null) {
                                    widget.onSuccess!();
                                  }
                                }
                              },
                        child: authProvider.isLoading
                            ? const SizedBox(width: 14, height: 14, child: ProgressRing(strokeWidth: 2.0))
                            : Text(DTexts.instance.register),
                      );
                    },
                  ),
                  SizedBox(height: 12.0),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already Have account? ",
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
                              Navigator.pushReplacement(context, FluentPageRoute(builder: (_) => const LoginScreen()));
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
