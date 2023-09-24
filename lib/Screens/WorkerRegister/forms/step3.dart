// ignore_for_file: camel_case_types, library_private_types_in_public_api, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:intl/intl.dart';

class thirdStep extends StatefulWidget {
  const thirdStep({Key? key}) : super(key: key);

  @override
  _thirdStepState createState() => _thirdStepState();
}

class _thirdStepState extends State<thirdStep> {
  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        const Text(
          "Experiences\n",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Section(),
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
                  widgets.add(const Section());
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
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cannot delete fields')));
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

class Section extends StatefulWidget {
  const Section({Key? key}) : super(key: key);

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  TextEditingController salonName = TextEditingController();
  TextEditingController salonAddress = TextEditingController();
  TextEditingController salonNum = TextEditingController();
  DateTimeRange selectedDays = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
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
