// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/parse.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SalonAppointmentScreen extends StatefulWidget {
  Appointment? appointment;
  List<Appointment>? existingAppointments;
  String? role;
  final TextEditingController denyReasonController = TextEditingController();

  SalonAppointmentScreen({
    super.key,
    this.appointment,
    this.existingAppointments,
    this.role,
  });

  @override
  State<SalonAppointmentScreen> createState() => _SalonAppointmentScreenState();
}

List<String> reasons = [
  "Service is currently unavailable",
  "Equipment or facility issues",
  "Provider emergency",
  "Appointment conflict",
  "Others",
];

class _SalonAppointmentScreenState extends State<SalonAppointmentScreen> {
  String currentReason = reasons.first;
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  final dateFormatter = DateFormat('MMMM d h:mma');
  String? nullValue;
  Parse convert = Parse();
  TextEditingController reasonController = TextEditingController();

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

  Future<String> preferredWorker() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('bookings')
          .doc('${widget.appointment!.id}')
          .get();
      return documentSnapshot['worker'];
    } catch (e) {
      log('error getting preferred worker $e');
      return '';
    }
  }

  Future<void> finalComplete() async {
    //make notification function here
    String customerID = '';
    try {
      String bookingDocument = widget.appointment!.id.toString();
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('Username', isEqualTo: widget.appointment!.subject)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          customerID = querySnapshot.docs[0].id;
        });
      }
      //set confirm to customer
      await _firestore
          .collection('users')
          .doc(customerID)
          .collection('bookings')
          .doc(bookingDocument)
          .update({'status': 'finished'});
      //set confirm to client
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('bookings')
          .doc(bookingDocument)
          .update({'status': 'finished'}).then(
        (value) {
          if (mounted) {
            Navigator.pop(context);
            setState(() {});
          }
        },
      );
    } catch (e) {
      log('error deny appointment $e');
    }
  }

  Future<void> finalDeny(String reason) async {
    //make notification function here
    String customerID = '';
    try {
      String bookingDocument = widget.appointment!.id.toString();
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('Username', isEqualTo: widget.appointment!.subject)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          customerID = querySnapshot.docs[0].id;
        });
      }
      //set confirm to customer
      await _firestore
          .collection('users')
          .doc(customerID)
          .collection('bookings')
          .doc(bookingDocument)
          .update({
        'status': 'denied',
        'reason': reason,
      });
      //set confirm to client
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('bookings')
          .doc(bookingDocument)
          .update({
        'status': 'denied',
        'reason': reason,
      }).then(
        (value) {
          log('finished');
          if (mounted) {
            Navigator.pop(context);
            setState(() {});
          }
        },
      );
    } catch (e) {
      log('error deny appointment $e');
    }
  }

  Future<void> completeAppointment() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm Completion?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text('BACK')),
            TextButton(
                onPressed: () {
                  finalComplete();
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text('CONFIRM')),
          ],
        );
      },
    );
  }

  Future<void> denyAppointment() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm Deny?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('BACK')),
            TextButton(
                onPressed: () {
                  // finalDeny();
                  Navigator.of(context).pop();
                  denyReasonDialog();
                },
                child: const Text('DENY')),
          ],
        );
      },
    );
  }

  Future<void> denyReasonDialog() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Reason for denial',
            style: TextStyle(fontSize: 16),
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              children: [
                RadioListTile(
                  title: Text(reasons[0]),
                  value: reasons[0],
                  groupValue: currentReason,
                  onChanged: (value) {
                    setState(() {
                      currentReason = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text(reasons[1]),
                  value: reasons[1],
                  groupValue: currentReason,
                  onChanged: (value) {
                    setState(() {
                      currentReason = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text(reasons[2]),
                  value: reasons[2],
                  groupValue: currentReason,
                  onChanged: (value) {
                    setState(() {
                      currentReason = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text(reasons[3]),
                  value: reasons[3],
                  groupValue: currentReason,
                  onChanged: (value) {
                    setState(() {
                      currentReason = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text(reasons[4]),
                  value: reasons[4],
                  groupValue: currentReason,
                  onChanged: (value) {
                    setState(() {
                      currentReason = value.toString();
                    });
                  },
                ),
                if (currentReason == "Others")
                  flatTextField('Reason', reasonController)
              ],
            );
          }),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('BACK')),
            TextButton(
                onPressed: () {
                  if (currentReason == "Others") {
                    currentReason = reasonController.text;
                  }
                  finalDeny(currentReason);
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text('DENY')),
          ],
        );
      },
    );
  }

  Future<void> finalAppointment() async {
    //notification function here
    String customerID = '';
    try {
      String bookingDocument = widget.appointment!.id.toString();
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('Username', isEqualTo: widget.appointment!.subject)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          customerID = querySnapshot.docs[0].id;
        });
      }
      //set confirm to customer
      await _firestore
          .collection('users')
          .doc(customerID)
          .collection('bookings')
          .doc(bookingDocument)
          .update({'status': 'confirmed'});
      //set confirm to client
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('bookings')
          .doc(bookingDocument)
          .update({'status': 'confirmed'}).then(
        (value) {
          log('finished');
          if (mounted) {
            Navigator.pop(context);
            setState(() {});
          }
        },
      );
    } catch (e) {
      log('error confirming appointment $e');
    }
  }

  conflictDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: widget.role == 'salon'
              ? const Text(
                  'Selected appointment has conflict! Force approve?',
                  style: TextStyle(fontSize: 16),
                )
              : widget.role == 'freelancer'
                  ? const Text(
                      'Selected appointment has conflict!',
                      style: TextStyle(fontSize: 16),
                    )
                  : null,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('BACK')),
            widget.role == 'salon'
                ? TextButton(
                    onPressed: () {
                      finalAppointment();
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: const Text('BOOK'))
                : Container(),
          ],
        );
      },
    );
  }

  Future<void> confirmAppointment() async {
    log(widget.role!);
    if (hasConflict(widget.appointment!, widget.existingAppointments!)) {
      log('has conflict');
      conflictDialog();
    } else {
      log('has no conflict');
      finalAppointment();
    }
  }

  bool hasConflict(
      Appointment newAppointment, List<Appointment> existingAppointments) {
    //checks conflict for each existing appointment
    for (Appointment existingAppointment in existingAppointments) {
      if (existingAppointment.color == kPrimaryColor) {
        if (newAppointment.startTime.isBefore(existingAppointment.endTime) &&
            newAppointment.endTime.isAfter(existingAppointment.startTime)) {
          //has conflict
          return true;
        }
      }
    }
    //has no conflict
    return false;
  }

  Future<AppointmentDoc?> getSpecificAppointment(String reference) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('bookings')
          .doc(reference)
          .get();
      if (doc['status'] == 'denied') {
        return AppointmentDoc(
            // customerName: doc['customerName'],
            reason: doc['reason'],
            clientId: doc['clientId'],
            clientUsername: doc['clientUsername'],
            customerUsername: doc['customerUsername'],
            dateFrom: doc['dateFrom'].toDate(),
            dateTo: doc['dateTo'].toDate(),
            location: doc['location'],
            paymentMethod: doc['paymentMethod'],
            reference: doc['reference'],
            serviceFee: doc['serviceFee'],
            services: doc['services'],
            status: doc['status'],
            totalAmount: doc['totalAmount']);
      } else {
        return AppointmentDoc(
            // customerName: doc['customerName'],
            clientId: doc['clientId'],
            clientUsername: doc['clientUsername'],
            customerUsername: doc['customerUsername'],
            dateFrom: doc['dateFrom'].toDate(),
            dateTo: doc['dateTo'].toDate(),
            location: doc['location'],
            paymentMethod: doc['paymentMethod'],
            reference: doc['reference'],
            serviceFee: doc['serviceFee'],
            services: doc['services'],
            status: doc['status'],
            totalAmount: doc['totalAmount']);
      }
    } catch (e) {
      log('error getting appointment document $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool walapa =
        widget.appointment?.color == const Color.fromARGB(255, 158, 158, 158);
    bool paid =
        widget.appointment?.color == const Color.fromARGB(255, 30, 90, 255);
    bool confirmed = widget.appointment?.color == kPrimaryColor;
    bool denied =
        widget.appointment?.color == const Color.fromARGB(255, 255, 59, 59);
    List<Map<String, dynamic>> servicesList =
        convert.stringToMap(widget.appointment!.notes.toString());
    double total = double.parse(getTotal(extractPrice(servicesList))) +
        double.parse(getServicesFee(extractPrice(
            convert.stringToMap(widget.appointment!.notes.toString()))));
    return Scaffold(
      body: Background(
          child: Container(
        margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
        child: StreamBuilder<AppointmentDoc?>(
            stream: Stream.fromFuture(
                getSpecificAppointment(widget.appointment!.id.toString())),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                            'Ref. ${widget.appointment!.id}',
                            style: const TextStyle(
                                color: Colors.black54,
                                fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: defaultPadding),
                          //////////////////OPTIONAL ASSIGN WORKER///////////////////////////
                          StreamBuilder<String>(
                            stream: Stream.fromFuture(preferredWorker()),
                            builder: (context, workers) {
                              if (workers.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  ),
                                );
                              } else if (workers.hasError) {
                                return Center(
                                  child: Text(
                                      "Error getting worker list ${workers.error}"),
                                );
                              } else {
                                return Column(
                                  children: [
                                    bookingCard(
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Customer Name'),
                                          const SizedBox(height: 1),
                                          Text(
                                            widget.appointment!.subject,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                              height: defaultPadding),
                                          const Text('Salon Place'),
                                          const SizedBox(height: 1),
                                          Text(
                                            widget.appointment!.location
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                              height: defaultPadding),
                                          const Text('Time & Date'),
                                          const SizedBox(height: 1),
                                          Text(
                                            '${DateFormat.jm().format(widget.appointment!.startTime)} - ${DateFormat.jm().format(widget.appointment!.endTime)} | ${DateFormat('MMMMd').format(widget.appointment!.endTime)}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                              height: defaultPadding),
                                          const Text('Service Appointment'),
                                          const SizedBox(height: 1),
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              return SizedBox(
                                                width: constraints.maxWidth,
                                                height: 30,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: convert
                                                      .stringToMap(widget
                                                          .appointment!.notes
                                                          .toString())
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    String services = convert
                                                            .stringToMap(widget
                                                                .appointment!.notes
                                                                .toString())[
                                                        index]["serviceName"];
                                                    return serviceCard(
                                                        services);
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    bookingCard(Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Payment Method'),
                                            Text(snapshot.data!.paymentMethod)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Total',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              total.toStringAsFixed(2),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 1),
                                        const Divider(
                                          color: kPrimaryLightColor,
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: servicesList.length + 1,
                                          itemBuilder: (context, index) {
                                            if (index == servicesList.length) {
                                              List<double> prices =
                                                  extractPrice(
                                                      convert.stringToMap(widget
                                                          .appointment!.notes
                                                          .toString()));
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Service Fee",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    "PHP ${getServicesFee(prices)}",
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              String services =
                                                  convert.stringToMap(widget
                                                          .appointment!.notes
                                                          .toString())[index]
                                                      ["serviceName"];
                                              String price =
                                                  convert.stringToMap(widget
                                                          .appointment!.notes
                                                          .toString())[index]
                                                      ["price"];
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    services,
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    'PHP ${convert.intStringToDouble(price)}',
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    )),
                                    const SizedBox(height: defaultPadding),
                                    widget.role == 'salon'
                                        ? bookingCard(Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Preferred Stylist'),
                                              Text(
                                                workers.data!.isEmpty
                                                    ? 'Any'
                                                    : workers.data!,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ))
                                        //shows nothing since client is not a salon
                                        : Container(),
                                    if (denied)
                                      bookingCard(Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Deny Reason'),
                                          Text(snapshot.data!.reason!),
                                        ],
                                      ))
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      if (walapa &&
                          DateTime.now().isBefore(widget.appointment!.startTime
                              .add(const Duration(minutes: 15))))
                        Container(
                          margin: const EdgeInsets.only(bottom: defaultPadding),
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: denyAppointment,
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        kPrimaryLightColor)),
                                child: const Text('DENY'),
                              ),
                              const SizedBox(height: defaultPadding),
                              ElevatedButton(
                                  onPressed: confirmAppointment,
                                  child: const Text('BOOK',
                                      style: TextStyle(
                                          color: kPrimaryLightColor))),
                            ],
                          ),
                        ),
                      if (paid)
                        Column(
                          children: [
                            ElevatedButton(
                                onPressed: completeAppointment,
                                child: const Text(
                                  'COMPLETE',
                                  style: TextStyle(color: kPrimaryLightColor),
                                )),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
      )),
    );
  }

  String getServicesFee(List<double> listInt) {
    if (listInt.isEmpty) {
      return '00.00';
    }

    double sum = listInt.reduce((value, element) => value + element);
    return (sum * 0.05).toStringAsFixed(2);
  }

  String getTotal(List<double> list) {
    if (list.isEmpty) {
      return '00.00';
    }

    double sum = list.reduce((value, element) => value + element);
    // int total = sum + extractPrice(list);
    return sum.toStringAsFixed(2);
  }

  List<double> extractPrice(List<Map<String, dynamic>> list) {
    List<double> prices = [];

    for (var item in list) {
      if (item.containsKey("price")) {
        prices.add(double.parse(item["price"]));
      }
    }

    return prices;
  }
}

class AppointmentDoc {
  String clientId;
  String clientUsername;
  String customerUsername;
  // String customerName;
  DateTime dateFrom;
  DateTime dateTo;
  String location;
  String paymentMethod;
  String? reason;
  String reference;
  String serviceFee;
  List<dynamic> services;
  String status;
  String totalAmount;

  AppointmentDoc({
    required this.clientId,
    required this.clientUsername,
    required this.customerUsername,
    // required this.customerName,
    required this.dateFrom,
    required this.dateTo,
    required this.location,
    required this.paymentMethod,
    this.reason,
    required this.reference,
    required this.serviceFee,
    required this.services,
    required this.status,
    required this.totalAmount,
  });
}
