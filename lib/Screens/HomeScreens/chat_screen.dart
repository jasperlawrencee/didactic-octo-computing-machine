import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/chatBubble.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/chatservice.dart';

class ChatScreen extends StatefulWidget {
  String username;
  ChatScreen({super.key, required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  String currentUsername = '';
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  getCurrentuserid() async {
    try {
      final docRef =
          _firebaseFirestore.collection('users').doc(currentUser!.uid);
      final docSnapshot = await docRef.get();
      final username = docSnapshot.data()?['name'];
      setState(() {
        currentUsername = username;
      });
      log(currentUsername);
    } catch (e) {
      log('Error getting currentuser name of customer: $e');
    }
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      log("recieved by: ${widget.username} sent by $currentUsername");
      await chatService.sendMessage(widget.username, messageController.text);
      messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentuserid();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 52),
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
          backgroundColor: kPrimaryColor,
          title: Text(
            'Chat ${widget.username}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Background(
            child: Column(
          children: [Expanded(child: messageList()), messageInput()],
        )),
      )),
    );
  }

  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessages(widget.username, currentUsername),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => messageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget messageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == currentUsername)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(data['senderId']),
          ChatBubble(message: data['messageText'])
        ],
      ),
    );
  }

  Widget messageInput() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: messageController,
          decoration: const InputDecoration(hintText: 'Input Message'),
          obscureText: false,
        )),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              color: kPrimaryColor,
            )),
        Padding(padding: EdgeInsets.only(bottom: 30))
      ],
    );
  }
}
