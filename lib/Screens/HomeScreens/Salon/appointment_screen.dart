import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SalonAppointmentScreen extends StatefulWidget {
  Appointment? appointment;

  SalonAppointmentScreen({
    super.key,
    this.appointment,
  });

  @override
  State<SalonAppointmentScreen> createState() => _SalonAppointmentScreenState();
}

class _SalonAppointmentScreenState extends State<SalonAppointmentScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  final dateFormatter = DateFormat('MMMM d h:mma');
  String? nullValue = null;

  Future<String> getUsername() async {
    try {
      final collectionRef =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      if (collectionRef.exists) {
        final username = collectionRef.get('name');
        return username;
      } else {
        return '';
      }
    } catch (e) {
      log('error getting username $e');
      return '';
    }
  }

  Future<List<String>> getWorkerEmployed() async {
    //kuhaon tanan worker na employed under user collection
    //return ang username under that collection
    List<String> userIds = [];
    try {
      final querysnapshot = await _firestore
          .collectionGroup('experiences')
          .where('salon', isEqualTo: await getUsername())
          .get();
      for (QueryDocumentSnapshot doc in querysnapshot.docs) {
        String userId = doc.reference.parent.parent!.id;
        userIds.add(userId);
      }
      return userIds;
    } catch (e) {
      log('error getting employees $e');
      return [];
    }
  }

  Future<List<String>> workersList() async {
    List<String> workersList = [];
    List<String> kuan = await getWorkerEmployed();
    try {
      for (String worker in kuan) {
        final documentSnapshot =
            await _firestore.collection('users').doc(worker).get();
        if (documentSnapshot.exists) {
          final name = documentSnapshot.data()?['name'];
          workersList.add(name);
        } else {
          return [];
        }
      }
      return workersList;
    } catch (e) {
      log('error making list $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: Container(
        margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "booking details".toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
              Text(
                'Ref. 123456789abc',
                style: const TextStyle(
                    color: Colors.black54, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: defaultPadding),
              //////////////////OPTIONAL ASSIGN WORKER///////////////////////////
              StreamBuilder<List<String>>(
                stream: Stream.fromFuture(workersList()),
                builder: (context, workers) {
                  if (workers.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  } else if (workers.hasError) {
                    return Center(
                      child: Text("Error getting worker list ${workers.error}"),
                    );
                  } else {
                    String defaultValue = workers.data!.first;
                    return Column(
                      children: [
                        bookingCard(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Assign Worker (Optional)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            DropdownButton(
                                value: nullValue ?? defaultValue,
                                items: (workers.data!).map((String value) {
                                  return DropdownMenuItem(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: (String? newvalue) {
                                  setState(() {
                                    nullValue = newvalue!;
                                  });
                                })
                          ],
                        )),
                        const SizedBox(height: defaultPadding),
                        bookingCard(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Customer Name'),
                              const SizedBox(height: 1),
                              Text(
                                'widget.customerName',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: defaultPadding),
                              const Text('Salon Place'),
                              const SizedBox(height: 1),
                              Text(
                                'widget.salonAddress',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: defaultPadding),
                              const Text('Time & Date'),
                              const SizedBox(height: 1),
                              Row(
                                children: [
                                  Text(
                                    dateFormatter
                                        .format(widget.appointment!.startTime),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ' - ${DateFormat.jm().format(widget.appointment!.endTime)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const SizedBox(height: defaultPadding),
                              const Text('Service Appointment'),
                              const SizedBox(height: 1),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return SizedBox(
                                    width: constraints.maxWidth,
                                    height: 25,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return serviceCard('data');
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: defaultPadding),
              //////////////////TRANSACTION DETAILS///////////////////////////
              bookingCard(const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Payment Method'), Text('GCash')],
                  ),
                  SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Php 810.00',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height: 1),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Haircut',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Php 350.00',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hair Color',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Php 350.00',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Manicure',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Php 500.00',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Service Fee',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Php 10.00',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(height: 1),
                ],
              )),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('BACK')),
                  TextButton(onPressed: () {}, child: const Text('CONFIRM')),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  Container serviceCard(String service) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      decoration: const BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(
        service,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget bookingCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            offset: Offset(8, 8),
          )
        ],
      ),
      child: child,
    );
  }
}
