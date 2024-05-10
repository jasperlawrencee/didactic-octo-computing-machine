import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AdminScreens/Dashboard.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/salon_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<String> duration = ["All", "Monthly", "Weekly"];
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  int monthIndex = 1;
  String monthDropdown = "January";
  String dropdownValue = "All";
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now().add(const Duration(days: 6));
  DateFormat dateFormat = DateFormat("MM-dd-yyyy");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Background(
            child: Container(
      margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Analytics".toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kPrimaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      style: const TextStyle(color: kPrimaryColor),
                      underline: Container(height: 2, color: kPrimaryColor),
                      onChanged: (value) {
                        setState(() => dropdownValue = value!);
                      },
                      items: duration
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                    ),
                    dropdownValue == 'Monthly'
                        ? Row(children: [
                            DropdownButton<String>(
                              value: monthDropdown,
                              icon: const Icon(Icons.arrow_drop_down),
                              style: const TextStyle(color: kPrimaryColor),
                              underline:
                                  Container(height: 2, color: kPrimaryColor),
                              onChanged: (value) {
                                setState(() {
                                  monthDropdown = value!;
                                  monthIndex = months.indexOf(value) + 1;
                                });
                              },
                              items: months
                                  .map<DropdownMenuItem<String>>((e) =>
                                      DropdownMenuItem(
                                          value: e, child: Text(e)))
                                  .toList(),
                            ),
                            const SizedBox(width: defaultPadding),
                            const Text('of 2024',
                                style: TextStyle(color: kPrimaryColor)),
                          ])
                        : dropdownValue == "Weekly"
                            ? Row(
                                children: [
                                  TextButton(
                                      onPressed: selectWeek,
                                      child: Text(
                                        dateFormat.format(startDateTime),
                                        style: const TextStyle(
                                            decorationColor: kPrimaryColor,
                                            decoration:
                                                TextDecoration.underline),
                                      )),
                                  const SizedBox(width: defaultPadding / 2),
                                  const Text('-'),
                                  const SizedBox(width: defaultPadding),
                                  Text(
                                    dateFormat.format(endDateTime),
                                    style:
                                        const TextStyle(color: kPrimaryColor),
                                  )
                                ],
                              )
                            : Container(),
                  ],
                ),
                FutureBuilder<List<Booking>>(
                  future: getBookingHistory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Booking> allBookings =
                          filterBookingsByAll(snapshot.data!);
                      List<Booking> monthlyFiltered =
                          filterBookingsByMonth(snapshot.data!, monthIndex);
                      List<Booking> weeklyFiltered =
                          filterBookingsByWeek(snapshot.data!, startDateTime);
                      Map<String, dynamic> monthlyStats =
                          statistics(filteredBooking: monthlyFiltered);
                      Map<String, dynamic> weeklyStats =
                          statistics(filteredBooking: weeklyFiltered);
                      return dropdownValue == "Monthly"
                          ? Column(
                              // monthly column
                              children: [
                                bookingCard(
                                  Column(
                                    children: [
                                      rowdetails(children: [
                                        const Text('Pending Appointments'),
                                        Text(
                                            "${monthlyStats['pendingAppointments']}")
                                      ]),
                                      rowdetails(children: [
                                        const Text('Denied Appointments'),
                                        Text(
                                            "${monthlyStats['deniedAppointments']}")
                                      ]),
                                      rowdetails(children: [
                                        const Text('Paid Appointments'),
                                        Text(
                                            "${monthlyStats['paidAppointments']}")
                                      ]),
                                      rowdetails(children: [
                                        const Text('Finished Appointments'),
                                        Text(
                                            "${monthlyStats['finishedAppointments']}")
                                      ]),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: defaultPadding),
                                const Row(children: [
                                  SizedBox(width: defaultPadding),
                                  Text('Data is from Finished Appointments')
                                ]),
                                bookingCard(Column(
                                  children: [
                                    rowdetails(children: [
                                      const Text('Total Sales'),
                                      Text(
                                          "PHP ${monthlyStats['totalSales'].toStringAsFixed(2)}")
                                    ]),
                                    rowdetails(children: [
                                      const Text('Top Service'),
                                      Text(
                                          "${monthlyStats['mostOcurringService']}")
                                    ]),
                                    rowdetails(children: [
                                      const Text('Top Client'),
                                      Text(
                                          '${monthlyStats['topRecurringCustomer']}')
                                    ]),
                                  ],
                                )),
                              ],
                            )
                          : dropdownValue == 'All'
                              ? Column(
                                  // all column
                                  children: [
                                    bookingCard(
                                      Column(
                                        children: [
                                          rowdetails(children: [
                                            const Text('Pending Appointments'),
                                            Text(
                                                "${countStatusOfAppointment(bookings: snapshot.data!, status: 'pending')}")
                                          ]),
                                          rowdetails(children: [
                                            const Text('Denied Appointments'),
                                            Text(
                                                "${countStatusOfAppointment(bookings: snapshot.data!, status: 'denied')}")
                                          ]),
                                          rowdetails(children: [
                                            const Text('Paid Appointments'),
                                            Text(
                                                "${countStatusOfAppointment(bookings: snapshot.data!, status: 'paid')}")
                                          ]),
                                          rowdetails(children: [
                                            const Text('Finished Appointments'),
                                            Text(
                                                "${countStatusOfAppointment(bookings: snapshot.data!, status: 'finished')}")
                                          ]),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const Row(children: [
                                      SizedBox(width: defaultPadding),
                                      Text('Data is from Finished Appointments')
                                    ]),
                                    bookingCard(Column(
                                      children: [
                                        rowdetails(children: [
                                          const Text('Total Sales'),
                                          Text(
                                              "PHP ${calculateTotalSales(allBookings).toStringAsFixed(2)}"),
                                        ]),
                                        rowdetails(children: [
                                          const Text('Top Service'),
                                          Text(mostRecurringService(
                                              allBookings)),
                                        ]),
                                        rowdetails(children: [
                                          const Text('Top Client'),
                                          Text(mostRecurringCustomer(
                                              allBookings))
                                        ])
                                      ],
                                    ))
                                  ],
                                )
                              : Column(
                                  // weekly column
                                  children: [
                                    bookingCard(
                                      Column(
                                        children: [
                                          rowdetails(children: [
                                            const Text('Pending Appointments'),
                                            Text(
                                                "${weeklyStats['pendingAppointments']}")
                                          ]),
                                          rowdetails(children: [
                                            const Text('Denied Appointments'),
                                            Text(
                                                "${weeklyStats['deniedAppointments']}")
                                          ]),
                                          rowdetails(children: [
                                            const Text('Paid Appointments'),
                                            Text(
                                                "${weeklyStats['paidAppointments']}")
                                          ]),
                                          rowdetails(children: [
                                            const Text('Finished Appointments'),
                                            Text(
                                                "${weeklyStats['finishedAppointments']}")
                                          ]),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const Row(children: [
                                      SizedBox(width: defaultPadding),
                                      Text('Data is from Finished Appointments')
                                    ]),
                                    bookingCard(Column(
                                      children: [
                                        rowdetails(children: [
                                          const Text('Total Sales'),
                                          Text(
                                              "PHP ${weeklyStats['totalSales'].toStringAsFixed(2)}")
                                        ]),
                                        rowdetails(children: [
                                          const Text('Top Service'),
                                          Text(
                                              "${weeklyStats['mostOcurringService']}"),
                                        ]),
                                        rowdetails(children: [
                                          const Text('Top Client'),
                                          Text(
                                              "${weeklyStats['topRecurringCustomer']}")
                                        ])
                                      ],
                                    ))
                                  ],
                                );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    )));
  }

  Future<void> selectWeek() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: startDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        startDateTime = dateTime;
        endDateTime = dateTime.add(const Duration(days: 6));
      });
    } else {
      return;
    }
  }

  Future<List<Booking>> getBookingHistory() async {
    try {
      List<Booking> bookings = [];
      QuerySnapshot querySnapshot = await db
          .collection('users')
          .doc(currentUser!.uid)
          .collection('bookings')
          .get();
      querySnapshot.docs.forEach((b) {
        List<Map<String, dynamic>> services = [];
        List<dynamic> servicesData = b['services'];
        servicesData.forEach((element) {
          services.add(Map<String, dynamic>.from(element));
        });
        bookings.add(
          Booking(
              clientId: b['clientId'],
              clientUsername: b['clientUsername'],
              customerUsername: b['customerUsername'],
              dateFrom: b['dateFrom'].toDate(),
              dateTo: b['dateTo'].toDate(),
              location: b['location'],
              paymentMethod: b['paymentMethod'],
              reference: b['reference'],
              serviceFee: b['serviceFee'],
              services: services,
              status: b['status'],
              totalAmount: b['totalAmount']),
        );
      });
      return bookings;
    } catch (e) {
      log('error getting booking history $e');
      return [];
    }
  }

  List<Booking> filterBookingsByMonth(List<Booking> bookings, int month) {
    return bookings
        .where((element) => element.dateFrom.month == month)
        .toList();
  }

  List<Booking> filterBookingsByWeek(
      List<Booking> bookings, DateTime startDateTime) {
    DateTime endTime = startDateTime.add(const Duration(days: 6));
    return bookings
        .where((element) =>
            element.dateFrom.isAfter(startDateTime) &&
            element.dateTo.isBefore(endTime))
        .toList();
  }

  List<Booking> filterBookingsByAll(List<Booking> bookings) {
    return bookings.where((status) => status.status == 'finished').toList();
  }

  Map<String, dynamic> statistics({
    required List<Booking> filteredBooking,
  }) {
    //filters all those booking lists to finished
    List<Booking> finishedBookings = filteredBooking
        .where((element) => element.status == 'finished')
        .toList();
    // gets the count of status "pending"
    int pendingCount =
        filteredBooking.where((element) => element.status == 'pending').length;

    // gets the count of status "denied"
    int deniedCount =
        filteredBooking.where((element) => element.status == 'denied').length;

    // gets the count of status "paid"
    int paidCount =
        filteredBooking.where((element) => element.status == 'paid').length;

    // gets the count of status "finished"
    int finishedCount =
        filteredBooking.where((element) => element.status == 'finished').length;

    // gets the total service fee of all bookings
    double totalSales = finishedBookings.fold(
        0,
        (total, booking) =>
            total + double.parse(booking.totalAmount.replaceAll(',', '')));

    // counts occurrences of each service
    Map<String, int> serviceCounts = {};
    finishedBookings.forEach((booking) {
      booking.services.forEach((service) {
        if (booking.status == 'finished') {
          String serviceName = service['serviceName'];
          serviceCounts[serviceName] = (serviceCounts[serviceName] ?? 0) + 1;
        }
      });
    });

    // determine most occurred service
    String mostOccurredService = serviceCounts.entries.isNotEmpty
        ? serviceCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '';

    // identify the top recurring customer
    Map<String, int> customerCount = {};
    finishedBookings.forEach((booking) {
      if (booking.status == 'finished') {
        String customerUsername = booking.customerUsername;
        customerCount[customerUsername] =
            (customerCount[customerUsername] ?? 0) + 1;
      }
    });
    String topRecurringCustomer = customerCount.entries.isNotEmpty
        ? customerCount.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '';

    return {
      'pendingAppointments': pendingCount,
      'deniedAppointments': deniedCount,
      'paidAppointments': paidCount,
      'finishedAppointments': finishedCount,
      'totalSales': totalSales,
      'mostOcurringService': mostOccurredService,
      'topRecurringCustomer': topRecurringCustomer,
    };
  }

  int countStatusOfAppointment({
    required List<Booking> bookings,
    required String status,
  }) {
    int statusCount = 0;
    bookings.forEach((element) {
      if (element.status == status) {
        statusCount++;
      }
    });
    return statusCount;
  }

  double calculateTotalSales(List<Booking> bookings) {
    double totalSales = 0;
    bookings.forEach((element) {
      if (element.status == 'finished') {
        totalSales += double.parse(element.totalAmount.replaceAll(',', ''));
      }
    });
    return totalSales;
  }

  String mostRecurringService(List<Booking> bookings) {
    Map<String, int> serviceCounts = {};
    bookings.forEach((booking) {
      booking.services.forEach((service) {
        if (booking.status == 'finished') {
          String serviceName = service['serviceName'];
          serviceCounts[serviceName] = (serviceCounts[serviceName] ?? 0) + 1;
        }
      });
    });
    String mostRecurringService = '';
    int maxCount = 0;
    serviceCounts.forEach((service, cnt) {
      if (cnt > maxCount) {
        mostRecurringService = service;
        maxCount = cnt;
      }
    });
    return mostRecurringService;
  }

  String mostRecurringCustomer(List<Booking> bookings) {
    Map<String, int> customerCount = {};
    for (var booking in bookings) {
      if (booking.status == 'finished') {
        customerCount[booking.customerUsername] =
            (customerCount[booking.customerUsername] ?? 0) + 1;
      }
    }
    String mostRecurringCustomer = '';
    int maxCount = 0;
    customerCount.forEach((customer, cnt) {
      if (cnt > maxCount) {
        mostRecurringCustomer = customer;
        maxCount = cnt;
      }
    });
    return mostRecurringCustomer;
  }
}
