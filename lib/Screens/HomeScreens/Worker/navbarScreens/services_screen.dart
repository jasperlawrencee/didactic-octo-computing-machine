// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:developer';

import 'package:badges/badges.dart' as badges;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/addservices_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  int serviceCount = 0;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  var pageController = PageController();

  @override
  void initState() {
    super.initState();
    getServiceTypeCount();
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

  Future<dynamic> editServiceDialog(
    BuildContext context,
    String serviceType,
    String serviceName,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editing $serviceName'),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                flatTextField('Price', _priceController),
                const SizedBox(height: defaultPadding),
                flatTextField('Duration', _durationController),
                const SizedBox(height: defaultPadding),
                flatTextField('Description', _descriptionController),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _priceController.clear();
                  _durationController.clear();
                  _descriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Text('CLOSE')),
            TextButton(
                onPressed: () {
                  editServiceDetails(
                    serviceType,
                    serviceName,
                    _priceController.text,
                    _durationController.text,
                    _descriptionController.text,
                  ).then((value) {
                    Navigator.pop(context);
                    setState(() {
                      value;
                    });
                  });
                },
                child: const Text('EDIT')),
          ],
        );
      },
    );
  }

  Future<void> editServiceDetails(
    String serviceType,
    String serviceName,
    String price,
    String duration,
    String description,
  ) async {
    try {
      DocumentReference docRef = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .doc(serviceType)
          .collection('${currentUser!.uid}services')
          .doc(serviceName);
      if (price.isNotEmpty || duration.isNotEmpty || description.isNotEmpty) {
        price.isNotEmpty
            ? await docRef.update({'price': price})
            : log('empty price');
        duration.isNotEmpty
            ? await docRef.update({'duration': duration})
            : log('empty duration');
        description.isNotEmpty
            ? await docRef.update({'description': description})
            : log('empty description');
        log('updated service');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Empty Fields'),
          action: SnackBarAction(label: 'Close', onPressed: () {}),
        ));
      }
    } catch (e) {
      log('Error in editing service details - ${e.toString()}');
    }
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
    try {
      DocumentReference docRef = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .doc(serviceType)
          .collection('${currentUser!.uid}services')
          .doc(serviceName);
      await docRef.delete();
    } catch (e) {
      log('Error deleting document $serviceName: $e');
    }
  }

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    child: Stack(
                  fit: StackFit.loose,
                  children: [
                    servicesPageView(),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                                backgroundColor: kPrimaryColor,
                                child: const Icon(
                                  Icons.add,
                                  color: kPrimaryLightColor,
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const AddServices();
                                    },
                                  ));
                                }),
                            const SizedBox(height: defaultPadding)
                          ],
                        )),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Text(
                                                  'Delete ${serviceNames.data![serviceIndex][index]}?',
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        deleteService(
                                                          //serviceType
                                                          snapshot.data![
                                                              serviceIndex],
                                                          //serviceName
                                                          serviceNames.data![
                                                                  serviceIndex]
                                                              [index],
                                                        ).then((value) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {
                                                            value;
                                                          });
                                                        });
                                                      },
                                                      child:
                                                          const Text('Delete')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Close')),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        position: badges.BadgePosition.topEnd(),
                                        showBadge: true,
                                        badgeContent: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        child: InkWell(
                                          child: Container(
                                            height: 100,
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            padding: const EdgeInsets.all(
                                                defaultPadding),
                                            decoration: const BoxDecoration(
                                                color: kPrimaryLightColor),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        //service name
                                                        Text(
                                                          serviceNames.data![
                                                                  serviceIndex]
                                                              [index],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        //duration
                                                        Text(
                                                          serviceDetails.data![
                                                                      serviceIndex]
                                                                      [index][
                                                                      'duration']
                                                                  .toString()
                                                                  .isNotEmpty
                                                              ? ' - ${serviceDetails.data![serviceIndex][index]['duration']}'
                                                              : ' - Duration',
                                                        )
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    //descripiton
                                                    Text(serviceDetails
                                                            .data![serviceIndex]
                                                                [index]
                                                                ['description']
                                                            .toString()
                                                            .isNotEmpty
                                                        ? serviceDetails.data![
                                                                    serviceIndex]
                                                                [index]
                                                            ['description']
                                                        : 'Description')
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    //price
                                                    Text(serviceDetails
                                                            .data![serviceIndex]
                                                                [index]['price']
                                                            .toString()
                                                            .isNotEmpty
                                                        ? serviceDetails.data![
                                                                serviceIndex]
                                                            [index]['price']
                                                        : 'Price'),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            editServiceDialog(
                                              context,
                                              //serviceType
                                              snapshot.data![serviceIndex],
                                              //serviceName
                                              serviceNames.data![serviceIndex]
                                                  [index],
                                            );
                                          },
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
}
