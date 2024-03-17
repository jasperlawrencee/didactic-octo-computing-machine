// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/Salon/appointment_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController eventTitle = TextEditingController();
  TimeOfDay timeFrom = TimeOfDay.now();
  TimeOfDay timeTo = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Calendar".toUpperCase(),
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
              Theme(
                data: ThemeData(
                    canvasColor: Colors.transparent,
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: kPrimaryColor,
                          background: Colors.white,
                          secondary: kPrimaryLightColor,
                        )),
                child: Expanded(
                  child: Stack(
                    children: [calendarBuilder()],
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding)
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Appointment>> calendarBuilder() {
    return StreamBuilder(
      stream: Stream.fromFuture(getAppointments()),
      builder: (context, appointments) {
        if (appointments.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        } else if (appointments.hasError) {
          return Center(
            child: Text("Error getting appointments ${appointments.error}"),
          );
        } else {
          return SfCalendar(
            showNavigationArrow: true,
            showTodayButton: true,
            view: CalendarView.day,
            allowViewNavigation: true,
            onTap: calendarTapped,
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.month,
            ],
            dataSource: MeetingDataSource(appointments.data!),
            monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment),
            // appointmentBuilder:
            //     (BuildContext context, CalendarAppointmentDetails details) {
            //   Appointment appointmentData = details.appointments.first;
            //   Color appointmentColor =
            //       appointmentData.subject.contains('pending')
            //           ? Colors.grey
            //           : appointmentData.subject.contains('confirmed')
            //               ? kPrimaryColor
            //               : appointmentData.subject.contains('completed')
            //                   ? Colors.green
            //                   : Colors.black;
            //   return Container(
            //     color: appointmentColor,
            //     child: Text(details.appointments.first.subject),
            //   );
            // },
          );
        }
      },
    );
  }

  Future<List<Appointment>> getAppointments() async {
    List<Map<String, dynamic>> appointments = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('bookings')
          .get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        appointments.add(data);
      });

      final List<Appointment> appointmentList = appointments.map((a) {
        // Assign a default color if 'status' doesn't match any expected values
        final color = a['status'] == 'pending'
            ? Colors.grey
            : a['status'] == 'confirmed'
                ? kPrimaryColor
                : Colors.green;
        final appointment = Appointment(
          notes: a['customerID'],
          subject: a['services'].toString(),
          location: a['location'],
          startTime: a['dateFrom'].toDate(),
          endTime: a['dateTo'].toDate(),
          color: color ?? Colors.grey, // Fallback color
        );
        return appointment;
      }).toList();

      return appointmentList;
    } catch (e) {
      log('Error getting appointments: $e');
      return []; // Return empty list in case of error
    }
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      Appointment appointment = details.appointments![0];
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return SalonAppointmentScreen(
              appointment: appointment,
            );
          },
        ));
      }
    }
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
