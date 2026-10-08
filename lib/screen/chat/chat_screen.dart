import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/messages_model.dart';
import '../../model/user_model.dart';
import '../../services/conversation_service.dart';
import '../../services/message_service.dart';
import '../../widget/massage_bubble.dart';
import '../../widget/message_input.dart';

class ChatScreen extends StatefulWidget {
  final TukuUser otherUser;

  const ChatScreen({
    super.key,
    required this.otherUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  final MessageService _messageService =
      MessageService();

  final ConversationService _conversationService =
      ConversationService();

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  List<TukuMessage> _messages = [];

  String? _conversationId;

StreamSubscription<List<TukuMessage>>?
 _messageSubscription;

  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

Future<void> _loadConversation() async {
  try {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception(
        'No user is currently logged in.',
      );
    }

    final conversation =
        await _conversationService
            .createOrGetConversation(
      currentUserId: currentUser.uid,
      otherUserId: widget.otherUser.id,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _conversationId = conversation.id;
      _isLoading = false;
    });

    _listenToMessages(conversation.id);
  } catch (e) {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
      _errorMessage =
          'Could not load this conversation.';
    });
  }
}
void _listenToMessages(
  String conversationId,
) {
  _messageSubscription?.cancel();

  _messageSubscription =
      _messageService
          .watchMessages(conversationId)
          .listen(
    (messages) {
      if (!mounted) {
        return;
      }

      setState(() {
        _messages = messages;
      });

      _scrollToBottom();
    },
    onError: (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage =
            'Could not listen for new messages.';
      });
    },
  );
}
Future<void> _sendMessage() async {
  final text = _messageController.text.trim();

  if (text.isEmpty || _isSending) {
    return;
  }

  final currentUser = _auth.currentUser;

  if (currentUser == null) {
    return;
  }

  if (_conversationId == null) {
    return;
  }

  setState(() {
    _isSending = true;
  });

  try {
    await _messageService.createMessage(
      conversationId: _conversationId!,
      senderId: currentUser.uid,
      text: text,
    );

    if (!mounted) {
      return;
    }

    _messageController.clear();

    setState(() {
      _isSending = false;
    });
  } catch (e) {
    if (!mounted) {
      return;
    }

    setState(() {
      _isSending = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Message could not be sent. Please try again.',
        ),
      ),
    );
  }
}
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    return time.format(context);
  }
@override
void dispose() {
  _messageSubscription?.cancel();
  _messageController.dispose();
  _scrollController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8EE),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,

       leading: IconButton(
         onPressed: () {
           Navigator.pop(context);
    },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Color(0xFF410200),
  ),
),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.otherUser.tasmiaGivenName,
              style: const TextStyle(
                color: Color(0xFF410200),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 8,
                ),
                const SizedBox(width: 5),
                Text(
                  '@${widget.otherUser.username}',
                  style: const TextStyle(
                    color: Color(0xFF8A6F68),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Stack(
          children: [
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF410200),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Color(0xFF72554D),
                  ),
                ),
              )
            else
              ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  16,
                  18,
                  16,
                  105,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];

                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 12),
                    child: MessageBubble(
                      message: message.text,
                      time: _formatTime(message.sentAt),
                      isMe:
                          message.senderId ==
                          _auth.currentUser?.uid,
                    ),
                  );
                },
              ),

            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: MessageInput(
                controller: _messageController,
                onSend: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}