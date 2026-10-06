import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(
              maxWidth: 290,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? const Color(0xFF410200)
                  : const Color(0xFFF3E6D8),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
                bottomLeft: Radius.circular(
                  isMe ? 25 : 9,
                ),
                bottomRight: Radius.circular(
                  isMe ? 9 : 25,
                ),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isMe
                    ? const Color(0xFFFFF8EE)
                    : const Color(0xFF410200),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              time,
              style: const TextStyle(
                color: Color(0xFF9B8580),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}