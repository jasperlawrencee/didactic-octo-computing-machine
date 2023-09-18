import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<String> service = [];
  List<String> serviceType = [];
  @override
  void initState() {
    super.initState();
    getServiceType();
    getService();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 20),
                  Text(
                    "Services".toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: kPrimaryColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.edit_note,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: ListView(
                  children: serviceType.map((wiwi) {
                    return serviceCard('Hair', wiwi.toString());
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// gets the specific service of the worker
// in this example we only grabbed the services under the hair category
// wala pani nahuman pls intawon
  void getService() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('uesrs')
          .doc(currentUser!.uid)
          .collection('step2')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> getDocName =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          service = getDocName.keys.toList();
        });
      }
    } catch (e) {
      log('error: $e');
    }
  }

// gets the service type of the worker ie(hair, nails, wax, etc)
  void getServiceType() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('userDetails')
          .doc('step2')
          .get();
      if (documentSnapshot.exists) {
        List<dynamic> hairField = documentSnapshot['hair'];
        setState(() {
          serviceType = hairField.map((item) => item as String).toList();
        });
      }
    } catch (e) {
      log('error: $e');
    }
  }

  Widget serviceCard(String service, String serviceType) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: defaultPadding),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kPrimaryLightColor,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              service,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(serviceType),
          ),
          const Spacer(),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text('price-range'),
          ),
        ],
      ),
    );
  }
}
