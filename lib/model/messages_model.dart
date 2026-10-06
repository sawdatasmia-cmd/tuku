import 'package:cloud_firestore/cloud_firestore.dart';

class TukuMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final bool isRead;

  const TukuMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'text': text,
      'sentAt': Timestamp.fromDate(sentAt),
      'isRead': isRead,
    };
  }

  factory TukuMessage.fromMap(Map<String, dynamic> map) {
    return TukuMessage(
      id: map['id'] as String,
      conversationId: map['conversationId'] as String,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      isRead: map['isRead'] as bool? ?? false,
    );
  }
}