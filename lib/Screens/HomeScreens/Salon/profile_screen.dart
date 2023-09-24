// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  String barangay = '', city = '', streetAddress = '', salonName = '';

  @override
  void initState() {
    super.initState();
    getSalonAddress();
  }

  void getSalonAddress() {
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('userDetails')
        .doc('step1')
        .get()
        .then(((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot != null) {
        setState(() {
          salonName = documentSnapshot.get('salonName');
          barangay = documentSnapshot.get('barangay');
          city = documentSnapshot.get('city');
          streetAddress = documentSnapshot.get('streetRoad');
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
          child: Column(
            children: [
              Text(
                "Salon Profile".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //salon name and picture
                  salonCard(Column(
                    children: [
                      SizedBox(
                        height: 90,
                        child: ClipOval(
                            child: Image.asset('assets/avatars/5.jpg')),
                      ),
                      const Spacer(),
                      Text(
                        salonName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  )),
                  //salon address
                  salonCard(Column(
                    children: [
                      const SizedBox(
                        height: 75,
                        child: Icon(
                          Icons.location_on,
                          color: kPrimaryColor,
                          size: 50,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$barangay, $streetAddress, $city',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  )),
                  //salon phone number
                ],
              ),
              const SizedBox(height: defaultPadding),
              //call salon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Call: '),
                  InkWell(
                    //call function
                    onTap: (() {}),
                    child: const Text(
                      '+639123456789',
                      style: TextStyle(
                          color: kPrimaryColor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return salonServiceCard(index);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget salonServiceCard(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: defaultPadding),
      color: kPrimaryLightColor,
      width: double.infinity,
      height: 100,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Service #$index',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Spacer(),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text('price-range'),
          ),
        ],
      ),
    );
  }

  Container salonCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 150,
      width: 150,
      decoration: const BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: child,
    );
  }
}
