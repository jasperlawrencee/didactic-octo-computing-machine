import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/calendar_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/salon_screen.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/main.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');
DocumentReference docRef = users.doc('document_id');

class FirebaseService {
  final TextEditingController _servicePrice = TextEditingController();
  final TextEditingController _serviceDescription = TextEditingController();
  final TextEditingController _serviceDuration = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      //_auth is an instance of FirebaseAuth
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
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
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

  Future<dynamic> editServiceDialog(
      BuildContext context, int index, List serviceNames) {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
              data: ThemeData(
                  canvasColor: Colors.transparent,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: kPrimaryColor,
                        background: Colors.white,
                        secondary: kPrimaryLightColor,
                      )),
              child: AlertDialog(
                title: Text('Edit ${serviceNames[index]}'),
                content: SizedBox.square(
                  dimension: 300,
                  child: Column(
                    children: [
                      flatTextField('Price', _servicePrice),
                      flatTextField('Duration', _serviceDuration),
                      flatTextField('Description', _serviceDescription),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _servicePrice.clear();
                        _serviceDescription.clear();
                        _serviceDuration.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Close')),
                  TextButton(
                      onPressed: () async {
                        try {
                          QuerySnapshot querySnapshot = await _firestore
                              .collectionGroup('${currentUser!.uid}services')
                              .get();
                          QueryDocumentSnapshot? targetDocument;
                          //Grabs document in collection group
                          for (QueryDocumentSnapshot doc
                              in querySnapshot.docs) {
                            if (doc.id == serviceNames[index]) {
                              targetDocument = doc;
                              break;
                            }
                          }
                          //Update document if found
                          if (targetDocument != null) {
                            await targetDocument.reference.update({
                              'price': _servicePrice.text,
                              'description': _serviceDescription.text,
                              'duration': _serviceDuration.text,
                            });
                            log('updated ${targetDocument.id}');
                          } else {
                            log('no document found');
                          }
                        } catch (e) {
                          log(e.toString());
                        }
                        _servicePrice.clear();
                        _serviceDescription.clear();
                        _serviceDuration.clear();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Edit'))
                ],
              ));
        });
  }

  //function that returns the list of customers who chatted the clients
  Future<List<String>> getChats() async {
    try {
      //gets current client username to compare
      String username = '';
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get()
          .then((DocumentSnapshot doc) {
        username = doc.get('name');
      });
      //grabs all chat rooms from collection
      QuerySnapshot querySnapshot =
          await _firestore.collection('chat_rooms').get();
      List<String> chats = []; //Aura Salon_cusUsername
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((element) {
          chats.add(element.id);
        });
      }
      //make bool variable to check if current username is existing
      bool containsCurrentUsername =
          chats.any((element) => element.contains(username));

      //final method to remove current username from the list of string if containsCurrentUsername is true
      List<String> chatRooms = [];
      if (chats.isNotEmpty && containsCurrentUsername) {
        chats.forEach((element) {
          if (element.contains(username)) {
            List<String> splits = element.split('_');
            splits.forEach((a) {
              if (a != username) {
                chatRooms.add(a);
              }
            });
          }
        });
        return chatRooms;
      } else {
        log('user has no chats');
        return [];
      }
    } catch (e) {
      log('Error getting customer username: $e');
      return [];
    }
  }

  //function to initialize notifications
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    log('notification token $fCMToken');
    initPushNotifications();
    //notif token
    //cuXMOAlNQE2CpJCJ25Q08v:APA91bHazS3vqr9f_r90UkG2r9FoEGJaPC0b2vRKzrHkqju_3lvh_job893V25IfSrP0UrKawfD2P3e7UZzXOBzLUvnq1VAajmHv0ybSPRFURbvMCcDes2eywK7HbjrtidLz_AA455kx
  }

  //function to handle recieved notifications
  void handleMessage(RemoteMessage? message) async {
    if (message == null) return;

    await FirebaseAuth.instance.signOut();
    navigatorKey.currentState?.pushNamed(
      '/login_screen',
      arguments: message,
    );
  }

  //function to initalize foreground and background settings
  Future initPushNotifications() async {
    //if app is terminated and opened
    _firebaseMessaging.getInitialMessage().then(handleMessage);

    //attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
