// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/SalonRegister/forms/step1.dart';
import 'package:flutter_auth/Screens/SalonRegister/forms/step2.dart';
import 'package:flutter_auth/Screens/SalonRegister/forms/step3.dart';
import 'package:flutter_auth/Screens/SalonRegister/verification.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class SalonRegisterScreen extends StatefulWidget {
  const SalonRegisterScreen({Key? key}) : super(key: key);

  @override
  _SalonRegisterScreenState createState() => _SalonRegisterScreenState();
}

class _SalonRegisterScreenState extends State<SalonRegisterScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Theme(
        data: ThemeData(
            canvasColor: Colors.transparent,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: kPrimaryColor,
                  background: Colors.white70,
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
                    if (currentStep >= 0 && currentStep <= 1)
                      ElevatedButton(
                        onPressed: controls.onStepContinue,
                        child: const Text("NEXT"),
                      ),
                    if (currentStep == 2)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SalonSummaryScreen()));
                        },
                        child: const Text("NEXT"),
                      ),
                    if (currentStep != 0)
                      TextButton(
                        onPressed: controls.onStepCancel,
                        child: const Text(
                          "BACK",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
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
          content: const step3(),
        ),
      ];
}
