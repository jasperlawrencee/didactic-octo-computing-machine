import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  TextEditingController eventTitle = TextEditingController();
  TimeOfDay timeFrom = TimeOfDay.now();
  TimeOfDay timeTo = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: SafeArea(
              child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: kPrimaryColor,
                    ),
                  ),
                  const Text('Add Event',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold)),
                  const SizedBox(width: defaultPadding),
                ],
              ),
              const SizedBox(height: defaultPadding),
              flatTextField('Event Title', eventTitle),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: timeFrom,
                            initialEntryMode: TimePickerEntryMode.inputOnly);
                      },
                      child: Text('${timeFrom.hour}:${timeFrom.minute}'))
                ],
              ),
              const SizedBox(height: defaultPadding),
              nextButton(context, () {}, 'Add Event')
            ],
          ),
        ),
      ))),
    );
  }
}
