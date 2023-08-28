// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

class thirdStep extends StatefulWidget {
  const thirdStep({Key? key}) : super(key: key);

  @override
  _thirdStepState createState() => _thirdStepState();
}

class _thirdStepState extends State<thirdStep> {
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Experiences"),
        flatTextField("Salon Name"),
        flatTextField("Salon Address"),
        flatTextField("Salon Contact Number"),
        const SizedBox(height: defaultPadding),
        Row(
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
                Text(DateUtils.dateOnly(dateFrom).toString()),
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
                Text(DateUtils.dateOnly(dateTo).toString()),
              ],
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        ElevatedButton(onPressed: () {}, child: const Text("Add More+"))
      ],
    );
  }
}
