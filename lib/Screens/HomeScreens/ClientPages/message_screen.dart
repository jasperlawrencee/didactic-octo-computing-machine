import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/chat_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/firebase/firebase_services.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final firestore = FirebaseFirestore.instance;
  Stream<List<String>>? customerStream;
  FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    // customerStream = firebaseService.getChats().asStream();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Background(
            child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Text(
                "Messages".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Expanded(child: usersChatList())
            ],
          ),
        )),
      ),
    );
  }

  Widget usersChatList() {
    return FutureBuilder<List<String>>(
      future: firebaseService.getChats(),
      builder: (context, snapshot) {
        try {
          if (snapshot.hasError) {
            Text('Error getting users ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor));
          }
          final customerList = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              itemCount: customerList.length,
              itemBuilder: (context, index) {
                final customer = customerList[index];
                return ListTile(
                  title: Text(customer),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChatScreen(username: customer);
                      },
                    ));
                  },
                );
              },
            ),
          );
        } catch (e) {
          log('Error: $e');
          return const Center(
            child: Text('Error getting users'),
          );
        }
      },
    );
  }
}
