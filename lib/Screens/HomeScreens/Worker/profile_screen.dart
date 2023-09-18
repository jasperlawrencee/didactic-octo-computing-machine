import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/Worker/certificate_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
              Expanded(
                child: Container(
                  height: height * 0.4,
                  color: Colors.transparent,
                  child: LayoutBuilder(builder: (contex, constraints) {
                    double innerHeight = constraints.maxHeight;
                    double innerWidth = constraints.maxWidth;
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: innerHeight * 0.65,
                            width: innerWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: kPrimaryLightColor,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 65),
                                Text(
                                  name,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  child: RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      log(rating.toString());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: SizedBox(
                              width: innerWidth * 0.35,
                              child: ClipOval(
                                  child: Image.asset('assets/avatars/2.jpg')),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: defaultPadding),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // padding: const EdgeInsets.only(right: defaultPadding),
                child: Row(
                  children: [
                    profileStats('Transactions\nDone', body: '123'),
                    const SizedBox(width: defaultPadding),
                    profileStats('Last\nTransaction', body: 'Jasper'),
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
                    const SizedBox(width: defaultPadding),
                    profileStats('Profile Visits', body: '123'),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              const Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: defaultPadding),
              //custom about user
              const Text(
                  'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non semper suscipit posuere a pede.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non semper suscipit posuere a pede.'),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }

  Container profileStats(String title, {String? body, bool underline = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 120,
      width: 120,
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
    //grab name function
    super.initState;
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
}
