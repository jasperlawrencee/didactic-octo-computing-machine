// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison

import 'package:flutter/material.dart';
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
  TextEditingController eventTitle = TextEditingController();
  TimeOfDay timeFrom = TimeOfDay.now();
  TimeOfDay timeTo = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
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
                          background: Colors.white70,
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
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(
                  canvasColor: Colors.transparent,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: kPrimaryColor,
                        background: Colors.white70,
                        secondary: kPrimaryLightColor,
                      )),
              child: AlertDialog(
                title: Text('$_subjectText'),
                content: SizedBox(
                  height: 80,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('$_dateText',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 20))
                        ],
                      ),
                      const Row(
                        children: <Widget>[
                          Text(''),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(_timeDetails!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close')),
                  TextButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(kPrimaryColor),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      child: const Text('Approve')),
                ],
              ),
            );
          });
    }
  }
}

List<Appointment> _getDataSource() {
  final List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Appointment(
    subject: 'Gravy Hair Shampoo and Rebond',
    startTime: startTime,
    endTime: endTime,
    color: kPrimaryColor,
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
    color: kPrimaryColor,
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
