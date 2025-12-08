import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paloma/controllers/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final RxBool _isUploadingPicture = false.obs;
  bool get isUploadingPicture => _isUploadingPicture.value;

  final Rx<DocumentSnapshot?> _userData = Rx<DocumentSnapshot?>(null);
  DocumentSnapshot? get userData => _userData.value;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserData();
    _loadThemePreference();
  }

  void _fetchUserData() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _firestore.collection('users').doc(userId).snapshots().listen((snapshot) {
      _userData.value = snapshot;
    });
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode.value);
  }

  Future<void> changeProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final userId = _auth.currentUser?.uid;

    if (image != null && userId != null) {
      _isUploadingPicture.value = true;

      try {
        final storageRef = _storage.ref().child('profile_pictures/$userId');
        await storageRef.putFile(File(image.path));

        final downloadUrl = await storageRef.getDownloadURL();

        await _firestore.collection('users').doc(userId).update({
          'pfp': downloadUrl,
        });

        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.find<HomeController>().fetchPosts();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update profile picture: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        _isUploadingPicture.value = false;
      }
    }
  }

  Future<void> updateUsername(String newUsername) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null || newUsername.isEmpty) {
      Get.snackbar(
        'Error',
        'Username cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: newUsername)
          .get();

      if (snapshot.docs.isNotEmpty && snapshot.docs.first.id != userId) {
        Get.snackbar(
          'Error',
          'Username already taken',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      await _firestore.collection('users').doc(userId).update({
        'username': newUsername.trim(),
      });
      Get.back();

      Get.snackbar(
        'Success',
        'Username updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.find<HomeController>().fetchPosts();
    } catch (e) {
      Get.back();

      Get.snackbar(
        'Error',
        'Failed to update username: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateBio(String newBio) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore.collection('users').doc(userId).update({'bio': newBio});

      Get.back();

      Get.snackbar(
        'Success',
        'Bio updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back();

      Get.snackbar(
        'Error',
        'Failed to update bio: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
