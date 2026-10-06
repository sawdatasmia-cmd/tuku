import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/messages_model.dart';

class MessageService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      _messages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
  }

Future<TukuMessage> createMessage({
  required String conversationId,
  required String senderId,
  required String text,
}) async {
  final conversationReference =
      _firestore
          .collection('conversations')
          .doc(conversationId);

  final messageReference =
      conversationReference
          .collection('messages')
          .doc();

  final now = DateTime.now();

  final message = TukuMessage(
    id: messageReference.id,
    conversationId: conversationId,
    senderId: senderId,
    text: text,
    sentAt: now,
  );

  final batch = _firestore.batch();

  batch.set(
    messageReference,
    message.toMap(),
  );

  batch.update(
    conversationReference,
    {
      'lastMessage': text,
      'lastMessageAt': Timestamp.fromDate(now),
      'lastMessageSenderId': senderId,
    },
  );

  await batch.commit();

  return message;
}
  Future<List<TukuMessage>> getMessages(
    String conversationId,
  ) async {
    final snapshot = await _messages(conversationId)
        .orderBy('sentAt')
        .get();

    return snapshot.docs
        .map(
          (document) =>
              TukuMessage.fromMap(document.data()),
        )
        .toList();
  }
}