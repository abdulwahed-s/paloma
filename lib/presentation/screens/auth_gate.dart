import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/controllers/auth_controller.dart';
import 'package:paloma/data/repository/auth_repository.dart';
import 'package:paloma/presentation/screens/auth/login.dart';
import 'package:paloma/presentation/screens/home/home_screen.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key}) {
    Get.put(AuthController(Get.find<AuthRepository>()));
  }

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      builder: (controller) {
        if (controller.isAuthenticated) {
          return HomePage();
        }
        return const LoginScreen();
      },
    );
  }
}
