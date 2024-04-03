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

  Future<void> confirmAppointment() async {
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
          .update({
        'status': 'confirmed',
      }).then(
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

  @override
  Widget build(BuildContext context) {
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
                                  Text('data')
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
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
            if (widget.appointment?.color != Color(0xff6f35a5))
              Container(
                margin: const EdgeInsets.only(bottom: defaultPadding),
                child: ElevatedButton(
                    onPressed: confirmAppointment,
                    child: const Text('BOOK',
                        style: TextStyle(color: kPrimaryLightColor))),
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
