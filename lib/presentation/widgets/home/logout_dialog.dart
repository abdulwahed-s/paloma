import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutDialog {
  static void show(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Get.defaultDialog(
      title: 'Logout',
      titleStyle: TextStyle(color: colorScheme.onSurface),
      middleText: 'Are you sure you want to logout?',
      middleTextStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      backgroundColor: colorScheme.surface,
      textConfirm: 'Logout',
      textCancel: 'Cancel',
      confirmTextColor: colorScheme.onError,
      cancelTextColor: colorScheme.onSurfaceVariant,
      buttonColor: colorScheme.error,
      onConfirm: () {
        Get.back();
        FirebaseAuth.instance.signOut();
      },
      onCancel: () {},
    );
  }
}
