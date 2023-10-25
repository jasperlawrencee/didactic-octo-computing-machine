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
  List<Map<String, dynamic>> resultList = [];

  @override
  void initState() {
    getUserDetails();
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
                            context,
                            userNames[index],
                            isUserVerified[index],
                            index,
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

///////////////////////////////////////////--WIDGETS--/////////////////////////////////////////
  //the container for showing users
  userBox(BuildContext context, String username, String status, int index) {
    return Container(
        height: 20,
        width: 20,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.zero),
            color: kPrimaryLightColor),
        constraints: const BoxConstraints(maxWidth: 40, maxHeight: 20),
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        child: Column(
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
                    decoration: TextDecoration.underline, color: kPrimaryColor),
              ),
              onTap: () {
                verifyDialog(context, index);
              },
            )
          ],
        ));
  }

  verifyDialog(BuildContext context, int index) {
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
              title: Text(
                  "${userNames[index]} - ${isUserVerified[index].toUpperCase()}"),
              content: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.25,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Column(
                    children: [],
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close')),
                TextButton(
                    onPressed: () {
                      verifyUser(index);
                    },
                    child: const Text('Verify')),
              ],
            ),
          );
        });
  }

///////////////////////////////////////--FUNCTIONS////////////////////////////////////////////////////////
  void verifyUser(int index) async {
    try {
      QuerySnapshot getDocNames = await _firebaseFirestore
          .collection('users')
          .where('role', isNotEqualTo: 'admin')
          .get();
      List<String> documentNames =
          getDocNames.docs.map((doc) => doc.id).toList();
      getDocNames.docs.forEach((doc) {
        _firebaseFirestore
            .collection('users')
            .doc(documentNames[index])
            .update({'status': 'verified'});
        log("updated ${documentNames[index]} to verified");
        Navigator.of(context).pop();
      });
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  Future<Map<String, List<QueryDocumentSnapshot>>> getUserDetails() async {
    try {
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collectionGroup('userDetails').get();
      Map<String, List<QueryDocumentSnapshot>> results = {};
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String firstName = data['firstName'] ?? 'Other';
        if (!results.containsKey(firstName)) {
          results[firstName] = [];
        }
        results[firstName]?.add(doc);
      }
      return results;
    } catch (e) {
      log(e.toString());
      return {};
    }
  }

  //gets the number of freelancers/salons
  Future<int> getNumberofUsers() async {
    try {
      var userCollection = FirebaseFirestore.instance.collection('users');
      //gets all unverified users
      var querySnapshot =
          await userCollection.where('role', isNotEqualTo: 'admin').get();
      return querySnapshot.size;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  //grab all freelancers/salons usernames from firestore
  Future<List<String>> getUsername() async {
    try {
      List<String> collectionUsernames = [];
      List<String> status = [];
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('users')
          .where('role', isNotEqualTo: 'admin')
          .get();
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
