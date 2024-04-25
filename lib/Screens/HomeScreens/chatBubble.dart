import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: kPrimaryLightColor,
      ),
      child: message.length >= 4 && message.substring(0, 4) == 'http'
          ? Image.network(message, height: 100)
          : Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
    );
  }
}
