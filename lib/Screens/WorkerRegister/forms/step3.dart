// ignore_for_file: camel_case_types, library_private_types_in_public_api

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
  String dateFormat = DateFormat.yMMMMd().format(DateTime.now());
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();
  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Experiences\n",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flatTextField("Salon Name*"),
        flatTextField("Salon Address*"),
        flatTextField("Salon Contact Number"),
        const SizedBox(height: defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: dateFrom,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (newDate == null) return;
                    setState(() => dateFrom = newDate);
                  },
                  child: const Text("Date From"),
                ),
                Text(DateFormat.yMMMMd().format(dateFrom)),
              ],
            ),
            const SizedBox(
              width: defaultPadding,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: dateTo,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (newDate == null) return;
                    setState(() => dateTo = newDate);
                  },
                  child: const Text("Date To"),
                ),
                Text(DateFormat.yMMMMd().format(dateTo)),
              ],
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        TextButton(
            onPressed: () {
              widgets.add(Text('New Widget ${widgets.length + 1}'));
            },
            child: const Text("Add More+")),
      ],
    );
  }
}
