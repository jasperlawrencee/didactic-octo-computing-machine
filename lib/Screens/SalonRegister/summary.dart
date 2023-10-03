import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/SalonRegister/register_stepper.dart';
import 'package:flutter_auth/Screens/SalonRegister/verification.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

class Summary extends StatefulWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  final _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String uniqueID = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Container(
            // height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding),
                  const Text(
                    'Summary',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: defaultPadding),
                      const Text(
                        "Salon Data",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Salon Name',
                          ),
                          Text(salonForm.salonName.toString()),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Room No./Building',
                          ),
                          Text(salonForm.roomBuilding.toString()),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Barangay',
                          ),
                          Text(salonForm.barangay.toString()),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'City',
                          ),
                          Text(salonForm.city.toString()),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      const Text(
                        "Salon Details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Salon Owner Name',
                          ),
                          Text(salonForm.salonOwner.toString()),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Salon Contact Number',
                          ),
                          Text(salonForm.salonNumber.toString()),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Salon Representative Name',
                          ),
                          Text(salonForm.salonRepresentative.toString()),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Representative Email Address',
                          ),
                          Text(salonForm.representativeEmail.toString()),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Representative Contact Number',
                          ),
                          Text(salonForm.representativeNum.toString()),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Representative ID',
                          ),
                          InkWell(
                            onTap: () {
                              showImage(salonForm.representativeID);
                            },
                            child: const Text(
                              'Preview',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      const Text(
                        "Salon Permits",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Business Permit',
                          ),
                          InkWell(
                            onTap: () {
                              showImage(salonForm.businessPermit);
                            },
                            child: const Text(
                              'Preview',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Secondary License (Mayor's Permit/BIR)",
                          ),
                          InkWell(
                            onTap: () {
                              showImage(salonForm.secondaryLicense);
                            },
                            child: const Text(
                              'Preview',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      const Text(
                        "Salon Photos",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Salon Photo - Outside",
                          ),
                          InkWell(
                            onTap: () {
                              showImage(salonForm.outsideSalonPhoto);
                            },
                            child: const Text(
                              'Preview',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Salon Photo - Inside",
                          ),
                          InkWell(
                            onTap: () {
                              showImage(salonForm.insideSalonPhoto);
                            },
                            child: const Text(
                              'Preview',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                    ],
                  ),
                  nextButton(context, () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Theme(
                            data: ThemeData(
                                colorScheme:
                                    Theme.of(context).colorScheme.copyWith(
                                          primary: kPrimaryColor,
                                          background: Colors.white70,
                                          secondary: kPrimaryLightColor,
                                        )),
                            child: AlertDialog(
                              title: const Text('Confirm Signup?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No')),
                                TextButton(
                                    onPressed: () async {
                                      Reference referenceRoot =
                                          FirebaseStorage.instance.ref();
                                      Reference referenceDirImages =
                                          referenceRoot.child('images');
                                      Reference referenceImageToUpload =
                                          referenceDirImages.child(uniqueID);

                                      Navigator.of(context).pop();
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const SalonSummaryScreen();
                                      }));
                                      if (salonForm.representativeID == null)
                                        return;
                                      try {
                                        //adds "salon" to firebase cloud storage
                                        addRoleToFireStore();
                                        //adds all singup text "String" data to firebase cloud storage
                                        await _firestore
                                            .collection('users')
                                            .doc(currentUser!.uid)
                                            .collection('userDetails')
                                            .doc('step1')
                                            .set(step1());
                                        //add images to firebase storage
                                        await referenceImageToUpload.putFile(
                                            salonForm.representativeID!);
                                        //get image url
                                        imageUrl = await referenceImageToUpload
                                            .getDownloadURL();
                                        //add imageUrl to firebase cloud storage
                                        await _firestore
                                            .collection('users')
                                            .doc(currentUser!.uid)
                                            .collection('userDetails')
                                            .doc('step1')
                                            .update({'imageUrl': imageUrl});
                                      } catch (e) {
                                        log(e.toString());
                                      }
                                    },
                                    child: const Text('Yes')),
                              ],
                            ),
                          );
                        });
                  }, 'Confirm'),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            )));
  }

  Map<String, dynamic> step1() => {
        'salonName': salonForm.salonName,
        'roomBuilding': salonForm.roomBuilding,
        'streetRoad': salonForm.streetRoad,
        'barangay': salonForm.barangay,
        'city': salonForm.city,
        'salonOwner': salonForm.salonOwner,
        'salonNumber': salonForm.salonNumber,
        'salonRepresentative': salonForm.salonRepresentative,
        'representativeEmail': salonForm.representativeEmail,
        'representativeNum': salonForm.representativeNum,
        // 'representativeID':
        // 'businessPermit':
        // 'secondaryLicense':
        // 'outsideSalonPhoto':
        // 'insideSalonPhoto':
      };

  addRoleToFireStore() {
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    try {
      ref.doc(user!.uid).update({'role': 'salon'});
      log("added salon role to firestore");
    } catch (e) {
      log("$user $ref");
      log(e.toString());
    }
  }

  showImage(File? image) {
    if (image != null) {
      showDialog(
          context: context,
          builder: ((context) {
            return Theme(
              data: ThemeData(
                  canvasColor: Colors.transparent,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: kPrimaryColor,
                        background: Colors.white70,
                        secondary: kPrimaryLightColor,
                      )),
              child: AlertDialog(
                content: Image.file(image),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'))
                ],
              ),
            );
          }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('No image provided'),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
    }
  }
}
