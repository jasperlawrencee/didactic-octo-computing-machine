// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/SalonRegister/forms/step1.dart';
import 'package:flutter_auth/Screens/SalonRegister/forms/step2.dart';
import 'package:flutter_auth/constants.dart';

class step3 extends StatefulWidget {
  const step3({Key? key}) : super(key: key);

  @override
  _step3State createState() => _step3State();
}

class _step3State extends State<step3> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Summary",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        step1(),
        SizedBox(height: defaultPadding),
        step2(),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}
