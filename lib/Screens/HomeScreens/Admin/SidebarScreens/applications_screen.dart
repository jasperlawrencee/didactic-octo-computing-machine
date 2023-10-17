// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
  List<String> userNames = [];
  List<String> isUserVerified = [];
  List<String> service = [];
  String sortType = '';
  String sortVerification = '';

  @override
  void initState() {
    getUsername();
    getNumberofUsers();
    super.initState();
  }

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
                const Text('Filter by: '),
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
                Text('DISREGARD FILTERING DROPDOWNS XD')
              ],
            ),
            const SizedBox(height: defaultPadding),
            FutureBuilder<int>(
                future: getNumberofUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('error ${snapshot.error}');
                  } else {
                    final itemCount = snapshot.data ?? 0;
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5),
                        shrinkWrap: true,
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          return userBox(
                            context, userNames[index],
                            isUserVerified[index], true,
                            // isToVerify(),
                          );
                        },
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  verifySalonDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: ThemeData(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: kPrimaryColor,
                      secondary: kPrimaryLightColor,
                    )),
            child: const AlertDialog(
              content: Text('Salon Dialog'),
            ),
          );
        });
  }

  verifyWorkerDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: ThemeData(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: kPrimaryColor,
                      secondary: kPrimaryLightColor,
                    )),
            child: AlertDialog(
              title: const Text('Verify'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width / 1.25,
                height: MediaQuery.of(context).size.height / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Email'),
                        Text('Freelancer/Salon'),
                        Text('Username'),
                        Text('Verified/Unverified')
                      ],
                    ),
                    SizedBox(height: defaultPadding),
                    Text('1'),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'First Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('data')
                              ],
                            ),
                            SizedBox(height: defaultPadding),
                            Row(
                              children: [
                                Text(
                                  'Middle Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('data')
                              ],
                            ),
                            SizedBox(height: defaultPadding),
                            Row(
                              children: [
                                Text(
                                  'Last Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('data')
                              ],
                            ),
                            SizedBox(height: defaultPadding),
                            Row(
                              children: [
                                Text(
                                  'Gender',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('data')
                              ],
                            ),
                            SizedBox(height: defaultPadding),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Number 1',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: defaultPadding),
                            Text(
                              'Phone Number 2',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: defaultPadding),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'City',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: defaultPadding),
                            Text(
                              'Barangay',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: defaultPadding),
                            Text(
                              'Street Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: defaultPadding),
                            Text(
                              'Extended ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: defaultPadding),
                          ],
                        )
                      ],
                    ),
                    Text('2'),
                    Divider(),
                    Text('3'),
                    Divider(),
                    Text('4'),
                    Divider(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close')),
                TextButton(onPressed: () {}, child: const Text('Verify')),
              ],
            ),
          );
        });
  }

  //the container for showing users
  userBox(BuildContext context, String username, String status, bool toVerify) {
    return Container(
      height: 20,
      width: 20,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.zero),
          color: kPrimaryLightColor),
      constraints: const BoxConstraints(maxWidth: 40, maxHeight: 20),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      child: toVerify == true
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$username - '),
                    status == 'unverified'
                        ? const Text(
                            'Unverified',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          )
                        : status == 'verified'
                            ? const Text(
                                'Verified',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text('error'),
                  ],
                ),
                const Spacer(),
                InkWell(
                  child: const Text(
                    'View',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: kPrimaryColor),
                  ),
                  onTap: () {
                    verifyWorkerDialog(context);
                  },
                )
              ],
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('User needs to Verify their Roles'),
              ],
            ),
    );
  }

  Future<List<Map<String, dynamic>>> getAllSteps() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('users').get();
      List<Map<String, dynamic>> stepsList = [];
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        if (doc.data() != null) {
          Map<String, dynamic> documentFields =
              doc.data() as Map<String, dynamic>;
          stepsList.add(documentFields);
        }
      });
      log(stepsList.toString());
      return stepsList;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  //gets the number of freelancers/salons
  Future<int> getNumberofUsers() async {
    try {
      var userCollection = FirebaseFirestore.instance.collection('users');
      //gets all unverified users
      var querySnapshot = await userCollection.where('username').get();
      log(querySnapshot.size.toString());
      return querySnapshot.size;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  //gets the number of unverified freelancers/salons
  Future<int> getNumberOfUnverified() async {
    try {
      var userCollection = FirebaseFirestore.instance.collection('users');
      //gets all unverified users
      var querySnapshot =
          await userCollection.where('status', isEqualTo: 'unverified').get();
      return querySnapshot.size;
    } catch (e) {
      log('error counting documents: $e');
      return 0;
    }
  }

  //gets the number of verified freelancers/salons
  Future<int> getNumberOfVerified() async {
    try {
      var userCollection = FirebaseFirestore.instance.collection('users');
      //gets all unverified users
      var querySnapshot =
          await userCollection.where('status', isEqualTo: 'verified').get();
      return querySnapshot.size;
    } catch (e) {
      log('error counting documents: $e');
      return 0;
    }
  }

  //grab all freelancers/salons usernames from firestore
  Future<List<String>> getUsername() async {
    try {
      List<String> collectionUsernames = [];
      List<String> status = [];
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection('users').get();

      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        if ((doc.data() as Map<String, dynamic>).containsKey('username') &&
            doc.data() != null) {
          collectionUsernames.add(doc['username']);
          status.add(doc['status']);
          setState(() {
            userNames = collectionUsernames;
            isUserVerified = status;
          });
        }
      });
      return collectionUsernames;
    } catch (e) {
      log('error: $e');
      return [];
    }
  }
}
