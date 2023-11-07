// ignore_for_file: camel_case_types, library_private_types_in_public_api, unrelated_type_equality_checks, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:intl/intl.dart';

//parent widget
class thirdStep extends StatefulWidget {
  const thirdStep({Key? key}) : super(key: key);

  @override
  _thirdStepState createState() => _thirdStepState();
}

class _thirdStepState extends State<thirdStep> {
  TextEditingController experienceName = TextEditingController();
  TextEditingController experienceAddress = TextEditingController();
  TextEditingController experienceNum = TextEditingController();
  DateTimeRange selectedDays = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  int index = 0;
  List<Widget> widgetList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        const Text(
          "Experiences\n(Optional)",
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: defaultPadding),
        Column(
          children: [
            Section(index),
            Column(
              children: widgetList,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  widgetList.add(Section(index));
                });
                index++;
                log('list index $index');
              },
              child: const Text("Add More+"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  try {
                    widgetList != 0 ? widgetList.removeLast() : null;
                    index--;
                    log('list index $index');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Unable to delete field')));
                  }
                });
              },
              child: const Text("Delete Section"),
            ),
          ],
        ),
      ],
    );
  }

  Widget Section(int index) {
    experienceName.addListener(() {
      try {
        workerForm.experiences?[index].clear();
        workerForm.experiences?[index].add(experienceName.text);
        log("${workerForm.experiences?[index]}");
      } catch (e) {
        log(e.toString());
      }
    });
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        flatTextField("Salon Name*", experienceName),
        flatTextField("Salon Address*", experienceAddress),
        flatTextField("Salon Contact Number", experienceNum),
        const SizedBox(height: defaultPadding),
        Text(workerForm.selectedDays.isEmpty
            ? 'Date Selected'
            : workerForm.selectedDays.toString()),
        ElevatedButton(
          onPressed: () async {
            DateTimeRange? dateTimeRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2500),
              initialEntryMode: DatePickerEntryMode.inputOnly,
            );
            if (dateTimeRange != null) {
              setState(() {
                selectedDays = dateTimeRange;
                workerForm.selectedDays =
                    "${DateFormat.yMMMd().format(selectedDays.start)} to ${DateFormat.yMMMd().format(selectedDays.end)}";
                log(workerForm.selectedDays);
              });
            } else {
              log('wala');
            }
          },
          child: const Text('Duration of Experience'),
        ),
        const Text('Example: Date From - Date To')
      ],
    );
  }
}
