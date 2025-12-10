import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/controllers/auth_controller.dart';

class PasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isObscured;
  final ValueChanged<bool> onObscureChanged;
  final VoidCallback onSubmitted;

  const PasswordFormField({
    super.key,
    required this.controller,
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
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
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