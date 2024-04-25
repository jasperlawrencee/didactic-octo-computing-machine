// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:badges/badges.dart' as badges;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/salon_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/add_staff.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  bool isEditing = false;
  File? profileImage;

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
          child: Column(
            children: [
              Text(
                "Profile".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isEditing == false
                            ? isEditing = true
                            : isEditing = false;
                      });
                    },
                    icon: Icon(
                      isEditing ? Icons.close : Icons.edit_document,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              FutureBuilder<Client?>(
                future: getClientDetails(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //salon name and picture
                            badges.Badge(
                                badgeContent: const Icon(
                                  Icons.edit,
                                  color: kPrimaryLightColor,
                                  size: 15,
                                ),
                                onTap: pickImage,
                                showBadge: isEditing,
                                badgeStyle: const badges.BadgeStyle(
                                    badgeColor: kPrimaryColor),
                                child: salonCard(Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    data.profilePicutre.isNotEmpty
                                        ? CircleAvatar(
                                            radius: 45,
                                            backgroundImage: NetworkImage(
                                                data.profilePicutre),
                                          )
                                        : const CircleAvatar(
                                            radius: 45,
                                            child: Text('?'),
                                          ),
                                    Text(
                                      data.name,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ))),
                            //salon address
                            badges.Badge(
                              badgeContent: const Icon(
                                Icons.edit,
                                color: kPrimaryLightColor,
                                size: 15,
                              ),
                              onTap: () {},
                              showBadge: isEditing,
                              badgeStyle: const badges.BadgeStyle(
                                  badgeColor: kPrimaryColor),
                              child: salonCard(Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.location_city_rounded,
                                    color: kPrimaryColor,
                                    size: 50,
                                  ),
                                  Text(
                                    data.address,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        data.role == 'salon'
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Staff',
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        isEditing
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return const AddStaff();
                                                    },
                                                  ));
                                                },
                                                child: const Icon(
                                                  Icons.add,
                                                  color: kPrimaryColor,
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: _firestore
                                          .collection('users')
                                          .doc(currentUser!.uid)
                                          .collection('staff')
                                          .snapshots(),
                                      builder: (context, staff) {
                                        if (staff.hasData) {
                                          List<Staff> staffList =
                                              staff.data!.docs.map((doc) {
                                            Map<String, dynamic> data = doc
                                                .data() as Map<String, dynamic>;
                                            return Staff(
                                                name: data['name'],
                                                position: data['role']);
                                          }).toList();
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: staffList.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                onTap: () {
                                                  //view details
                                                },
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(staffList[index].name),
                                                    const Text('-'),
                                                    Text(staffList[index]
                                                        .position)
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Client?> getClientDetails() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      if (doc.exists) {
        if (doc['role'] == 'freelancer') {
          return Client(
            address: doc['address'],
            gender: doc['gender'],
            birthday: doc['birthday'],
            email: doc['email'],
            name: doc['name'],
            primaryPhoneNum: doc['primaryPhoneNumber'],
            secondaryPhoneNum: doc['secondaryPhoneNumber'],
            role: doc['role'],
            rating: double.parse(doc['rating']),
            profilePicutre: doc['profilePicture'],
          );
        } else if (doc['role'] == 'salon') {
          return Client(
            address: doc['address'],
            email: doc['email'],
            name: doc['name'],
            salonNumber: doc['salonNumber'],
            salonOwner: doc['salonOwner'],
            salonRepresentative: doc['salonRepresentative'],
            role: doc['role'],
            rating: double.parse(doc['rating']),
            profilePicutre: doc['profilePicture'],
          );
        }
      }
    } catch (e) {
      log('error getting worker details $e');
      return null;
    }
    return null;
  }

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File? img = File(image.path);
      img = await addtoFirebaseAfterCrop(img);
      Navigator.of(context).pop();
      setState(() {
        profileImage = img;
      });
    } on PlatformException catch (e) {
      log(e.toString());
      Navigator.of(context).pop();
    }
  }

  addtoFirebaseAfterCrop(File imgFile) async {
    try {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      );
      if (croppedImage == null) {
        return null;
      } else {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child('salonImage')
            .child(currentUser!.uid)
            .child('profilePicture');
        await reference.putFile(File(croppedImage.path));
        final profilePictureUrl = await reference.getDownloadURL();
        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .update({'profilePicture': profilePictureUrl}).then((value) {
          log('uploaded profile picture');
        });
        return File(croppedImage.path);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Container salonCard(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: defaultPadding, horizontal: defaultPadding / 2),
      height: 160,
      width: 150,
      decoration: const BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: child,
    );
  }

  Future<List<String>> getCertificates() async {
    try {
      List<String> certs = [];
      return certs;
    } catch (e) {
      log('error getting certificate links $e');
      return [];
    }
  }
}

class Staff {
  final String name;
  final String position;

  Staff({
    required this.name,
    required this.position,
  });
}
