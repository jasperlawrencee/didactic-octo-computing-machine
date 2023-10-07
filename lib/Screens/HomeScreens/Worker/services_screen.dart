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
  List<Map<String, dynamic>> arrayData = [];
  List<List<Map<String, dynamic>>> arrayOfArrays = [];

  @override
  void initState() {
    super.initState();
    getAllInDocument();
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
                child: ListView(children: [
                  for (var arrayData in arrayOfArrays)
                    for (var item in arrayData)
                      serviceCard('${item['name']}'.toUpperCase(),
                          '${item['value']}', '(priceRange)')
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
              onTap: () => editServiceCard(serviceName, serviceType, context),
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

  String? editValue;
  Future<void> editServiceCard(
      String title, String service, BuildContext context) {
    //dapat naa diri tong gikan sa firebase
    List<String> serviceName = [];
    return showDialog(
        context: context,
        builder: ((context) {
          return Theme(
            data: ThemeData(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: kPrimaryColor,
                      background: Colors.white70,
                      secondary: kPrimaryLightColor,
                    )),
            child: AlertDialog(
              title: Text('Edit $title - $service'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      Column(
                        children: [
                          DropdownButton<String>(
                            items: serviceName.map(buildMenuItem).toList(),
                            onChanged: (value) => setState(() {
                              editValue = value;
                            }),
                          )
                        ],
                      );
                    },
                    child: const Text('Edit')),
              ],
            ),
          );
        }));
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );

  getAllInDocument() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('userDetails')
          .doc('step2')
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> documentData =
            documentSnapshot.data() as Map<String, dynamic>;
        documentData.forEach((fieldName, fieldValue) {
          if (fieldValue is List) {
            //convert array to a list of maps with label
            setState(() {
              arrayData = fieldValue.map((item) {
                return {'name': fieldName, 'value': item};
              }).toList();
              arrayOfArrays.add(arrayData);
            });
          }
        });
      } else {
        return [];
      }
    } catch (e) {
      log('error: $e');
    }
  }
}
