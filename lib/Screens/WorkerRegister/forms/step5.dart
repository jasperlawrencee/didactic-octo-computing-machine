// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step1.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step2.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step3.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step4.dart';
import 'package:flutter_auth/constants.dart';

class fifthStep extends StatefulWidget {
  const fifthStep({Key? key}) : super(key: key);

  @override
  _fifthStepState createState() => _fifthStepState();
}

class _fifthStepState extends State<fifthStep> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Summary",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        firstStep(),
        SizedBox(height: defaultPadding),
        secondStep(),
        SizedBox(height: defaultPadding),
        thirdStep(),
        SizedBox(height: defaultPadding),
        fourthStep(),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}
