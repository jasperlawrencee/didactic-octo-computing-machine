// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:badges/badges.dart' as badges;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
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
  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _servicePrice = TextEditingController();
  final TextEditingController _serviceDescription = TextEditingController();
  final TextEditingController _serviceDuration = TextEditingController();
  final TextEditingController _serviceType = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Services".toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                  child: Stack(
                fit: StackFit.loose,
                children: [
                  serviceSections('Hair'),
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

//streambuilder for each service category ie Hair, Lashes etc.
  Widget serviceSections(String serviceType) {
    //parent streambuilder for getting service name
    return StreamBuilder<List<String>>(
      stream: Stream.fromFuture(getServices(serviceType)),
      builder: (context, serviceName) {
        if (!serviceName.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        } else {
          return RefreshIndicator(
              onRefresh: _refresh,
              //child streambuilder for getting service details
              child: StreamBuilder<List<List<dynamic>>>(
                stream: Stream.fromFuture(getServiceDetails()),
                builder: (context, serviceDetails) {
                  return ListView.builder(
                    itemCount: serviceName.data?.length,
                    itemBuilder: (context, index) {
                      if (serviceDetails.hasError) {
                        return const Text('Error loading data');
                      }
                      List<List>? myData = serviceDetails.data;
                      log(myData![2].toString());
                      return ServiceCard(index, myData[index][0],
                          myData[index][1], myData[index][2]);
                    },
                  );
                },
              ));
        }
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget ServiceCard(int index, String description, duration, price) {
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
                          background: Colors.white,
                          secondary: kPrimaryLightColor,
                        )),
                child: AlertDialog(
                  title: Text("Delete ${serviceNames[index]}?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          // deleteDocumentInCollectionGroup(serviceNames[index]);
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
                        duration == null ? Text('data') : Text(' - ${duration}')
                      ],
                    ),
                    const Spacer(),
                    description == null ? Text('data') : Text(description)
                  ],
                ),
                Column(
                  children: [price == null ? Text('data') : Text(price)],
                )
              ],
            )),
      ),
    );
  }

  Future<List<List<dynamic>>> getServiceDetails() async {
    List<List<dynamic>> detailValues = [];
    try {
      final CollectionReference collection = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .doc('Hair')
          .collection('Hairservices');
      QuerySnapshot querySnapshot = await collection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        List<dynamic> values = [
          doc['description'],
          doc['duration'],
          doc['price'],
        ];
        detailValues.add(values);
      }
      return detailValues;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<String>> getServices(String serviceType) async {
    var collectionGroup = _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('services')
        .doc(serviceType)
        .collection('${serviceType}services');
    try {
      QuerySnapshot querySnapshot = await collectionGroup.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        details.add(data);
      }
      serviceNames = querySnapshot.docs.map((e) => e.id).toList();
      return serviceNames;
    } catch (e) {
      log(e.toString());
    }
    return [];
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
                      background: Colors.white,
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
                            .collection('services')
                            .doc(_serviceType.text)
                            .collection('${_serviceType.text}services')
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

  Future<void> deleteDocumentInCollectionGroup(String documentId) async {
    var collectionGroup = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('services');

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

  Future<dynamic> editServiceDialog(int index) {
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
                        Navigator.pop(context);
                      },
                      child: const Text('Edit'))
                ],
              ));
        });
  }
}
