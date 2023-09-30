// ignore_for_file: camel_case_types, library_private_types_in_public_api, unrelated_type_equality_checks, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/forms.dart';
import 'package:intl/intl.dart';

//parent widget
class thirdStep extends StatefulWidget {
  final WorkerForm wForm;
  const thirdStep({Key? key, required this.wForm}) : super(key: key);

  @override
  _thirdStepState createState() => _thirdStepState();
}

class _thirdStepState extends State<thirdStep> {
  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    TextEditingController salonName = TextEditingController();
    TextEditingController salonAddress = TextEditingController();
    TextEditingController salonNum = TextEditingController();
    DateTimeRange selectedDays = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );

    salonName.addListener(() {
      log(widget.wForm.experiences.toString());
      for (int i = 0; i < widget.wForm.experiences!.length; i++) {
        for (int j = 0; j < widget.wForm.experiences![i].length; j++) {
          widget.wForm.experiences![i][j] = salonName.text;
        }
      }
    });

    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        const Text(
          "Experiences\n",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Section(salonName, salonAddress, salonNum, selectedDays),
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
                    salonName,
                    salonAddress,
                    salonNum,
                    selectedDays,
                  ));
                });
              },
              child: const Text("Add More+"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  try {
                    widgets != 0 ? widgets.removeLast() : null;
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
        TextButton(
            onPressed: () {
              log('number of sections: ${widgets.length + 1}');
              log(widget.wForm.experiences.toString());
            },
            child: const Text('data'))
      ],
    );
  }

  Widget Section(
    TextEditingController salonName,
    salonAddress,
    salonNum,
    DateTimeRange selectedDays,
  ) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        flatTextField("Salon Name*", salonName),
        flatTextField("Salon Address*", salonAddress),
        flatTextField("Salon Contact Number", salonNum),
        const SizedBox(height: defaultPadding),
        Text(
            '${DateFormat.yMMMd().format(selectedDays.start)} to ${DateFormat.yMMMd().format(selectedDays.end)}'),
        ElevatedButton(
          onPressed: () async {
            final DateTimeRange? dateTimeRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2500),
              initialEntryMode: DatePickerEntryMode.inputOnly,
            );
            if (dateTimeRange != null) {
              setState(() {
                selectedDays = dateTimeRange;
              });
            }
          },
          child: const Text('Duration of Experience'),
        ),
        const Text('Example: Date From - Date To')
      ],
    );
  }
}
