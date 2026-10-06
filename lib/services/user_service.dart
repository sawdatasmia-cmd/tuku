import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _usernames =>
      _firestore.collection('usernames');

  Future<void> createUserProfile({
    required String id,
    required String tasmiaGivenName,
    required String username,
    required String email,
  }) async {
    final normalizedUsername = username.trim().toLowerCase();

    final usernameReference =
        _usernames.doc(normalizedUsername);

    final userReference = _users.doc(id);

    await _firestore.runTransaction((transaction) async {
      final usernameSnapshot =
          await transaction.get(usernameReference);

      if (usernameSnapshot.exists) {
        throw Exception('USERNAME_ALREADY_EXISTS');
      }

      final user = TukuUser(
        id: id,
        tasmiaGivenName: tasmiaGivenName,
        username: normalizedUsername,
        email: email,
        isOnline: true,
      );

      transaction.set(
        userReference,
        user.toMap(),
      );

      transaction.set(
        usernameReference,
        {
          'uid': id,
          'username': normalizedUsername,
        },
      );
    });
  }

  Future<TukuUser?> getUserProfile(String id) async {
    final document = await _users.doc(id).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return TukuUser.fromMap(
      document.data()!,
    );
  }

  Future<TukuUser?> getUserByUsername(
    String username,
  ) async {
    final normalizedUsername = username
        .trim()
        .toLowerCase()
        .replaceFirst('@', '');

    final usernameDocument =
        await _usernames.doc(normalizedUsername).get();

    if (!usernameDocument.exists ||
        usernameDocument.data() == null) {
      return null;
    }

    final uid =
        usernameDocument.data()!['uid'] as String;

    return getUserProfile(uid);
  }

  Future<List<TukuUser>> getAllUsers() async {
    final snapshot = await _users.get();

    return snapshot.docs
        .map(
          (document) => TukuUser.fromMap(
            document.data(),
          ),
        )
        .toList();
  }
}