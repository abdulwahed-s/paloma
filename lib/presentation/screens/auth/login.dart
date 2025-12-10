import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/controllers/auth_controller.dart';
import 'package:paloma/presentation/widgets/auth/login/login_form.dart';
import 'package:paloma/presentation/widgets/auth/login/login_header.dart';
import 'package:paloma/presentation/widgets/auth/login/or_divider.dart';
import 'package:paloma/presentation/widgets/auth/login/sign_up_prompt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final emailFocus = FocusNode();
  final passFocus = FocusNode();
  bool isObscured = true;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  const SizedBox(height: 48),
                  LoginForm(
                    formKey: _formKey,
                    emailController: emailC,
                    passwordController: passC,
                    emailFocus: emailFocus,
                    passwordFocus: passFocus,
                    isObscured: isObscured,
                    onObscureChanged: (value) =>
                        setState(() => isObscured = value),
                    onLogin: _handleLogin,
                    onForgotPassword: _handleForgotPassword,
                  ),
                  const SizedBox(height: 32),
                  const OrDivider(),
                  const SizedBox(height: 24),
                  SignUpPrompt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _authController.signIn(emailC.text.trim(), passC.text);
    }
  }

  void _handleForgotPassword() {
    final email = emailC.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address first',
        backgroundColor: Theme.of(context).colorScheme.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      emailFocus.requestFocus();
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Theme.of(context).colorScheme.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      emailFocus.requestFocus();
      return;
    }

    _authController.resetPassword(email);
  }
}
