// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/Worker/certificate_screen.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProfilePage extends StatefulWidget {
  final String parentDocumentId;

  const ProfilePage({Key? key, required this.parentDocumentId})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> imageUrl = [];
  String name = '';
  String address = '';
  String fullName = '';
  TextEditingController userAbout = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
          child: Column(
            children: [
              Text(
                "Profile".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: defaultPadding),
              SizedBox(
                height: 85,
                width: 85,
                child: ClipOval(
                  child: Image.asset('assets/avatars/2.jpg'),
                ),
              ),
              const SizedBox(height: defaultPadding),
              SizedBox(
                child: RatingBar.builder(
                  itemSize: 30,
                  ignoreGestures: true,
                  initialRating: 4.2,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const Icon(
                      Icons.star_rate_rounded,
                      color: Colors.amber,
                    );
                  },
                  onRatingUpdate: (value) {},
                ),
              ),
              const SizedBox(height: defaultPadding),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(fullName),
              const SizedBox(height: defaultPadding),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // padding: const EdgeInsets.only(right: defaultPadding),
                child: Row(
                  children: [
                    profileStats('Address', body: address),
                    const SizedBox(width: defaultPadding),
                    profileStats('Transactions\nDone', body: '123'),
                    const SizedBox(width: defaultPadding),
                    InkWell(
                        child: profileStats('Credentials',
                            body: 'View', underline: true),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const DisplayCertificates();
                          }));
                        }),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              profileButton(() => null, Icons.person, 'Personal Details'),
              const SizedBox(height: defaultPadding),
              profileButton(() => null, Icons.event_repeat, 'History'),
              const SizedBox(height: defaultPadding),
              profileButton(() => logout(), Icons.logout_outlined, 'Logout')
            ],
          ),
        ),
      ),
    );
  }

  logout() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
              data: ThemeData(
                  canvasColor: Colors.transparent,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: kPrimaryColor,
                        background: Colors.white,
                        secondary: kPrimaryLightColor,
                      )),
              child: AlertDialog(
                title: const Text("Confirm Logout?"),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: () async {
                      try {
                        if (context.mounted) {
                          await FirebaseAuth.instance.signOut();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Logged Out")));
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return const LoginScreen();
                          }), (route) => route.isFirst);
                        }
                      } catch (e) {
                        log('error: $e');
                      }
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ));
        });
  }

  InkWell profileButton(Function() goTo, IconData icon, String text) {
    return InkWell(
        onTap: goTo,
        child: SizedBox(
          child: Row(
            children: [
              Icon(
                icon,
                color: kPrimaryColor,
              ),
              const SizedBox(width: defaultPadding / 2),
              Text(
                text,
                style: const TextStyle(color: kPrimaryColor),
              )
            ],
          ),
        ));
  }

  Container profileStats(String title, {String? body, bool underline = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 140,
      width: 140,
      decoration: const BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Spacer(),
          Align(
              alignment: Alignment.bottomRight,
              child: body != null
                  ? Text(
                      body,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        decoration: underline ? TextDecoration.underline : null,
                        color: underline ? kPrimaryColor : null,
                      ),
                    )
                  : null)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState;
    getWorkerUsername();
    getWorkerAddress();
    getFullName();
  }

  void getWorkerUsername() {
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .get()
        .then(((DocumentSnapshot documentSnapshot) {
      setState(() {
        name = documentSnapshot.get('username');
      });
    }));
  }

  void getWorkerAddress() {
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .get()
        .then(((DocumentSnapshot documentSnapshot) {
      setState(() {
        address = documentSnapshot.get('address');
      });
    }));
  }

  void getFullName() {
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .get()
        .then(((DocumentSnapshot documentSnapshot) {
      setState(() {
        fullName = documentSnapshot.get('name');
      });
    }));
  }
}
