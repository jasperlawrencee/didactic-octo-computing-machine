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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String representativeID = '';
  String businessPermit = '';
  String secondaryLicense = '';
  String outsideSalon = '';
  String insideSalon = '';
  List skills = [];
  Map<String, dynamic> existDoc = {'field': ''};
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Background(
        child: Scaffold(
      key: _scaffoldKey,
      body: Container(
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
                              showServices(context, salonForm.hair, 'Hair'),
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
                              showServices(context, salonForm.makeup, 'Makeup'),
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
                              showServices(context, salonForm.spa, 'Spa'),
                            ],
                          ),
                          const SizedBox(height: defaultPadding),
                        ],
                      ),
                    if (salonForm.isNailsClicked && salonForm.nails.isNotEmpty)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Nails'),
                              showServices(context, salonForm.nails, 'Nails'),
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
                              showServices(context, salonForm.lashes, 'Lashes'),
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
                              showServices(context, salonForm.wax, 'Wax'),
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
                                        background: Colors.white,
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
                                  onPressed: () {
                                    Navigator.pop(context);
                                    try {
                                      uploadFormsToFirebase();
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                  },
                                  child: const Text('Yes')),
                            ],
                          ),
                        );
                      });
                }, isUploading ? 'Waiting For Upload' : 'Confirm'),
                const SizedBox(height: defaultPadding),
              ],
            ),
          )),
    ));
  }

  void uploadFormsToFirebase() async {
    doEverything();
    //hair
    addServicesToFirebase(salonForm.isHairClicked, salonForm.hair, 'Hair');
    //makeup
    addServicesToFirebase(
        salonForm.isMakeupClicked, salonForm.makeup, 'Makeup');
    //spa
    addServicesToFirebase(salonForm.isSpaClicked, salonForm.spa, 'Spa');
    //nails
    addServicesToFirebase(salonForm.isNailsClicked, salonForm.nails, 'Nails');
    //lashes
    addServicesToFirebase(
        salonForm.isLashesClicked, salonForm.lashes, 'Lashes');
    //wax
    addServicesToFirebase(salonForm.isWaxClicked, salonForm.wax, 'Wax');
    setState(() {
      isUploading = true;
    });
    await Future.delayed(const Duration(seconds: 10));
    setState(() {
      isUploading = false;
    });
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return const SalonSummaryScreen();
      },
    ), (route) => route.isFirst);
  }

  InkWell showServices(BuildContext context, List services, String title) {
    return InkWell(
      onTap: () {
        services.isNotEmpty
            ? showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title),
                        const Text(
                          '*You need to setup your service(s) after logging in',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
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
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('bookings')
        .add({
      'customerID': '',
      'clientID': '',
      'services': '',
      'date': '',
      'time': '',
      'status': '',
    });
    //adds "salon" to firebase cloud storage
    addRoleToFireStore();
    //adds imageUrl to firebase storage and step1 document in firebase cloud
    addStep1Image();
    //adds images to firebase storage
    addStep2Image();
  }

  addServicesToFirebase(
      bool serviceClicked, List servicesList, String serviceType) async {
    if (serviceClicked) {
      try {
        for (String fieldNames in servicesList) {
          Map<String, dynamic> serviceFields = {
            'price': '',
            'duration': '',
            'description': '',
            'image': '',
          };
          Map<String, dynamic> addFields = {};
          //add services to categories collection para kuhaon lang sa frontend ang names sa services in an array-like
          for (String fieldNames in servicesList) {
            addFields[fieldNames] = '';
          }
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('categories')
              .doc(serviceType)
              .set(addFields, SetOptions(merge: true));
          //??way buot firebase
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('services')
              .doc(serviceType)
              .set({'doc': ''});
          //add services to services dapat naa na tanan shit
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('services')
              .doc(serviceType)
              .collection('${currentUser!.uid}services')
              .doc(fieldNames)
              .set(serviceFields);
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Map<String, dynamic> step1() => {
        'name': salonForm.salonName,
        'room_bldg': salonForm.roomBuilding,
        'street': salonForm.streetRoad,
        'brgy': salonForm.barangay,
        'city': salonForm.city,
        'address':
            "${salonForm.roomBuilding} ${salonForm.streetRoad} ${salonForm.barangay} ${salonForm.city}",
        'salonOwner': salonForm.salonOwner,
        'salonNumber': salonForm.salonNumber,
        'salonRepresentative': salonForm.salonRepresentative,
        'representativeEmail': salonForm.representativeEmail,
        'representativeNum': salonForm.representativeNum,
        'profilePicture': '',
        'rating': double.parse('0.0'),
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
                        background: Colors.white,
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
