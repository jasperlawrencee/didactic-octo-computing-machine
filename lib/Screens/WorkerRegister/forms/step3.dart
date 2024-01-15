// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:intl/intl.dart';

class thirdStep extends StatefulWidget {
  const thirdStep({Key? key}) : super(key: key);

  @override
  _thirdStepState createState() => _thirdStepState();
}

class _thirdStepState extends State<thirdStep> {
  int index = 0;
  List<Widget> widgets = [];

  TextEditingController salonName = TextEditingController();
  TextEditingController salonAddress = TextEditingController();
  TextEditingController salonNum = TextEditingController();
  DateTimeRange selectedDays =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    try {
      salonName.addListener(() {
        workerForm.experienceName[index] = salonName.text;
      });
      salonAddress.addListener(() {
        workerForm.experienceAddress[index] = salonAddress.text;
      });
      salonNum.addListener(() {
        workerForm.experienceNum[index] = salonNum.text;
      });
    } catch (e) {
      log(e.toString());
    }

    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        const Text(
          "Experiences\n",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Section(
            salonName: salonName,
            salonAddress: salonAddress,
            salonNum: salonNum,
            selectedDays: selectedDays),
        const SizedBox(height: defaultPadding),
        Column(
          children: widgets,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  widgets.add(Section(
                      salonName: salonName,
                      salonAddress: salonAddress,
                      salonNum: salonNum,
                      selectedDays: selectedDays));
                  index++;
                  log(index.toString());
                });
              },
              child: const Text("Add More+"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  try {
                    // ignore: unrelated_type_equality_checks
                    widgets != 0 ? widgets.removeLast() : null;
                    index--;
                    log(index.toString());
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Unable to delete field')));
                  }
                });
              },
              child: const Text("Delete Section"),
            ),
          ],
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class Section extends StatefulWidget {
  TextEditingController salonName = TextEditingController();
  TextEditingController salonAddress = TextEditingController();
  TextEditingController salonNum = TextEditingController();
  DateTimeRange selectedDays =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  Section(
      {Key? key,
      required this.salonName,
      required this.salonAddress,
      required this.salonNum,
      required this.selectedDays})
      : super(key: key);

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  String dateString = '02-27-2002';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        flatTextField("Salon Name*", widget.salonName),
        flatTextField("Salon Address*", widget.salonAddress),
        flatTextField("Salon Contact Number", widget.salonNum),
        const SizedBox(height: defaultPadding),
        Column(
          children: [
            Text(
                "${DateFormat.yMMMd().format(widget.selectedDays.start)} to ${DateFormat.yMMMd().format(widget.selectedDays.end)}"),
            ElevatedButton(
              child: const Text('Select Dates'),
              onPressed: () async {
                final DateTimeRange? dateTimeRange = await showDateRangePicker(
                    initialEntryMode: DatePickerEntryMode.inputOnly,
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2500));
                if (dateTimeRange != null) {
                  setState(() {
                    widget.selectedDays = dateTimeRange;
                    //temporary
                    workerForm.selectedDays[0] =
                        "${DateFormat.yMMMd().format(widget.selectedDays.start)} to ${DateFormat.yMMMd().format(widget.selectedDays.end)}";
                  });
                } else {
                  log('no dates selected');
                }
              },
            )
          ],
        )
      ],
    );
  }
}
