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
              //listview builder dapat ni
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
      child: InkWell(
        onTap: () {
          log('pressed ${services[index]}');
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
      ),
    );
  }
}
