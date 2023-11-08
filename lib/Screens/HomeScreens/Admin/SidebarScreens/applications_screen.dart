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
  List<String> type = ['All', 'Salons', 'Freelancers'];
  List<String> verification = ['All', 'Unverified', 'Verified'];
  List<String> userNames = [];
  List<String> isUserVerified = [];
  List<Map<String, dynamic>> resultList = [];
  TextEditingController typeController = TextEditingController();
  TextEditingController verifyController = TextEditingController();

  @override
  void initState() {
    getUserDetails(1);
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
                  controller: typeController,
                  initialSelection: type[0],
                  dropdownMenuEntries:
                      type.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                  onSelected: (value) {
                    filterUsers();
                  },
                ),
                const SizedBox(width: defaultPadding),
                DropdownMenu(
                    controller: verifyController,
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
                }),
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
                child: FutureBuilder(
                    future: getUserDetails(index),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return Text(userNames[index]);
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
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
  filterUsers() {
    if (typeController.text == 'All') {
    } else if (typeController.text == 'Salons') {
    } else if (typeController.text == 'Freelancers') {}
  }

  void verifyUser(int index) async {
    try {
      QuerySnapshot getDocNames = await _firebaseFirestore
          .collection('users')
          .where('role', isNotEqualTo: 'admin')
          .get();
      //list of the unique document names
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

  //gets the number of freelancers/salons
  Future<int> getNumberofUsers() async {
    try {
      var userCollection = FirebaseFirestore.instance.collection('users');
      //gets all unverified users
      var querySnapshot =
          await userCollection.where('role', isNotEqualTo: 'pending').get();
      log('Number of users ${querySnapshot.size.toString()}');
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
          .where('role', isNotEqualTo: 'pending')
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
      log('Usernames: ${collectionUsernames.toString()}');
      return collectionUsernames;
    } catch (e) {
      log('error: $e');
      return [];
    }
  }

  getUserDetails(int index) async {
    try {
      QuerySnapshot getDocumentName = await _firebaseFirestore
          .collection('users')
          .where('role', isNotEqualTo: 'pending')
          .get();
      //list of the unique document names
      List<String> documentNames =
          getDocumentName.docs.map((doc) => doc.id).toList();
      _firebaseFirestore
          .collection('users')
          .doc(documentNames[index])
          .collection('userDetails')
          .get()
          .then((querySnapshot) {
        for (var documentSnapshot in querySnapshot.docs) {
          log('${documentSnapshot.id} => ${documentSnapshot.data()}');
          // log(details);
        }
      });
    } catch (e) {
      log(e.toString());
      // return Text(e.toString());
    }
    // return Text(details);
  }
}
