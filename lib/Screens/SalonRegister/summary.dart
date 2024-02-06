// ignore_for_file: use_build_context_synchronously

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
  String representativeID = '';
  String businessPermit = '';
  String secondaryLicense = '';
  String outsideSalon = '';
  String insideSalon = '';
  List skills = [];
  Map<String, dynamic> existDoc = {'field': ''};
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
                            'Street/Road',
                          ),
                          Text(salonForm.streetRoad.toString()),
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
                      if (salonForm.isHairClicked ||
                          salonForm.isMakeupClicked ||
                          salonForm.isSpaClicked ||
                          salonForm.isNailsClicked ||
                          salonForm.isLashesClicked ||
                          salonForm.isWaxClicked)
                        const Text(
                          'Service Category',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      if (salonForm.isHairClicked && salonForm.hair.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Hair'),
                                showServices(context, salonForm.hair),
                              ],
                            ),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                      if (salonForm.isMakeupClicked &&
                          salonForm.makeup.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Makeup'),
                                showServices(context, salonForm.makeup),
                              ],
                            ),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                      if (salonForm.isSpaClicked && salonForm.spa.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Spa'),
                                showServices(context, salonForm.spa),
                              ],
                            ),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                      if (salonForm.isNailsClicked &&
                          salonForm.nails.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Nails'),
                                showServices(context, salonForm.nails),
                              ],
                            ),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                      if (salonForm.isLashesClicked &&
                          salonForm.lashes.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Lashes'),
                                showServices(context, salonForm.lashes),
                              ],
                            ),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                      if (salonForm.isWaxClicked && salonForm.wax.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Wax'),
                                showServices(context, salonForm.wax),
                              ],
                            ),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
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
                                      try {
                                        Navigator.of(context).pop();
                                        if (doEverything() ==
                                            ConnectionState.waiting) {
                                          const AlertDialog(
                                            content: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 150,
                                                  height: 150,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return const SalonSummaryScreen();
                                          }));
                                        }
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

  InkWell showServices(BuildContext context, List services) {
    return InkWell(
      onTap: () {
        services.isNotEmpty
            ? showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width / 1,
                      height: MediaQuery.of(context).size.height / 4,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: services.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Text(services[index]),
                              Container(height: defaultPadding),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                })
            : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'No image(s) provided',
                ),
                action: SnackBarAction(label: 'Close', onPressed: () {}),
              ));
      },
      child: const Text(
        'View',
        style: TextStyle(
            color: kPrimaryColor, decoration: TextDecoration.underline),
      ),
    );
  }

  doEverything() async {
    await Future.delayed(const Duration(seconds: 10));
    //adds all singup text "String" data to firebase cloud storage
    await _firestore.collection('users').doc(currentUser!.uid).set(step1());
    if (salonForm.isHairClicked) {
      try {
        for (String fieldNames in salonForm.hair) {
          Map<String, dynamic> hairFields = {
            'price': '',
            'duration': '',
            'description': '',
          };
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc('Hair')
              .set(existDoc);
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc('Hair')
              .collection('${currentUser!.uid}services')
              .doc(fieldNames)
              .set(hairFields);
        }
      } catch (e) {
        log(e.toString());
      }
      skills.addAll(salonForm.hair);
    }
    if (salonForm.isMakeupClicked) {
      try {
        for (String fieldNames in salonForm.makeup) {
          Map<String, dynamic> makeupFields = {
            'price': '',
            'duration': '',
            'description': '',
          };
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc('Makeup')
              .set(existDoc);
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc('Makeup')
              .collection('${currentUser!.uid}services')
              .doc(fieldNames)
              .set(makeupFields);
        }
      } catch (e) {
        log(e.toString());
      }
      skills.addAll(salonForm.makeup);
    }
    if (salonForm.isSpaClicked) {
      for (String fields in salonForm.spa) {
        Map<String, dynamic> spaFields = {
          'price': '',
          'duration': '',
          'description': '',
        };
        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .collection('categories')
            .doc('Spa')
            .set(existDoc);
        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .collection('categories')
            .doc('Spa')
            .collection('${currentUser!.uid}services')
            .doc(fields)
            .set(spaFields);
      }
      skills.addAll(salonForm.spa);
    }
    if (salonForm.isNailsClicked) {
      try {
        for (String fieldNames in salonForm.nails) {
          Map<String, dynamic> nailsFields = {
            'price': '',
            'duration': '',
            'description': '',
          };
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc('Nails')
              .set(existDoc);
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc('Nails')
              .collection('${currentUser!.uid}services')
              .doc(fieldNames)
              .set(nailsFields);
        }
      } catch (e) {
        log(e.toString());
      }
      skills.addAll(salonForm.nails);
    }
    if (salonForm.isLashesClicked) {
      try {
        for (String fieldNames in salonForm.lashes) {
          Map<String, dynamic> lashesFields = {
            'price': '',
            'duration': '',
            'description': '',
          };
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc('Lashes')
              .set(existDoc);
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc('Lashes')
              .collection('${currentUser!.uid}services')
              .doc(fieldNames)
              .set(lashesFields);
        }
      } catch (e) {
        log(e.toString());
      }
      skills.addAll(salonForm.lashes);
    }
    if (salonForm.isWaxClicked) {
      try {
        for (String fieldNames in salonForm.wax) {
          Map<String, dynamic> waxFields = {
            'price': '',
            'duration': '',
            'description': '',
          };
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc('Wax')
              .set(existDoc);
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc('Wax')
              .collection('${currentUser!.uid}services')
              .doc(fieldNames)
              .set(waxFields);
        }
      } catch (e) {
        log(e.toString());
      }
      skills.addAll(salonForm.wax);
    }
    //adds "salon" to firebase cloud storage
    addRoleToFireStore();
    //adds imageUrl to firebase storage and step1 document in firebase cloud
    addStep1Image();
    //adds images to firebase storage
    addStep2Image();
  }

  Map<String, dynamic> step1() => {
        'name': salonForm.salonName,
        'address':
            "${salonForm.roomBuilding} ${salonForm.barangay} ${salonForm.streetRoad} ${salonForm.city}",
        'salonOwner': salonForm.salonOwner,
        'salonNumber': salonForm.salonNumber,
        'salonRepresentative': salonForm.salonRepresentative,
        'representativeEmail': salonForm.representativeEmail,
        'representativeNum': salonForm.representativeNum,
      };

  Map<String, dynamic> step2() => {
        'businessPermit': businessPermit,
        'secondaryLicense': secondaryLicense,
        'outsideSalon': outsideSalon,
        'insideSalon': insideSalon,
      };

  Map<String, dynamic> step3() => {
        if (salonForm.isHairClicked) 'skills': skills,
        if (salonForm.isMakeupClicked) 'skills': skills,
        if (salonForm.isSpaClicked) 'skills': skills,
        if (salonForm.isNailsClicked) 'skills': skills,
        if (salonForm.isLashesClicked) 'skills': skills,
        if (salonForm.isWaxClicked) 'skills': skills,
      };

  addStep1Image() async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages =
        referenceRoot.child('salonImage').child(currentUser!.uid);
    Reference referenceImageToUpload =
        referenceDirImages.child('representativeID');
    //add images to firebase storage
    await referenceImageToUpload.putFile(salonForm.representativeID!);
    //get image url
    representativeID = await referenceImageToUpload.getDownloadURL();
    //add imageUrl to firebase cloud storage
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .update({'representativeID': representativeID});
  }

  addStep2Image() async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages =
        referenceRoot.child('salonImage').child(currentUser!.uid);
    Reference businessPermitImage = referenceDirImages.child('businessPermit');
    Reference secondaryLicenseImage =
        referenceDirImages.child('secondaryLicense');
    Reference outsideSalonImage = referenceDirImages.child('outsideSalonPhoto');
    Reference insideSalonImage = referenceDirImages.child('insideSalonPhoto');
    //add step2 images to firebase storage
    await businessPermitImage.putFile(salonForm.businessPermit!);
    await secondaryLicenseImage.putFile(salonForm.secondaryLicense!);
    await outsideSalonImage.putFile(salonForm.outsideSalonPhoto!);
    await insideSalonImage.putFile(salonForm.insideSalonPhoto!);
    //get step2 imageUrls
    businessPermit = await businessPermitImage.getDownloadURL();
    secondaryLicense = await secondaryLicenseImage.getDownloadURL();
    outsideSalon = await outsideSalonImage.getDownloadURL();
    insideSalon = await insideSalonImage.getDownloadURL();
    //add step2 imageUrls to firebase cloud storage
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('portfolio')
        .doc('requirements')
        .set({
      'businessPermit': businessPermit,
      'secondaryLicense': secondaryLicense,
      'outsideSalon': outsideSalon,
      'insideSalon': insideSalon,
    });
  }

  addRoleToFireStore() {
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    try {
      ref.doc(user!.uid).update({'role': 'salon', 'status': 'unverified'});
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
