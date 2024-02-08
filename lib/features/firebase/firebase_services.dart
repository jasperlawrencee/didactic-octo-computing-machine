import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

CollectionReference users = FirebaseFirestore.instance.collection('users');
DocumentReference docRef = users.doc('document_id');

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

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

  void addServicesToFirebase(
      bool serviceClicked, List servicesList, String serviceType) async {
    if (serviceClicked) {
      try {
        for (String fieldNames in servicesList) {
          Map<String, dynamic> serviceFields = {
            'price': '',
            'duration': '',
            'description': '',
          };
          Map<String, dynamic> addFields = {};
          //add services to categories collection para kuhaon lang sa frontend ang names sa services in an array-like
          for (String fieldNames in servicesList) {
            addFields[fieldNames] = '';
          }
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc(serviceType)
              .set(addFields, SetOptions(merge: true));
          //??way buot firebase
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('services')
              .doc(serviceType)
              .set({'doc': ''});
          //add services to services dapat naa na tanan shit
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('services')
              .doc(serviceType)
              .collection('${serviceType}services')
              .doc(fieldNames)
              .set(serviceFields);
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }
}
