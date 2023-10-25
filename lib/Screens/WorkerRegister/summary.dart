import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';
import 'package:flutter_auth/Screens/WorkerRegister/verification.dart';
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
  CollectionReference? imgRef;
  DocumentReference? urlRef;
  String governmentID = '';
  String vaccinationCard = '';
  String nbiClearance = '';
  List<String> certificates = [];

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('userDetails');
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            const Text(
              'Summary',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            const Text(
              'User Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'First Name',
                ),
                Text(workerForm.firstName.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Middle Name',
                ),
                Text(workerForm.middleName.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Last Name',
                ),
                Text(workerForm.lastName.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Gender',
                ),
                Text(workerForm.gender.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            const Text(
              'Contact Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Primary Phone Number',
                ),
                Text(workerForm.phoneNum1.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Secondary Phone Number',
                ),
                Text(workerForm.phoneNum2.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            const Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'City',
                ),
                Text(workerForm.city.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Barangay',
                ),
                Text(workerForm.barangay.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Street Address',
                ),
                Text(workerForm.stAddress.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Extended Address',
                ),
                Text(workerForm.extAddress.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            if (workerForm.isHairClicked ||
                workerForm.isMakeupClicked ||
                workerForm.isSpaClicked ||
                workerForm.isNailsClicked ||
                workerForm.isLashesClicked ||
                workerForm.isWaxClicked)
              const Text(
                'Service Category',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            if (workerForm.isHairClicked && workerForm.hair.isNotEmpty)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Hair'),
                      showServices(context, workerForm.hair),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            if (workerForm.isMakeupClicked && workerForm.makeup.isNotEmpty)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Makeup'),
                      showServices(context, workerForm.makeup),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            if (workerForm.isSpaClicked && workerForm.spa.isNotEmpty)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Spa'),
                      showServices(context, workerForm.spa),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            if (workerForm.isNailsClicked && workerForm.nails.isNotEmpty)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nails'),
                      showServices(context, workerForm.nails),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            if (workerForm.isLashesClicked && workerForm.lashes.isNotEmpty)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Lashes'),
                      showServices(context, workerForm.lashes),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            if (workerForm.isWaxClicked && workerForm.wax.isNotEmpty)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Wax'),
                      showServices(context, workerForm.wax),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            const Text(
              'Experiences',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Salon Name',
                ),
                Text(workerForm.experienceName.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Salon Address',
                ),
                Text(workerForm.experienceAddress.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Salon Contact Number',
                ),
                Text(workerForm.experienceNum.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Duration',
                ),
                Text(workerForm.selectedDays.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            const Text(
              'Requirements',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TIN ID'),
                Text(workerForm.tinID.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Government ID',
                ),
                InkWell(
                  onTap: () {
                    showImage(workerForm.governmentID);
                  },
                  child: const Text(
                    'Preview',
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vaccination Card/Certificate',
                ),
                InkWell(
                  onTap: () {
                    showImage(workerForm.vaxCard);
                  },
                  child: const Text(
                    'Preview',
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'NBI Clearnace',
                ),
                InkWell(
                  onTap: () {
                    showImage(workerForm.nbiClearance);
                  },
                  child: const Text(
                    'Preview',
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Certificates',
                ),
                InkWell(
                  onTap: () {
                    try {
                      workerForm.certificates!.isNotEmpty
                          ? showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    height:
                                        MediaQuery.of(context).size.height / 1,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount:
                                            workerForm.certificates!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              Image.file(File(workerForm
                                                  .certificates![index].path)),
                                              Container(height: 1),
                                            ],
                                          );
                                        }),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Close'))
                                  ],
                                );
                              })
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                'No image(s) provided',
                              ),
                              action: SnackBarAction(
                                  label: 'Close', onPressed: () {}),
                            ));
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  child: const Text(
                    'Preview',
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(height: defaultPadding),
            nextButton(context, () async {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const WorkerSummaryScreen();
              }));

              try {
                //adds "freelancer" to firebase cloud storage
                addRoleToFireStore();
                addStep1();
                addStep2();
                addStep3();
                addStep4();
              } catch (e) {
                log(e.toString());
              }
            }, 'Confirm'),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    ));
  }

  Map<String, dynamic> step1() => {
        'firstName': workerForm.firstName,
        'middleName': workerForm.middleName,
        'lastName': workerForm.lastName,
        'gender': workerForm.gender,
        'primaryPhoneNumber': workerForm.phoneNum1,
        'secondaryPhoneNumber': workerForm.phoneNum2,
        'city': workerForm.city,
        'barangay': workerForm.barangay,
        'streetAddress': workerForm.stAddress,
        'extendedStAddress': workerForm.extAddress,
      };

  Map<String, dynamic> step2() => {
        if (workerForm.isHairClicked) 'hair': workerForm.hair,
        if (workerForm.isMakeupClicked) 'makeup': workerForm.makeup,
        if (workerForm.isSpaClicked) 'spa': workerForm.spa,
        if (workerForm.isNailsClicked) 'nails': workerForm.nails,
        if (workerForm.isLashesClicked) 'lashes': workerForm.lashes,
        if (workerForm.isWaxClicked) 'wax': workerForm.wax,
      };

  Map<String, dynamic> step3() => {
        'salonName': workerForm.experienceName,
        'salonAddress': workerForm.experienceAddress,
        'salonContactNumber': workerForm.experienceNum,
        'experienceDuration': workerForm.selectedDays,
      };

  addStep1() {
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('userDetails')
        .doc('step1')
        .set(step1())
        .whenComplete(() => log('added step1'))
        .onError((error, stackTrace) => null);
  }

  addStep2() {
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('userDetails')
        .doc('step2')
        .set(step2())
        .whenComplete(() => log('added step2'))
        .onError((error, stackTrace) => null);
  }

  addStep3() {
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('userDetails')
        .doc('step3')
        .set(step3())
        .whenComplete(() => log('added step3'))
        .onError((error, stackTrace) => null);
  }

  addStep4() async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages =
        referenceRoot.child('freelancerImages').child(currentUser!.uid);
    Reference governmentIDImage = referenceDirImages.child('governmentID');
    Reference vaccinationCardImage =
        referenceDirImages.child('vaccinationCard');
    Reference nbiClearanceImage = referenceDirImages.child('nbiClearance');
    Reference certificatesImage = referenceDirImages.child('certificates');

    await governmentIDImage.putFile(workerForm.governmentID!);
    await vaccinationCardImage.putFile(workerForm.vaxCard!);
    await nbiClearanceImage.putFile(workerForm.nbiClearance!);
    if (workerForm.certificates!.isNotEmpty) {
      for (int i = 0; i < workerForm.certificates!.length; i++) {
        await certificatesImage
            .putFile(File(workerForm.certificates![i].path))
            .whenComplete(() async {
          await certificatesImage.getDownloadURL().then((value) => {
                imgRef!.doc('step4').set({'certificates': value})
                // urlRef!
                //     .collection('users')
                //     .doc(currentUser!.uid)
                //     .collection('userDetails')
                //     .doc('step4')
                //     .set({'url': value})
              });
        });
      }
    }

    governmentID = await governmentIDImage.getDownloadURL();
    vaccinationCard = await vaccinationCardImage.getDownloadURL();
    nbiClearance = await nbiClearanceImage.getDownloadURL();
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('userDetails')
        .doc('step4')
        .set({
          'governmentID': governmentID,
          'vaccinationCard': vaccinationCard,
          'nbiClearance': nbiClearance,
          'tinID': workerForm.tinID,
        })
        .whenComplete(() => log('added step4'))
        .onError((error, stackTrace) => null);
    log('added step4');
  }

  addRoleToFireStore() {
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    try {
      ref.doc(user!.uid).update({'role': 'freelancer'});
      log("added pending role to firestore");
    } catch (e) {
      log("$user $ref");
      log(e.toString());
    }
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
