import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/controllers/auth_controller.dart';

class ConfirmPasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final FocusNode focusNode;
  final bool isObscured;
  final ValueChanged<bool> onObscureChanged;
  final VoidCallback onSubmitted;

  const ConfirmPasswordFormField({
    super.key,
    required this.controller,
    required this.passwordController,
    required this.focusNode,
    required this.isObscured,
    required this.onObscureChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthController>();

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isObscured,
      textInputAction: TextInputAction.done,
      enabled: !authController.isLoading,
      onFieldSubmitted: (_) => onSubmitted(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Re-enter your password',
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
      ),
    );
  }
}
