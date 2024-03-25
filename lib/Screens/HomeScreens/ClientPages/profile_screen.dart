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
import 'package:flutter_auth/Screens/HomeScreens/editservices_screen.dart';
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
  var pageController = PageController();
  List<String> servicesTypes = [
    'Hair',
    'Lashes',
    'Makeup',
    'Nails',
    'Spa',
    'Wax'
  ];
  int serviceCount = 0;
  final ImagePicker picker = ImagePicker();
  File? profileImage;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    getAllServiceTypes();
    getServiceTypeCount();
  }

  Future<String> getUserName() async {
    try {
      final dbRef =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      return dbRef.data()!['name'];
    } catch (e) {
      log('error getting name $e');
    }
    return 'Empty Name';
  }

  Future<String> getUserAddress() async {
    try {
      final dbRef =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      return dbRef.data()!['address'];
    } catch (e) {
      log('error getting address $e');
    }
    return 'Empty Address';
  }

  Future<String> getProfilePicture() async {
    try {
      final dbRef =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      return dbRef.data()!['profilePicture'];
    } catch (e) {
      log('error getting profile picture $e');
    }
    return 'Empty Profile Picutre';
  }

  void getServiceTypeCount() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .get();
      querySnapshot.docs.forEach((element) {
        serviceCount++;
      });
    } catch (e) {
      log('error getting service type count: $e');
    }
  }

  //get all existing service types
  Future<List<String>> getAllServiceTypes() async {
    List<String> existingServices = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .get();

      querySnapshot.docs.forEach((element) {
        existingServices.add(element.id);
      });
      return existingServices;
    } catch (e) {
      log('Getting Service Types Error: $e');
      return [];
    }
  }

//returns all services names inside existing service types
  Future<List<List<String>>> getServiceNames() async {
    List<List<String>> serviceNames = [];
    try {
      var serviceDocuments = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .get();
      for (var docs in serviceDocuments.docs) {
        var serviceCollection =
            docs.reference.collection('${currentUser!.uid}services');
        var serviceDocs = await serviceCollection.get();
        List<String> names = [];
        for (var serviceDoc in serviceDocs.docs) {
          names.add(serviceDoc.id);
        }
        serviceNames.add(names);
      }
      return serviceNames;
    } catch (e) {
      log('Error Getting Service Names: $e');
      return [];
    }
  }

  Future<List<List<Map<String, dynamic>>>> getServiceDetails() async {
    try {
      final servicesDocuments = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .get();
      List<List<Map<String, dynamic>>> serviceData = [];
      for (final doc in servicesDocuments.docs) {
        final serviceDocs =
            await doc.reference.collection('${currentUser!.uid}services').get();
        List<Map<String, dynamic>> serviceDataList = [];
        for (final serviceDoc in serviceDocs.docs) {
          final data = {
            "description": serviceDoc.get('description'),
            "duration": serviceDoc.get("duration"),
            "price": serviceDoc.get("price"),
            "image": serviceDoc.get("image"),
          };
          serviceDataList.add(data);
        }
        serviceData.add(serviceDataList);
      }
      return serviceData;
    } catch (e) {
      log('Error getting service details: $e');
      return [];
    }
  }

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
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
                      badgeStyle:
                          const badges.BadgeStyle(badgeColor: kPrimaryColor),
                      child: salonCard(SalonInfo())),
                  //salon address
                  badges.Badge(
                    badgeContent: const Icon(
                      Icons.edit,
                      color: kPrimaryLightColor,
                      size: 15,
                    ),
                    onTap: () {},
                    showBadge: isEditing,
                    badgeStyle:
                        const badges.BadgeStyle(badgeColor: kPrimaryColor),
                    child: salonCard(SalonPlace()),
                  ),
                  //salon phone number
                ],
              ),
              const SizedBox(height: defaultPadding),
              Text(
                  'salon photo outside, salon photo inside, owner name, gcash number')
              // Expanded(
              //     child: Stack(
              //   fit: StackFit.loose,
              //   children: [
              //     servicesPageView(),
              //     Align(
              //         alignment: Alignment.bottomRight,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             FloatingActionButton(
              //                 backgroundColor: kPrimaryColor,
              //                 child: const Icon(
              //                   Icons.add,
              //                   color: kPrimaryLightColor,
              //                 ),
              //                 onPressed: () {
              //                   Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                         builder: (context) => const AddServices(),
              //                       ));
              //                 }),
              //             const SizedBox(height: defaultPadding)
              //           ],
              //         )),
              //   ],
              // )),
            ],
          ),
        ),
      ),
    );
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

