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
  String address = '',
      salonName = '',
      salonNumber = '',
      price = '',
      description = '';
  int serviceCount = 0;
  List<String> serviceName = [];
  List<String> servicePrice = [];
  List<String> serviceDescription = [];
  List<String> serviceDuration = [];
  List<String> services = [];
  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _servicePrice = TextEditingController();
  final TextEditingController _serviceDescription = TextEditingController();
  final TextEditingController _serviceDuration = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSalonAddress();
    getSalonService();
    getServiceCount();
  }

  void getSalonService() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .get();
      List<String> serviceNames =
          querySnapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        services = serviceNames;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void getServiceDetails() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('description') &&
            data.containsKey('duration') &&
            data.containsKey('price')) {
          serviceDescription.add(data['duration'].toString());
          servicePrice.add(data['price'].toString());
          serviceDuration.add(data['duration'].toString());
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void getServiceCount() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .get();
      int count = querySnapshot.size;
      setState(() {
        serviceCount = count;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void getSalonAddress() {
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .get()
        .then(((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot != null) {
        setState(() {
          salonName = documentSnapshot.get('salonName');
          address = documentSnapshot.get('address');
          salonNumber = documentSnapshot.get('salonNumber');
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
                    onTap: (() {}),
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
                  ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: serviceCount,
                      itemBuilder: (context, index) {
                        return ServiceCard(index);
                      }),
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
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Add Service'),
                                        content: SizedBox.square(
                                          dimension: 280,
                                          child: Column(
                                            children: <Widget>[
                                              flatTextField(
                                                  'Service Name', _serviceName),
                                              const SizedBox(
                                                  height: defaultPadding),
                                              flatTextField(
                                                  'Price', _servicePrice),
                                              const SizedBox(
                                                  height: defaultPadding),
                                              flatTextField(
                                                  'Duration', _serviceDuration),
                                              const SizedBox(
                                                  height: defaultPadding),
                                              flatTextField('Description',
                                                  _serviceDescription),
                                              const SizedBox(
                                                  height: defaultPadding),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Close')),
                                          TextButton(
                                              onPressed: () {
                                                try {
                                                  _firestore
                                                      .collection('users')
                                                      .doc(currentUser!.uid)
                                                      .collection('services')
                                                      .doc(_serviceName.text)
                                                      .set({
                                                    'serviceName':
                                                        _serviceName.text,
                                                    'price': _servicePrice.text,
                                                    'description':
                                                        _serviceDescription
                                                            .text,
                                                    'duration':
                                                        _serviceDuration.text
                                                  });
                                                  Navigator.of(context).pop();
                                                  setState(() {});
                                                } catch (e) {
                                                  log(e.toString());
                                                }
                                              },
                                              child: const Text('Add')),
                                        ],
                                      );
                                    }).then((value) {
                                  setState(() {});
                                });
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

  // ignore: non_constant_identifier_names
  Widget ServiceCard(int index) {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(),
      showBadge: true,
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete ${services[index]}?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _firestore
                            .collection('users')
                            .doc(currentUser!.uid)
                            .collection('services')
                            .doc(services[index])
                            .delete()
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No')),
                ],
              );
            });
      },
      badgeContent: const Icon(
        Icons.close_rounded,
        color: Colors.white,
        size: 15,
      ),
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
                        services[index],
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      serviceDescription.isEmpty
                          ? Text(" - Edit")
                          : Text(" - ${serviceDescription[index]}"),
                    ],
                  ),
                  const Spacer(),
                  serviceDescription.isEmpty
                      ? Text('Edit')
                      : Text(serviceDescription[index]),
                ],
              ),
              Column(
                children: [
                  servicePrice.isEmpty
                      ? Text('Edit')
                      : Text("${servicePrice[index]} Php")
                ],
              )
            ],
          )),
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
