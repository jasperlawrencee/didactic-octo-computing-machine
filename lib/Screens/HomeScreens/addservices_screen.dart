import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/servicenames.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String addText = 'ADD';
  List<String> serviceTypes = [
    'Hair',
    'Makeup',
    'Spa',
    'Nails',
    'Lashes',
    'Wax',
  ];
  String selectedServiceType = '';
  String serviceTypeValue = '';
  final TextEditingController _servicePrice = TextEditingController();
  final TextEditingController _serviceDuration = TextEditingController();
  final TextEditingController _serviceDescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Background(
              child: Container(
        margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
        child: Column(
          children: [
            Text(
              "Add Service".toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: defaultPadding),
            const Row(
              children: [
                Text(
                  'Select Service Type',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
              decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(50)),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedServiceType.isEmpty ? null : selectedServiceType,
                items: serviceTypes.isNotEmpty
                    ? serviceTypes.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 14),
                            ));
                      }).toList()
                    : <DropdownMenuItem<String>>[],
                onChanged: (value) {
                  setState(() {
                    serviceTypeValue = '';
                    selectedServiceType = value!;
                  });
                },
              ),
            ),
            if (selectedServiceType.toLowerCase() == 'hair')
              serviceDropdown(ServiceNames().hair),
            if (selectedServiceType.toLowerCase() == 'makeup')
              serviceDropdown(ServiceNames().makeup),
            if (selectedServiceType.toLowerCase() == 'spa')
              serviceDropdown(ServiceNames().spa),
            if (selectedServiceType.toLowerCase() == 'nails')
              serviceDropdown(ServiceNames().nails),
            if (selectedServiceType.toLowerCase() == 'lashes')
              serviceDropdown(ServiceNames().lashes),
            if (selectedServiceType.toLowerCase() == 'wax')
              serviceDropdown(ServiceNames().wax),
            const SizedBox(height: defaultPadding),
            const Row(
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            flatTextField('Serivce Price', _servicePrice),
            const SizedBox(height: defaultPadding),
            const Row(
              children: [
                Text(
                  'Duration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            flatTextField('Serivce Duration', _serviceDuration),
            const SizedBox(height: defaultPadding),
            const Row(
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            flatTextField('Serivce Description', _serviceDescription),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('BACK')),
                TextButton(
                    onPressed: () async {
                      if (await isServiceExisting(
                              selectedServiceType, serviceTypeValue) ==
                          true) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Service Already Exists'),
                            action: SnackBarAction(
                                label: 'Close', onPressed: () {}),
                          ));
                        }
                      } else if (await isServiceExisting(
                              selectedServiceType, serviceTypeValue) ==
                          false) {
                        addServicesToFirestore(
                                selectedServiceType,
                                serviceTypeValue,
                                _servicePrice.text.isEmpty
                                    ? ''
                                    : _servicePrice.text,
                                _serviceDuration.text.isEmpty
                                    ? ''
                                    : _serviceDuration.text,
                                _serviceDescription.text.isEmpty
                                    ? ''
                                    : _serviceDescription.text)
                            .then((value) async {
                          setState(() {
                            addText = 'waiting for upload'.toUpperCase();
                          });
                          await Future.delayed(const Duration(seconds: 6));
                          if (mounted) {
                            Navigator.of(context).pop();
                            setState(() {});
                          }
                        });
                      }
                    },
                    child: Text(addText))
              ],
            )
          ],
        ),
      ))),
    );
  }

  Future<void> addServicesToFirestore(String serviceType, String serviceName,
      String? serivcePrice, serviceDuration, serviceDescription) async {
    try {
      //add sa categories subcollection
      if (await isServiceExisting(serviceType, serviceName)) {
        _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .collection('categories')
            .doc(serviceType)
            .update({serviceName: ''});
      } else {
        _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .collection('categories')
            .doc(serviceType)
            .set({serviceName: ''}, SetOptions(merge: true));
      }
      //add sa services subcollection
      if (await isServiceExisting(serviceType, serviceName)) {
        _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .collection('services')
            .doc(serviceType)
            .set({'doc': ''}, SetOptions(merge: true));
      }
      _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .doc(serviceType)
          .collection('${currentUser!.uid}services')
          .doc(serviceName)
          .set({
        'description': serviceDescription,
        'duration': serviceDuration,
        'price': serivcePrice,
      }, SetOptions(merge: true));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> isServiceExisting(String serviceType, String serviceName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('categories')
          .where(serviceName, isEqualTo: "")
          .limit(1)
          .get();
      CollectionReference collectionReference = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .doc(serviceType)
          .collection('${currentUser!.uid}services');
      DocumentSnapshot documentSnapshot =
          await collectionReference.doc(serviceName).get();
      return (querySnapshot.docs.isNotEmpty &&
          documentSnapshot.exists); // True if service already exists
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('An Error Occured'),
          action: SnackBarAction(label: 'Close', onPressed: () {}),
        ));
      }
      log(e.toString());
      return false;
    }
  }

  Widget serviceDropdown(List<String> services) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        const Row(
          children: [
            Text(
              'Select Service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
            decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(50)),
            child: DropdownButton<String>(
              isExpanded: true,
              value: serviceTypeValue.isEmpty ? null : serviceTypeValue,
              items: services.isNotEmpty
                  ? services.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(fontSize: 14),
                          ));
                    }).toList()
                  : <DropdownMenuItem<String>>[],
              onChanged: (value) => setState(() {
                try {
                  serviceTypeValue = value!;
                } catch (e) {
                  log(e.toString());
                }
              }),
            )),
      ],
    );
  }
}
