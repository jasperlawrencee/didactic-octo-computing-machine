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
  List<String> serviceNames = [];

  @override
  void initState() {
    super.initState();
    getServiceName();
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
                child: ListView(children: [
                  serviceCard("serviceNames", "description", "₱100")
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceCard(
      String serviceName, String serviceType, String priceRange) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: defaultPadding),
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kPrimaryLightColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            serviceName,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(serviceType),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(priceRange),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () => {},
              child: const Text(
                'Edit',
                style: TextStyle(
                    color: kPrimaryColor, decoration: TextDecoration.underline),
              ),
            ),
          )
        ],
      ),
    );
  }

  void getServiceName() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .get();
      List<String> documentNames =
          querySnapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        serviceNames = documentNames;
      });
      log(serviceNames.toString());
    } catch (e) {
      log(e.toString());
    }
  }
}
