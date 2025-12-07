import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paloma/data/repository/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repo;
  AuthController(this._repo);

  final _user = Rxn<User>();
  final _errorMessage = RxString('');
  final _isLoading = false.obs;
  final _isPasswordReset = false.obs;

  User? get user => _user.value;
  bool get isAuthenticated => _user.value != null;
  bool get isLoading => _isLoading.value;
  bool get isPasswordReset => _isPasswordReset.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _repo.userChanges.listen((user) {
      _user.value = user;
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    _isLoading.value = true;
    try {
      await _repo.signUpWithEmail(email, password, username);
      Get.back();
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = _mapError(e);
      Get.snackbar('Error', _errorMessage.value);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    _isLoading.value = true;
    try {
      await _repo.signInWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = _mapError(e);
      Get.snackbar('Error', _errorMessage.value);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading.value = true;
    try {
      await _repo.sendPasswordReset(email);
      _isPasswordReset.value = true;
      Get.snackbar('Success', 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = e.message ?? "Password reset failed";
      Get.snackbar('Error', _errorMessage.value);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
  }

  String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This account is disabled.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email already in use.';
      case 'weak-password':
        return 'Password too weak.';
      default:
        return e.message ?? 'Authentication error.';
    }
  }
}
