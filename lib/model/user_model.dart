import 'package:cloud_firestore/cloud_firestore.dart';

class TukuUser {
  final String id;
  final String tasmiaGivenName;
  final String username;
  final String email;
  final String? profileImage;
  final bool isOnline;
  final DateTime? lastSeen;

  const TukuUser({
    required this.id,
    required this.tasmiaGivenName,
    required this.username,
    required this.email,
    this.profileImage,
    this.isOnline = false,
    this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tasmiaGivenName': tasmiaGivenName,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'isOnline': isOnline,
      'lastSeen': lastSeen != null
          ? Timestamp.fromDate(lastSeen!)
          : null,
    };
  }

  factory TukuUser.fromMap(Map<String, dynamic> map) {
    return TukuUser(
      id: map['id'] as String,
      tasmiaGivenName: map['tasmiaGivenName'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'] as String?,
      isOnline: map['isOnline'] as bool? ?? false,
      lastSeen: map['lastSeen'] != null
          ? (map['lastSeen'] as Timestamp).toDate()
          : null,
    );
  }
}