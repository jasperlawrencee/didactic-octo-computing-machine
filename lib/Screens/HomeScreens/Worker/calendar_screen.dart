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
                      // Align(
                      //   alignment: Alignment.bottomRight,
                      //   child: FloatingActionButton(
                      //       child: const Icon(
                      //         Icons.add,
                      //         color: kPrimaryColor,
                      //       ),
                      //       onPressed: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     const EventScreen()));
                      //       }),
                      // ),
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
        _timeDetails = '$timeFrom - $timeTo';
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(child: const Text('$_subjectText')),
              content: Container(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '$_dateText',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
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
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('close'))
              ],
            );
          });
    }
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings
        .add(Meeting('Conference', startTime, endTime, kPrimaryColor, false));
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
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

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
