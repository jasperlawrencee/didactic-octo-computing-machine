// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/Worker/appointment_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class WorkerCalendarPage extends StatefulWidget {
  const WorkerCalendarPage({Key? key}) : super(key: key);

  @override
  State<WorkerCalendarPage> createState() => _WorkerCalendarPageState();
}

class _WorkerCalendarPageState extends State<WorkerCalendarPage> {
  TextEditingController eventTitle = TextEditingController();
  TimeOfDay timeFrom = TimeOfDay.now();
  TimeOfDay timeTo = TimeOfDay.now();
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
                      "Calendar".toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: defaultPadding)
                  ],
                ),
                //Calendar Widget
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
      ),
    );
  }

  String? _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '';

  //shows event details when tapped
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
          return WorkerAppointmentScreen();
        },
      ));
    }
  }

  List<Appointment> _getDataSource() {
    final List<Appointment> meetings = <Appointment>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
      Appointment(
          subject: 'Haircut',
          startTime: startTime,
          endTime: endTime,
          color: kPrimaryColor),
    );
    meetings.add(
      Appointment(
          subject: 'Hair Color',
          startTime: DateTime(today.year, today.month, today.day, 13, 0, 0),
          endTime: DateTime(today.year, today.month, today.day, 15, 0, 0),
          color: kPrimaryColor),
    );
    return meetings;
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
