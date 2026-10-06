import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/conversation_model.dart';

class ConversationService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _conversations =>
          _firestore.collection('conversations');

  String createConversationId(
    String userId1,
    String userId2,
  ) {
    final ids = [userId1, userId2]..sort();

    return '${ids[0]}_${ids[1]}';
  }

  Future<TukuConversation> createOrGetConversation({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final conversationId = createConversationId(
      currentUserId,
      otherUserId,
    );

    final reference =
        _conversations.doc(conversationId);

    final document = await reference.get();

    if (document.exists && document.data() != null) {
      return TukuConversation.fromMap(
        document.data()!,
      );
    }

    final conversation = TukuConversation(
      id: conversationId,
      participantIds: [
        currentUserId,
        otherUserId,
      ],
    );

    await reference.set(conversation.toMap());

    return conversation;
  }

  Future<TukuConversation?> getConversation(
    String conversationId,
  ) async {
    final document =
        await _conversations.doc(conversationId).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return TukuConversation.fromMap(
      document.data()!,
    );
  }
}