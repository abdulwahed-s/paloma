import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/controllers/auth_controller.dart';

class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: authController.isLoading ? null : onPressed,
        child: const Text('Forgot password?'),
      ),
    );
  }
}
