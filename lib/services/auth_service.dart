import 'package:firebase_auth/firebase_auth.dart';

import 'package:tuku/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> register({
    required String email,
    required String password,
    required String tasmiaGivenName,
    required String username,
  }) async {
    final normalizedUsername = username
        .trim()
        .toLowerCase()
        .replaceFirst('@', '');

    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('ACCOUNT_CREATION_FAILED');
    }

    try {
      await _userService.createUserProfile(
        id: user.uid,
        tasmiaGivenName: tasmiaGivenName,
        username: normalizedUsername,
        email: email,
      );
    } catch (e) {
      await user.delete();
      rethrow;
    }

    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}