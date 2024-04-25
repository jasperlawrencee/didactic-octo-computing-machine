// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:developer';

import 'package:badges/badges.dart' as badges;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/addservices_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/editservices_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:intl/intl.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  var pageController = PageController();

  @override
  void initState() {
    super.initState();
    getServiceTypeCount();
  }

  String formatDouble(double value) {
    final format = NumberFormat('#,##0.00');
    return format.format(value);
  }

  Future getServiceTypeCount() async {
    try {
      int serviceCount = 0;
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .get();
      querySnapshot.docs.forEach((element) {
        serviceCount++;
      });
      return serviceCount;
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
            margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
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
                    ServicesPageView(),
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

  // ignore: non_constant_identifier_names
  Widget ServicesPageView() {
    return StreamBuilder(
      stream: Stream.fromFuture(getServiceTypeCount()),
      builder: (context, servicecount) {
        if (servicecount.hasData) {
          return PageView.builder(
            itemCount: int.parse(servicecount.data!.toString()),
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
                          builder: (context, serviceType) {
                            if (serviceType.hasData) {
                              return FutureBuilder<
                                  List<List<Map<String, dynamic>>>>(
                                future: getServiceDetails(),
                                builder: (context, serviceDetails) {
                                  if (serviceDetails.hasData) {
                                    return RefreshIndicator(
                                      onRefresh: () async {
                                        setState(() {});
                                      },
                                      child: Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: serviceType
                                                .data![serviceIndex].length,
                                            itemBuilder: (context, service) {
                                              return badges.Badge(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: Text(
                                                          'Delete ${serviceType.data![serviceIndex][service]}?',
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                deleteService(
                                                                  //serviceType
                                                                  snapshot.data![
                                                                      serviceIndex],
                                                                  //serviceName
                                                                  serviceType.data![
                                                                          serviceIndex]
                                                                      [service],
                                                                ).then((value) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  setState(() {
                                                                    value;
                                                                  });
                                                                });
                                                              },
                                                              child: const Text(
                                                                  'Delete')),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Close')),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                position: badges.BadgePosition
                                                    .topEnd(),
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
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            defaultPadding),
                                                    decoration: const BoxDecoration(
                                                        color:
                                                            kPrimaryLightColor),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                //service name
                                                                Text(
                                                                  serviceType.data![
                                                                          serviceIndex]
                                                                      [service],
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                //duration
                                                                Text(
                                                                  serviceDetails
                                                                          .data![
                                                                              serviceIndex]
                                                                              [
                                                                              service]
                                                                              [
                                                                              'duration']
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? ' - ${serviceDetails.data![serviceIndex][service]['duration']}'
                                                                      : ' - Duration',
                                                                )
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            //descripiton
                                                            Text(
                                                              serviceDetails
                                                                      .data![
                                                                          serviceIndex]
                                                                          [
                                                                          service]
                                                                          [
                                                                          'description']
                                                                      .toString()
                                                                      .isNotEmpty
                                                                  ? serviceDetails
                                                                              .data![serviceIndex]
                                                                          [
                                                                          service]
                                                                      [
                                                                      'description']
                                                                  : 'Description',
                                                              softWrap: true,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            )
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            //price
                                                            Text(serviceDetails
                                                                    .data![
                                                                        serviceIndex]
                                                                        [
                                                                        service]
                                                                        [
                                                                        'price']
                                                                    .toString()
                                                                    .isNotEmpty
                                                                ? "PHP ${formatDouble(double.parse(serviceDetails.data![serviceIndex][service]['price']))}"
                                                                : 'Price'),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                      builder: (context) {
                                                        return EditServices(
                                                            serviceType: snapshot
                                                                    .data![
                                                                serviceIndex],
                                                            serviceName: serviceType
                                                                        .data![
                                                                    serviceIndex]
                                                                [service]);
                                                      },
                                                    ));
                                                  },
                                                ),
                                              );
                                            }),
                                      ),
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
                            } else if (serviceType.hasError) {
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
        } else {
          return Container();
        }
      },
    );
  }
}