//PageView Widget of Services
  Widget servicesPageView() {
    return PageView.builder(
      itemCount: serviceCount,
      itemBuilder: (context, serviceIndex) {
        return FutureBuilder<List<String>>(
          future: getAllServiceTypes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              );
            } else if (snapshot.hasError) {
              log(Error().toString());
              return Text(Error().toString());
            } else {
              return Column(
                children: [
                  //service category text widget
                  Text(
                    snapshot.data![serviceIndex].isEmpty
                        ? '???'
                        : snapshot.data![serviceIndex],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  FutureBuilder<List<List<String>>>(
                    future: getServiceNames(),
                    builder: (context, serviceNames) {
                      if (serviceNames.hasData) {
                        return FutureBuilder<List<List<Map<String, dynamic>>>>(
                          future: getServiceDetails(),
                          builder: (context, serviceDetails) {
                            if (serviceDetails.hasData) {
                              return Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        serviceNames.data![serviceIndex].length,
                                    itemBuilder: (context, index) {
                                      return badges.Badge(
                                        onTap: () {
                                          deleteService(
                                            //serviceType
                                            snapshot.data![serviceIndex],
                                            //serviceName
                                            serviceNames.data![serviceIndex]
                                                [index],
                                          );
                                        },
                                        position: badges.BadgePosition.topEnd(),
                                        showBadge: isEditing,
                                        badgeContent: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        child: InkWell(
                                          onTap: isEditing
                                              ? () => navigateToEditPage(
                                                  snapshot.data![serviceIndex],
                                                  serviceNames
                                                          .data![serviceIndex]
                                                      [index])
                                              : null,
                                          child: serviceCard(
                                            serviceNames,
                                            serviceIndex,
                                            index,
                                            serviceDetails,
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            } else if (serviceDetails.hasError) {
                              return Text('Error ${Error().toString}');
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: kPrimaryColor));
                            }
                          },
                        );
                      } else if (serviceNames.hasError) {
                        return const Text('error getting service names');
                      } else {
                        return const LinearProgressIndicator(
                            color: kPrimaryColor);
                      }
                    },
                  ),
                ],
              );
            }
          },
        );
      },
      controller: pageController,
    );
  }

  navigateToEditPage(String type, String name) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return EditServices(
          serviceType: type,
          serviceName: name,
        );
      },
    ));
  }

  Widget serviceCard(
    AsyncSnapshot<List<List<String>>> serviceNames,
    int serviceIndex,
    int index,
    AsyncSnapshot<List<List<Map<String, dynamic>>>> serviceDetails,
  ) {
    String name = serviceNames.data![serviceIndex][index];
    String duration = serviceDetails.data![serviceIndex][index]['duration'];
    String price = serviceDetails.data![serviceIndex][index]['price'];
    String image = serviceDetails.data![serviceIndex][index]['image'];
    String descrtiption =
        serviceDetails.data![serviceIndex][index]['description'];
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            image.isEmpty
                ? const Text('No Image')
                : SizedBox.square(
                    dimension: 80,
                    child: Image.network(image),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      "$name ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    duration.isEmpty
                        ? const Text('- Duration')
                        : Text("- $duration")
                  ],
                ),
                price.isEmpty ? const Text('Price') : Text(price),
                descrtiption.isEmpty
                    ? const Text('Description')
                    : Text(descrtiption),
              ],
            )
          ],
        ));
  }

  Container salonCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 160,
      width: 160,
      decoration: const BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: child,
    );
  }

  Future<void> deleteService(String serviceType, String serviceName) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete $serviceName?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No')),
            TextButton(
                onPressed: () async {
                  try {
                    DocumentReference docRef = _firestore
                        .collection('users')
                        .doc(currentUser!.uid)
                        .collection('services')
                        .doc(serviceType)
                        .collection('${currentUser!.uid}services')
                        .doc(serviceName);
                    await docRef.delete();
                    Navigator.pop(context);
                  } catch (e) {
                    log('Error deleting document $serviceName: $e');
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        );
      },
    );
  }

  Widget SalonInfo() {
    return StreamBuilder<String>(
      stream: Stream.fromFuture(getUserName()),
      builder: (context, name) {
        if (name.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          );
        } else if (name.hasError) {
          return Text('Getting Name Error ${name.error}');
        } else {
          final salonName = name.data!;
          return Column(
            children: [
              StreamBuilder<String>(
                stream: Stream.fromFuture(getProfilePicture()),
                builder: (context, profilePicture) {
                  if (profilePicture.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: kPrimaryColor));
                  } else if (profilePicture.hasError &&
                      profilePicture == null) {
                    return Text(
                        'Error Getting Profile Picutre ${profilePicture.error}');
                  } else {
                    final picture = profilePicture.data!;
                    return SizedBox(
                      height: 90,
                      child: Center(
                        child: picture == null
                            ? const Text('No Profile\nPicture')
                            : CircleAvatar(
                                maxRadius: 200,
                                backgroundImage: NetworkImage(picture)),
                      ),
                    );
                  }
                },
              ),
              const Spacer(),
              Text(
                salonName,
                textAlign: TextAlign.center,
                style: const TextStyle(color: kPrimaryColor),
              ),
            ],
          );
        }
      },
    );
  }

  Widget SalonPlace() {
    return StreamBuilder<String>(
      stream: Stream.fromFuture(getUserAddress()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          );
        } else if (snapshot.hasError) {
          return Text('Getting Name Error ${snapshot.error}');
        } else {
          final address = snapshot.data!;
          return Column(
            children: [
              const SizedBox(
                height: 10,
                child: Icon(
                  Icons.location_city_rounded,
                  color: kPrimaryColor,
                  size: 50,
                ),
              ),
              const Spacer(),
              Text(
                address,
                textAlign: TextAlign.center,
                style: const TextStyle(color: kPrimaryColor),
              ),
            ],
          );
        }
      },
    );
  }
}
