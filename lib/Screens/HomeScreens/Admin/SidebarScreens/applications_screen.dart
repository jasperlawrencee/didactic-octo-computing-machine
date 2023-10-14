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

  @override
  void initState() {
    getUsername();
    // TODO: implement initState
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
            const SizedBox(height: defaultPadding),
            FutureBuilder<int>(
                future: getNumberOfUnverified(),
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
                          return userBox(context, userNames[index]);
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

  Future<int> getNumberOfVerified() async {
    try {
      var userCollection = FirebaseFirestore.instance.collection('users');
      //gets all unverified users
      var querySnapshot =
          await userCollection.where('status', isEqualTo: 'verified').get();
      log(querySnapshot.size.toString());
      return querySnapshot.size;
    } catch (e) {
      log('error counting documents: $e');
      return 0;
    }
  }

  getUserDetails() {}

  //grab all freelancers/salons usernames from firestore
  Future<List<String>> getUsername() async {
    try {
      List<String> collectionUsernames = [];
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection('users').get();

      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        if ((doc.data() as Map<String, dynamic>).containsKey('username') &&
            doc.data() != null) {
          if (doc.get('username') == 'adminUsername') {
            return;
          } else {
            collectionUsernames.add(doc['username']);
            setState(() {
              userNames = collectionUsernames;
            });
          }
        }
      });
      log(userNames.toString());
      return collectionUsernames;
    } catch (e) {
      log('error: $e');
      return [];
    }
  }

  verifyWorkerDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Verify'),
            content: Container(
              width: MediaQuery.of(context).size.width / 1.25,
              height: MediaQuery.of(context).size.height / 1.5,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              TextButton(onPressed: () {}, child: Text('Close')),
              TextButton(onPressed: () {}, child: Text('Verify')),
            ],
          );
        });
  }

  //the container for showing users
  userBox(BuildContext context, String username) {
    return Container(
      height: 20,
      width: 20,
      constraints: const BoxConstraints(maxWidth: 80),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      color: kPrimaryLightColor,
      child: Column(
        children: [
          Text(username),
          InkWell(
            child: Text('View'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('User'),
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
