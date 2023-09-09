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
                    print(e);
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
  String dateFormat = DateFormat.yMMMMd().format(DateTime.now());
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        flatTextField("Salon Name*", salonName),
        flatTextField("Salon Address*", salonAddress),
        flatTextField("Salon Contact Number", salonNum),
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
      ],
    );
  }
}
