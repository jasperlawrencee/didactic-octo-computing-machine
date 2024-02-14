// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/SalonRegister/forms/step1.dart';
import 'package:flutter_auth/Screens/SalonRegister/forms/step2.dart';
import 'package:flutter_auth/Screens/SalonRegister/forms/step3.dart';
import 'package:flutter_auth/Screens/SalonRegister/summary.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/forms.dart';

SalonForm salonForm = SalonForm(
    salonName: '',
    roomBuilding: '',
    streetRoad: '',
    barangay: '',
    city: '',
    salonOwner: '',
    salonNumber: '',
    salonRepresentative: '',
    representativeEmail: '',
    representativeNum: '');

class SalonRegisterScreen extends StatefulWidget {
  const SalonRegisterScreen({Key? key}) : super(key: key);

  @override
  _SalonRegisterScreenState createState() => _SalonRegisterScreenState();
}

class _SalonRegisterScreenState extends State<SalonRegisterScreen> {
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    salonForm = SalonForm(
      salonName: '',
      roomBuilding: '',
      streetRoad: '',
      barangay: '',
      city: '',
      salonOwner: '',
      salonNumber: '',
      salonRepresentative: '',
      representativeEmail: '',
      representativeNum: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Step> getSteps() => [
          Step(
            isActive: currentStep >= 0,
            title: const Text(''),
            content: const step1(),
          ),
          Step(
            isActive: currentStep >= 1,
            title: const Text(''),
            content: const step2(),
          ),
          Step(
              isActive: currentStep >= 2,
              title: const Text(''),
              content: const step3())
        ];

    return Background(
      child: Theme(
        data: ThemeData(
            canvasColor: Colors.transparent,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: kPrimaryColor,
                  background: Colors.white,
                  secondary: kPrimaryLightColor,
                )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Stepper(
            controlsBuilder: (BuildContext context, ControlsDetails controls) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    if (currentStep != 0)
                      TextButton(
                        onPressed: controls.onStepCancel,
                        child: const Text(
                          "BACK",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    if (currentStep <= 0)
                      ElevatedButton(
                        onPressed: controls.onStepContinue,
                        child: const Text("NEXT"),
                      ),
                    if (currentStep == 1)
                      ElevatedButton(
                        onPressed: controls.onStepContinue,
                        child: const Text("NEXT"),
                      ),
                    if (currentStep == 2)
                      ElevatedButton(
                          onPressed: () {
                            _dialogBuilder(context);
                          },
                          child: const Text("NEXT"))
                  ],
                ),
              );
            },
            elevation: 0,
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue: continued,
            onStepCancel: cancel,
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => currentStep = step);
  }

  continued() {
    currentStep < 2 ? setState(() => currentStep += 1) : null;
  }

  cancel() {
    currentStep > 0 ? setState(() => currentStep -= 1) : null;
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Finalize and complete registration?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                if (salonFormComplete() == true) {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Summary();
                  }));
                } else if (salonFormComplete() == false) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      'Required Fields Are Empty',
                    ),
                    action: SnackBarAction(label: 'Close', onPressed: () {}),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool isValidated() {
    if (salonForm.salonName.isEmpty ||
        salonForm.roomBuilding.isEmpty ||
        salonForm.streetRoad.isEmpty ||
        salonForm.barangay.isEmpty ||
        salonForm.city.isEmpty ||
        salonForm.salonOwner.isEmpty ||
        salonForm.salonNumber.isEmpty ||
        salonForm.salonRepresentative.isEmpty ||
        salonForm.representativeEmail.isEmpty ||
        salonForm.representativeNum.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
