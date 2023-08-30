// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../../components/widgets.dart';
import '../../../constants.dart';

class firstStep extends StatefulWidget {
  const firstStep({Key? key}) : super(key: key);

  @override
  _firstStepState createState() => _firstStepState();
}

class _firstStepState extends State<firstStep> {
  final gender = ["Male", "Female", "Non-binary"];
  String? value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.topRight,
          child: Text(
            "Required*",
            style: TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontFamily: 'Inter',
            ),
          ),
        ),
        const SizedBox(height: defaultPadding),
        const Text(
          "User Information",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flatTextField("First Name*"),
        flatTextField("Middle Name"),
        flatTextField("Last Name*"),
        Align(
          alignment: Alignment.topLeft,
          child: DropdownButton<String>(
              value: value,
              icon: const Icon(Icons.arrow_drop_down),
              // elevation: 16,
              style: const TextStyle(fontSize: 13),
              underline: Container(
                color: kPrimaryColor,
                height: 2,
              ),
              onChanged: (value) => setState(() => this.value = value),
              items: gender.map(buildMenuItem).toList()),
        ),
        const SizedBox(height: defaultPadding),
        const Text(
          "Contact Info",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flatTextField("Primary Phone Number*"),
        flatTextField("Secondary Phone Number"),
        const SizedBox(height: defaultPadding),
        const Text(
          "Address",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flatTextField("City"),
        flatTextField("Barangay"),
        flatTextField("Street Address"),
        flatTextField("Extended Address"),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      );
}
