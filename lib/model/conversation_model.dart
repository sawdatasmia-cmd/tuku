import 'package:cloud_firestore/cloud_firestore.dart';

class TukuConversation {
  final String id;
  final List<String> participantIds;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final String? lastMessageSenderId;

  const TukuConversation({
    required this.id,
    required this.participantIds,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageSenderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participantIds': participantIds,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt != null
          ? Timestamp.fromDate(lastMessageAt!)
          : null,
      'lastMessageSenderId': lastMessageSenderId,
    };
  }

  factory TukuConversation.fromMap(Map<String, dynamic> map) {
    return TukuConversation(
      id: map['id'] as String,
      participantIds: List<String>.from(
        map['participantIds'] as List,
      ),
      lastMessage: map['lastMessage'] as String?,
      lastMessageAt: map['lastMessageAt'] != null
          ? (map['lastMessageAt'] as Timestamp).toDate()
          : null,
      lastMessageSenderId:
          map['lastMessageSenderId'] as String?,
    );
  }
}