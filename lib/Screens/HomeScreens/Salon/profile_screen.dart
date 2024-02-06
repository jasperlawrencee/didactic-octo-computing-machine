// ignore_for_file: unnecessary_null_comparison

import 'dart:core';
import 'dart:developer';

import 'package:badges/badges.dart' as badges;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  int serviceCount = 0;
  var details = [];
  List<String> services = [];
  List<String> servicesTypes = [
    'Hair',
    'Lashes',
    'Makeup',
    'Nails',
    'Spa',
    'Wax'
  ];
  late String serviceValue;
  List<String> serviceNames = [];
  List<dynamic> serviceDuration = [];
  List<dynamic> servicePrice = [];
  List<dynamic> serviceDescription = [];
  String salonName = '', address = '', salonNumber = '';
  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _servicePrice = TextEditingController();
  final TextEditingController _serviceDescription = TextEditingController();
  final TextEditingController _serviceDuration = TextEditingController();
  final TextEditingController _serviceType = TextEditingController();

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  void getUserDetails() async {
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        salonName = documentSnapshot['name'];
        address = documentSnapshot['address'];
        salonNumber = documentSnapshot['salonNumber'];
      });
    });
  }

  Future<List<String>> getServices() async {
    var collectionGroup =
        _firestore.collectionGroup('${currentUser!.uid}services');
    try {
      QuerySnapshot querySnapshot = await collectionGroup.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        details.add(data);
      }
      serviceDescription = details.map((e) => e['description']).toList();
      serviceDuration = details.map((e) => e['duration']).toList();
      servicePrice = details.map((e) => e['price']).toList();
      serviceCount = querySnapshot.size;
      serviceNames = querySnapshot.docs.map((e) => e.id).toList();
      return serviceNames;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<dynamic> editServiceDialog(int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
              data: ThemeData(
                  canvasColor: Colors.transparent,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: kPrimaryColor,
                        background: Colors.white70,
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
                            }).then((value) {
                              setState(() {});
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
                        Navigator.pop(context);
                      },
                      child: const Text('Edit'))
                ],
              ));
        });
  }

  Future<void> deleteDocumentInCollectionGroup(String documentId) async {
    var collectionGroup = FirebaseFirestore.instance
        .collectionGroup('${currentUser!.uid}services');

    try {
      QuerySnapshot querySnapshot = await collectionGroup.get();

      // Find the document with the specified ID on the client side
      QueryDocumentSnapshot? targetDocument;
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (doc.id == documentId) {
          targetDocument = doc;
          break;
        }
      }

      // Delete the document if found
      if (targetDocument != null) {
        await targetDocument.reference.delete().then((value) {
          setState(() {});
        });
        log('Document deleted successfully.');
      } else {
        log('Document not found.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 2));
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
                        address,
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
                    onTap: (() async {
                      // final Uri url = Uri(scheme: 'tel', path: salonNumber);
                      // if (await canLaunchUrl(url)) {
                      //   await launchUrl(url);
                      // }
                    }),
                    child: Text(
                      salonNumber,
                      style: const TextStyle(
                          color: kPrimaryColor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                  child: Stack(
                fit: StackFit.loose,
                children: [
                  StreamBuilder<List<String>>(
                    stream: Stream.fromFuture(getServices()),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        );
                      } else {
                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return ServiceCard(index);
                            },
                          ),
                        );
                      }
                    },
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                              backgroundColor: kPrimaryColor,
                              child: const Icon(
                                Icons.add,
                                color: kPrimaryLightColor,
                              ),
                              onPressed: () {
                                serviceDialog(context);
                              }),
                          const SizedBox(height: defaultPadding)
                        ],
                      )),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> serviceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(
                canvasColor: Colors.transparent,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: kPrimaryColor,
                      background: Colors.white70,
                      secondary: kPrimaryLightColor,
                    )),
            child: AlertDialog(
              title: const Text('Add Service'),
              content: SizedBox.square(
                dimension: 300,
                child: Column(
                  children: <Widget>[
                    DropdownMenu<String>(
                        controller: _serviceType,
                        initialSelection: 'Hair',
                        dropdownMenuEntries: servicesTypes
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList()),
                    flatTextField('Service Name', _serviceName),
                    flatTextField('Price', _servicePrice),
                    flatTextField('Duration', _serviceDuration),
                    flatTextField('Description', _serviceDescription),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      _serviceName.clear();
                      _servicePrice.clear();
                      _serviceDescription.clear();
                      _serviceDuration.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Close')),
                TextButton(
                    onPressed: () {
                      try {
                        _firestore
                            .collection('users')
                            .doc(currentUser!.uid)
                            .collection('categories')
                            .doc(_serviceType.text)
                            .set({'field': ''});
                        _firestore
                            .collection('users')
                            .doc(currentUser!.uid)
                            .collection('categories')
                            .doc(_serviceType.text)
                            .collection('${currentUser!.uid}services')
                            .doc(_serviceName.text)
                            .set({
                          'price': _servicePrice.text,
                          'description': _serviceDescription.text,
                          'duration': _serviceDuration.text
                        }).then((value) {
                          setState(() {});
                        });
                        _serviceName.clear();
                        _servicePrice.clear();
                        _serviceDescription.clear();
                        _serviceDuration.clear();
                        Navigator.of(context).pop();
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    child: const Text('Add')),
              ],
            ),
          );
        });
  }

  // ignore: non_constant_identifier_names
  Widget ServiceCard(int index) {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(),
      showBadge: true,
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Theme(
                data: ThemeData(
                    canvasColor: Colors.transparent,
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: kPrimaryColor,
                          background: Colors.white70,
                          secondary: kPrimaryLightColor,
                        )),
                child: AlertDialog(
                  title: Text("Delete ${serviceNames[index]}?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          deleteDocumentInCollectionGroup(serviceNames[index]);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No')),
                  ],
                ),
              );
            });
      },
      badgeContent: const Icon(
        Icons.close_rounded,
        color: Colors.white,
        size: 15,
      ),
      child: InkWell(
        onTap: () {
          editServiceDialog(index);
        },
        child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: defaultPadding),
            color: kPrimaryLightColor,
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          serviceNames[index],
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        serviceDuration[index].isEmpty ||
                                serviceDuration == null
                            ? const Text(" - Duration")
                            : Text(" - ${serviceDuration[index]}"),
                      ],
                    ),
                    const Spacer(),
                    serviceDescription[index].isEmpty ||
                            serviceDescription == null
                        ? const Text('Description')
                        : Text(serviceDescription[index]),
                  ],
                ),
                Column(
                  children: [
                    servicePrice[index].isEmpty || servicePrice == null
                        ? const Text('Price')
                        : Text('${servicePrice[index]} Php')
                  ],
                )
              ],
            )),
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
