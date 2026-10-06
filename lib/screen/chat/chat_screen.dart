import 'package:flutter/material.dart';

import '../../widget/massage_bubble.dart';
import '../../widget/message_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  final List<Map<String, String>> _messages = [
    {
      'message': 'Hey! 🌷',
      'time': '10:42 PM',
      'isMe': 'false',
    },
    {
      'message': 'Heyyy! How are you?',
      'time': '10:43 PM',
      'isMe': 'true',
    },
    {
      'message': 'I’m good. Just taking it easy today.',
      'time': '10:44 PM',
      'isMe': 'false',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add({
        'message': text,
        'time': _currentTime(),
        'isMe': 'true',
      });
    });

    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _currentTime() {
    final now = TimeOfDay.now();
    return now.format(context);
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

        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF410200),
            child: Icon(
              Icons.circle,
              color: const Color(0xFFFFF8EE),
              size: 10,
            ),
          ),
        ),

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tasmia Given Name',
              style: TextStyle(
                color: Color(0xFF410200),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 8,
                ),
                SizedBox(width: 5),
                Text(
                  'Online',
                  style: TextStyle(
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
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MessageBubble(
                    message: message['message']!,
                    time: message['time']!,
                    isMe: message['isMe'] == 'true',
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