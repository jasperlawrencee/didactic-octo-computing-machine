import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class Applications extends StatefulWidget {
  const Applications({Key? key}) : super(key: key);

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<String> type = ['All', 'Salon', 'Freelancer'];
  List<String> verification = ['Unverified', 'Verified'];
  String firstName = '';
  String middleName = '';
  String lastName = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Theme(
        data: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: kPrimaryColor,
                  secondary: kPrimaryLightColor,
                )),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Sort by: '),
                DropdownMenu(
                    initialSelection: type[0],
                    dropdownMenuEntries:
                        type.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList()),
                const SizedBox(width: defaultPadding),
                DropdownMenu(
                    initialSelection: verification[0],
                    dropdownMenuEntries: verification
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList()),
              ],
            ),
            InkWell(
              child: Container(
                height: 150,
                width: 220,
                color: kPrimaryLightColor,
              ),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }

  //must grab all users in firestore
  getUserFullName() {
    _firebaseFirestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('userDetails')
        .doc('step1')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      try {
        if (documentSnapshot.exists) {
          setState(() {
            firstName = documentSnapshot.get('firstName');
            middleName = documentSnapshot.get('middleName');
            lastName = documentSnapshot.get('lastname');
          });
        }
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
