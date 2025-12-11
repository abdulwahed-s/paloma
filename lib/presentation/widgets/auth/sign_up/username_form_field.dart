import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/controllers/auth_controller.dart';

class UsernameFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;

  const UsernameFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthController>();

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      enabled: !authController.isLoading,
      textCapitalization: TextCapitalization.none,
      onFieldSubmitted: (_) => nextFocus.requestFocus(),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a username';
        }
        if (value.trim().length < 3) {
          return 'Username must be at least 3 characters';
        }
        if (value.trim().length > 20) {
          return 'Username must be less than 20 characters';
        }
        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
          return 'Username can only contain letters, numbers, and underscores';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Username',
        hintText: 'Choose a unique username',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
    );
  }
}
