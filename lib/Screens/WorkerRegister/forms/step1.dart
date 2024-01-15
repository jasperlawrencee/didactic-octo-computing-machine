// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';
import 'package:intl/intl.dart';

import '../../../components/widgets.dart';
import '../../../constants.dart';

class firstStep extends StatefulWidget {
  const firstStep({Key? key}) : super(key: key);

  @override
  _firstStepState createState() => _firstStepState();
}

class _firstStepState extends State<firstStep> {
  String? genderValue;
  String birthday = "Birthday";
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNum1 = TextEditingController();
  TextEditingController phoneNum2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController barangay = TextEditingController();
  TextEditingController stAddress = TextEditingController();
  TextEditingController extAddress = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final gender = ["Male", "Female", "Non-binary"];

    firstName.addListener(() {
      workerForm.firstName = firstName.text;
    });
    middleName.addListener(() {
      workerForm.middleName = middleName.text;
    });
    lastName.addListener(() {
      workerForm.lastName = lastName.text;
    });
    phoneNum1.addListener(() {
      workerForm.phoneNum1 = phoneNum1.text;
    });
    phoneNum2.addListener(() {
      workerForm.phoneNum2 = phoneNum2.text;
    });
    city.addListener(() {
      workerForm.city = city.text;
    });
    barangay.addListener(() {
      workerForm.barangay = barangay.text;
    });
    stAddress.addListener(() {
      workerForm.stAddress = stAddress.text;
    });
    extAddress.addListener(() {
      workerForm.extAddress = extAddress.text;
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
        Row(
          children: [
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
                        workerForm.gender = genderValue,
                      }),
                  items: gender.map(buildMenuItem).toList(),
                ),
              ),
            ),
            const SizedBox(width: defaultPadding),
            InkWell(
              child: Text(
                birthday,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor,
                    decoration: TextDecoration.underline),
              ),
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2500))
                    .then((value) {
                  try {
                    if (value == null) {
                      setState(() {
                        birthday = "Birthdate is required";
                      });
                    } else {
                      setState(() {
                        setState(() {
                          birthday = DateFormat.yMMMd().format(value);
                          workerForm.birthday =
                              DateFormat.yMMMd().format(value);
                        });
                      });
                    }
                  } catch (e) {
                    log(e.toString());
                  }
                });
              },
            )
          ],
        ),
        const SizedBox(height: defaultPadding),
        const Text(
          "Contact Information",
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
