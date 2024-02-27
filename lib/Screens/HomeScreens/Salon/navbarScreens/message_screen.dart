import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/Salon/chat_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final firestore = FirebaseFirestore.instance;
  Stream<List<String>>? customerStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerStream = getCustomerUsername().asStream();
  }

  Future<List<String>> getCustomerUsername() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: 'customer')
          .get();
      final customers = <String>[];
      querySnapshot.docs.forEach((element) {
        customers.add(element['Username']);
      });
      return customers;
    } catch (e) {
      log('Error getting customer username: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Background(
            child: Container(
          margin: const EdgeInsets.only(top: 35),
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
    return StreamBuilder<List<String>>(
      stream: customerStream,
      builder: (context, snapshot) {
        try {
          if (snapshot.hasError) {
            Text('Error getting users ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor));
          }
          final customerList = snapshot.data!;
          return ListView.builder(
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

  Widget usersChatListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    String name = data['Username'];
    return ListTile(
      title: Text(data['Username']),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                username: name,
              ),
            ));
      },
    );
  }
}
