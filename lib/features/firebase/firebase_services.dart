import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

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
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
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
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
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
        log('Field Value: $fieldValue');
      } else {
        log('Document does not exist');
      }
    } catch (e) {
      log('Error: $e');
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
        log('Field Value: $fieldValue');
      } else {
        log('Document does not exist');
      }
    } catch (e) {
      log('Error: $e');
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
