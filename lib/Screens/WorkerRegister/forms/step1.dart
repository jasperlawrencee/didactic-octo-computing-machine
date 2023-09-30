// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_auth/models/forms.dart';

import '../../../components/widgets.dart';
import '../../../constants.dart';

class firstStep extends StatefulWidget {
  final WorkerForm wForm;
  const firstStep({Key? key, required this.wForm}) : super(key: key);

  @override
  _firstStepState createState() => _firstStepState();
}

String? genderValue;

class _firstStepState extends State<firstStep> {
  @override
  Widget build(BuildContext context) {
    final gender = ["Male", "Female", "Non-binary"];
    TextEditingController firstName = TextEditingController();
    TextEditingController middleName = TextEditingController();
    TextEditingController lastName = TextEditingController();
    TextEditingController phoneNum1 = TextEditingController();
    TextEditingController phoneNum2 = TextEditingController();
    TextEditingController city = TextEditingController();
    TextEditingController barangay = TextEditingController();
    TextEditingController stAddress = TextEditingController();
    TextEditingController extAddress = TextEditingController();

    firstName.addListener(() {
      widget.wForm.firstName = firstName.text;
    });
    middleName.addListener(() {
      widget.wForm.middleName = middleName.text;
    });
    lastName.addListener(() {
      widget.wForm.lastName = lastName.text;
    });
    phoneNum1.addListener(() {
      widget.wForm.phoneNum1 = phoneNum1.text;
    });
    phoneNum2.addListener(() {
      widget.wForm.phoneNum2 = phoneNum2.text;
    });
    city.addListener(() {
      widget.wForm.city = city.text;
    });
    barangay.addListener(() {
      widget.wForm.barangay = barangay.text;
    });
    stAddress.addListener(() {
      widget.wForm.stAddress = stAddress.text;
    });
    extAddress.addListener(() {
      widget.wForm.extAddress = extAddress.text;
    });

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
        flatTextField("First Name*", firstName),
        flatTextField("Middle Name", middleName),
        flatTextField("Last Name*", lastName),
        Align(
          alignment: Alignment.topLeft,
          child: Theme(
            data: ThemeData(canvasColor: Colors.white),
            child: DropdownButton<String>(
              hint: const Text("Gender"),
              value: genderValue,
              icon: const Icon(Icons.arrow_drop_down),
              // elevation: 16,
              style: const TextStyle(fontSize: 13, color: Colors.black),
              underline: Container(
                color: kPrimaryColor,
                height: 2,
              ),
              onChanged: (value) => setState(() => {
                    genderValue = value,
                    widget.wForm.gender = genderValue,
                  }),
              items: gender.map(buildMenuItem).toList(),
            ),
          ),
        ),
        const SizedBox(height: defaultPadding),
        const Text(
          "Contact Info",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flatTextField("Primary Phone Number*", phoneNum1),
        flatTextField("Secondary Phone Number", phoneNum2),
        const SizedBox(height: defaultPadding),
        const Text(
          "Address",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flatTextField("City", city),
        flatTextField("Barangay", barangay),
        flatTextField("Street Address", stAddress),
        flatTextField("Extended Address", extAddress),
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
