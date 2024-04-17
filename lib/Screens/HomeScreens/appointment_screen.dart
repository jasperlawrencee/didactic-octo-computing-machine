// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/parse.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SalonAppointmentScreen extends StatefulWidget {
  Appointment? appointment;
  List<Appointment>? existingAppointments;
  String? role;

  SalonAppointmentScreen({
    super.key,
    this.appointment,
    this.existingAppointments,
    this.role,
  });

  @override
  State<SalonAppointmentScreen> createState() => _SalonAppointmentScreenState();
}

class _SalonAppointmentScreenState extends State<SalonAppointmentScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  final dateFormatter = DateFormat('MMMM d h:mma');
  String? nullValue;
  Parse convert = Parse();

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
      log('error getting preferred worker');
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
          }
          setState(() {});
        },
      );
    } catch (e) {
      log('error deny appointment $e');
    }
  }

  Future<void> finalDeny() async {
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
          .update({'status': 'denied'});
      //set confirm to client
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('bookings')
          .doc(bookingDocument)
          .update({'status': 'denied'}).then(
        (value) {
          log('finished');
          if (mounted) {
            Navigator.pop(context);
          }
          setState(() {});
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
                },
                child: const Text('BACK')),
            TextButton(
                onPressed: () {
                  finalComplete();
                  Navigator.of(context).pop();
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
                  finalDeny();
                  Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    bool walapa =
        widget.appointment?.color == const Color.fromARGB(255, 158, 158, 158);
    bool paid =
        widget.appointment?.color == const Color.fromARGB(255, 30, 90, 255);
    List<Map<String, dynamic>> servicesList =
        convert.stringToMap(widget.appointment!.notes.toString());
    double total = double.parse(getTotal(extractPrice(servicesList))) +
        double.parse(getServicesFee(extractPrice(
            convert.stringToMap(widget.appointment!.notes.toString()))));
    return Scaffold(
      body: Background(
          child: Container(
        margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
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
                      color: Colors.black54, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: defaultPadding),
                //////////////////OPTIONAL ASSIGN WORKER///////////////////////////
                StreamBuilder<String>(
                  stream: Stream.fromFuture(preferredWorker()),
                  builder: (context, workers) {
                    if (workers.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      );
                    } else if (workers.hasError) {
                      return Center(
                        child:
                            Text("Error getting worker list ${workers.error}"),
                      );
                    } else {
                      return Column(
                        children: [
                          bookingCard(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Customer Name'),
                                const SizedBox(height: 1),
                                Text(
                                  widget.appointment!.subject,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: defaultPadding),
                                const Text('Salon Place'),
                                const SizedBox(height: 1),
                                Text(
                                  widget.appointment!.location.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: defaultPadding),
                                const Text('Time & Date'),
                                const SizedBox(height: 1),
                                Text(
                                  '${DateFormat.jm().format(widget.appointment!.startTime)} - ${DateFormat.jm().format(widget.appointment!.endTime)} | ${DateFormat('MMMMd').format(widget.appointment!.endTime)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: defaultPadding),
                                const Text('Service Appointment'),
                                const SizedBox(height: 1),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SizedBox(
                                      width: constraints.maxWidth,
                                      height: 30,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: convert
                                            .stringToMap(widget
                                                .appointment!.notes
                                                .toString())
                                            .length,
                                        itemBuilder: (context, index) {
                                          String services = convert.stringToMap(
                                                  widget.appointment!.notes
                                                      .toString())[index]
                                              ["serviceName"];
                                          return serviceCard(services);
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Payment Method'),
                                  Text('CASH')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    List<double> prices = extractPrice(convert
                                        .stringToMap(widget.appointment!.notes
                                            .toString()));
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Service Fee",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          "PHP ${getServicesFee(prices)}",
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    );
                                  } else {
                                    String services = convert.stringToMap(widget
                                        .appointment!.notes
                                        .toString())[index]["serviceName"];
                                    String price = convert.stringToMap(widget
                                        .appointment!.notes
                                        .toString())[index]["price"];
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                          ? 'None'
                                          : workers.data!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))
                              //shows nothing since client is not a salon
                              : Container(),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
            if (walapa)
              Container(
                margin: const EdgeInsets.only(bottom: defaultPadding),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: denyAppointment,
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(kPrimaryLightColor)),
                      child: const Text('DENY'),
                    ),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                        onPressed: confirmAppointment,
                        child: const Text('BOOK',
                            style: TextStyle(color: kPrimaryLightColor))),
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
