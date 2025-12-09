import 'package:flutter/material.dart';
import 'package:paloma/presentation/widgets/auth/login/email_form_field.dart';
import 'package:paloma/presentation/widgets/auth/login/forgot_password_button.dart';
import 'package:paloma/presentation/widgets/auth/login/login_button.dart';
import 'package:paloma/presentation/widgets/auth/login/password_form_field.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final bool isObscured;
  final ValueChanged<bool> onObscureChanged;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocus,
    required this.passwordFocus,
    required this.isObscured,
    required this.onObscureChanged,
    required this.onLogin,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          EmailFormField(
            controller: emailController,
            focusNode: emailFocus,
            nextFocus: passwordFocus,
          ),
          const SizedBox(height: 16),
          PasswordFormField(
            controller: passwordController,
            focusNode: passwordFocus,
            isObscured: isObscured,
            onObscureChanged: onObscureChanged,
            onSubmitted: onLogin,
          ),
          const SizedBox(height: 8),
          ForgotPasswordButton(onPressed: onForgotPassword),
          const SizedBox(height: 24),
          LoginButton(onPressed: onLogin),
        ],
      ),
    );
  }
}
