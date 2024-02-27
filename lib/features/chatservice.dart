import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<String> getCurrentuserid() async {
    try {
      final docRef =
          _firebaseFirestore.collection('users').doc(currentUser!.uid);
      final docSnapshot = await docRef.get();
      final username = docSnapshot.data()?['username'];
      return username;
    } catch (e) {
      log('Error getting currentuser name $e');
      return '';
    }
  }

  // String username

  // Message newMessage = Message(
  //     senderId: getCurrentuserid(),
  //     receiverId: receiverId,
  //     messageText: messageText,
  //     timestamp: timestamp)
}
