// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String fName;
  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Theme(
        data: ThemeData(
            canvasColor: Colors.white70,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: kPrimaryColor,
                  background: Colors.white70,
                  secondary: kPrimaryLightColor,
                )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Stepper(
            elevation: 0,
            type: StepperType.vertical,
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
            title: Text('Bio Data'),
            content: Text("data")),
        Step(
          isActive: currentStep >= 1,
          title: Text('Valid ID'),
          content: Text("data"),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text('Service Category'),
          content: Text("data"),
        ),
        Step(
          isActive: currentStep >= 3,
          title: Text('Credentials'),
          content: Text("data"),
        ),
        Step(
          isActive: currentStep >= 4,
          title: Text('Review'),
          content: Text("data"),
        ),
      ];
}
