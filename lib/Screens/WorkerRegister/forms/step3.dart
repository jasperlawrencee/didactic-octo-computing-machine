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
  List<Widget> widgets = [];

  TextEditingController experienceName = TextEditingController();
  TextEditingController experienceAddress = TextEditingController();
  TextEditingController experienceNum = TextEditingController();
  DateTimeRange selectedDays = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    experienceName.addListener(() {
      workerForm.experienceName = experienceName.text;
    });
    experienceAddress.addListener(() {
      workerForm.experienceAddress = experienceAddress.text;
    });
    experienceNum.addListener(() {
      workerForm.experienceNum = experienceNum.text;
    });
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        const Text(
          "Experiences\n",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Section(experienceName, experienceAddress, experienceNum, selectedDays),
        const SizedBox(height: defaultPadding),
        Column(
          children: widgets,
        ),

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     TextButton(
        //       onPressed: () {
        //         setState(() {
        //           widgets.add(Section(
        //             salonName,
        //             salonAddress,
        //             salonNum,
        //             selectedDays,
        //           ));
        //         });
        //       },
        //       child: const Text("Add More+"),
        //     ),
        //     TextButton(
        //       onPressed: () {
        //         setState(() {
        //           try {
        //             widgets != 0 ? widgets.removeLast() : null;
        //           } catch (e) {
        //             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //                 content: Text('Unable to delete field')));
        //           }
        //         });
        //       },
        //       child: const Text("Delete Section"),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget Section(
    TextEditingController salonName,
    salonAddress,
    salonNum,
    DateTimeRange pickedDays,
  ) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        flatTextField("Salon Name*", salonName),
        flatTextField("Salon Address*", salonAddress),
        flatTextField("Salon Contact Number", salonNum),
        const SizedBox(height: defaultPadding),
        Text(
            '${DateFormat.yMMMd().format(pickedDays.start)} to ${DateFormat.yMMMd().format(pickedDays.end)}'),
        ElevatedButton(
          onPressed: () async {
            final DateTimeRange? dateTimeRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2500),
              initialEntryMode: DatePickerEntryMode.input,
            );
            if (dateTimeRange != null) {
              setState(() {
                pickedDays = dateTimeRange;
                workerForm.selectedDays =
                    "${DateFormat.yMMMd().format(pickedDays.start)} to ${DateFormat.yMMMd().format(pickedDays.end)}";
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
