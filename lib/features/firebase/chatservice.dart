import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<String> getCurrentuserid() async {
    try {
      final docRef =
          _firebaseFirestore.collection('users').doc(currentUser!.uid);
      final docSnapshot = await docRef.get();
      final username = docSnapshot.data()?['name'];
      return username;
    } catch (e) {
      log('Error getting currentuser name of client: $e');
      return '';
    }
  }

  Future<void> sendMessage(String receiverId, String message) async {
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: await getCurrentuserid(),
        receiverId: receiverId,
        messageText: message,
        timestamp: timestamp);

    List<String> ids = [await getCurrentuserid(), receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
