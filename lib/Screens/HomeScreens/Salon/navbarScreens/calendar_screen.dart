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
    try {
      final experiences = await _firestore
          .collectionGroup('experiences')
          .where('salon', isEqualTo: await getUsername())
          .get();
      if (experiences.docs.isNotEmpty) {
        log('naay employees');
        return [];
      } else {
        return [];
      }
    } catch (e) {
      log('error getting employees $e');
      return [];
    }
  }

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
                    children: [
                      SfCalendar(
                        view: CalendarView.day,
                        allowViewNavigation: true,
                        onTap: calendarTapped,
                        allowedViews: const [
                          CalendarView.day,
                          CalendarView.week,
                          CalendarView.month,
                        ],
                        dataSource: MeetingDataSource(_getDataSource()),
                        monthViewSettings: const MonthViewSettings(
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.appointment),
                      ),
                    ],
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

  String? _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '';

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.subject;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.startTime)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.startTime).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.endTime).toString();
      if (appointmentDetails.isAllDay) {
        _timeDetails = 'All day';
      } else {
        _timeDetails = '$_startTimeText - $_endTimeText';
      }
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return SalonAppointmentScreen();
        },
      ));
    }
  }
}

List<Appointment> _getDataSource() {
  final List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  bool isApproved = false;
  meetings.add(Appointment(
    subject: 'Gravy Hair Shampoo and Rebond',
    startTime: startTime,
    endTime: endTime,
    color: isApproved ? kPrimaryColor : Colors.grey,
  ));
  meetings.add(Appointment(
    subject: 'Palabok Hair Treatment',
    startTime: DateTime(today.year, today.month, today.day, 12, 0, 0),
    endTime: DateTime(today.year, today.month, today.day, 15, 0, 0),
    color: kPrimaryColor,
  ));
  meetings.add(Appointment(
    subject: 'Spaghetti Nail Treatment',
    startTime: DateTime(today.year, today.month, today.day, 15, 0, 0),
    endTime: DateTime(today.year, today.month, today.day, 16, 0, 0),
    color: isApproved ? kPrimaryColor : Colors.grey,
  ));
  return meetings;
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
