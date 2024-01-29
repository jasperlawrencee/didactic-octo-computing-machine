// ignore_for_file: camel_case_types, library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/experience.dart';
import 'package:intl/intl.dart';

class thirdStep extends StatefulWidget {
  const thirdStep({Key? key}) : super(key: key);

  @override
  _thirdStepState createState() => _thirdStepState();
}

int index = 0;

class _thirdStepState extends State<thirdStep> {
  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    if (workerForm.experiences.isEmpty) {
      workerForm.experiences.add(Experience());
    }
    return Column(
      children: [
        const Text(
          "Experiences\n",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ExperienceSection(),
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
                  widgets.add(ExperienceSection());
                  workerForm.experiences.add(Experience());
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
                    workerForm.experiences.removeLast();
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
        ),
        // TextButton(
        //     onPressed: () {
        //       log(workerForm.experiences.map((e) => e.log()).join("\n \n"));
        //     },
        //     child: Text('data'))
      ],
    );
  }
}

// ignore: must_be_immutable
class ExperienceSection extends StatefulWidget {
  ExperienceSection({
    Key? key,
  }) : super(key: key);

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  String dateString = '02-27-2002';
  TextEditingController salonName = TextEditingController();
  TextEditingController salonAddress = TextEditingController();
  TextEditingController salonNum = TextEditingController();
  DateTimeRange selectedDays =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  void initState() {
    super.initState();
    try {
      salonName.addListener(() {
        workerForm.experiences[index].name = salonName.text;
      });
      salonAddress.addListener(() {
        workerForm.experiences[index].address = salonAddress.text;
      });
      salonNum.addListener(() {
        workerForm.experiences[index].contactNum = salonNum.text;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        flatTextField("Salon Name*", salonName),
        flatTextField("Salon Address*", salonAddress),
        flatTextField("Salon Contact Number", salonNum),
        const SizedBox(height: defaultPadding),
        Column(
          children: [
            Text(
                "${DateFormat.yMMMd().format(selectedDays.start)} to ${DateFormat.yMMMd().format(selectedDays.end)}"),
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
                    selectedDays = dateTimeRange;
                    //temporary
                    workerForm.experiences[index].date =
                        "${DateFormat.yMMMd().format(selectedDays.start)} to ${DateFormat.yMMMd().format(selectedDays.end)}";
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
