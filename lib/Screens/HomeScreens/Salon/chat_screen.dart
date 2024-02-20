import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class ChatScreen extends StatefulWidget {
  String username;
  ChatScreen({super.key, required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 8,
              )),
          title: Text('Chat ${widget.username}'),
        ),
      ),
    );
  }
}
