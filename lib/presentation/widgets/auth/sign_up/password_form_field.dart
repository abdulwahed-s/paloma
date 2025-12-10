import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/controllers/auth_controller.dart';

class SignUpPasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final bool isObscured;
  final ValueChanged<bool> onObscureChanged;

  const SignUpPasswordFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocus,
    required this.isObscured,
    required this.onObscureChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthController>();

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isObscured,
      textInputAction: TextInputAction.next,
      enabled: !authController.isLoading,
      onFieldSubmitted: (_) => nextFocus.requestFocus(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
          return 'Password must contain uppercase, lowercase, and number';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Create a strong password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => onObscureChanged(!isObscured),
          tooltip: isObscured ? 'Show password' : 'Hide password',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        helperText: 'Must be 8+ chars with uppercase, lowercase, and number',
        helperMaxLines: 2,
      ),
    );
  }
}
