import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');
DocumentReference docRef = users.doc('document_id');

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e);
      } else if (e.code == 'wrong-password') {
        print(e);
      }
    }
    return null;
  }

  Future<void> getData() async {
    try {
      DocumentSnapshot documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        // Access fields by their names
        dynamic fieldValue = documentSnapshot
            .get('role'); // Replace 'field_name' with the actual field name

        // Use the field value
        print('Field Value: $fieldValue');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getDocument(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(documentId).get();

      if (documentSnapshot.exists) {
        // Access fields by their names
        dynamic fieldValue = documentSnapshot
            .get('role'); // Replace 'field_name' with the actual field name

        // Use the field value
        print('Field Value: $fieldValue');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return 'No User';
    }
  }
}
