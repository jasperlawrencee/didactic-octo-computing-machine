// ignore_for_file: must_be_immutable, non_constant_identifier_names, camel_case_types, library_private_types_in_public_api, duplicate_ignore

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/Worker/worker_screen.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step1.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step2.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step3.dart';
import 'package:flutter_auth/Screens/WorkerRegister/forms/step4.dart';
import 'package:flutter_auth/Screens/WorkerRegister/summary.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/forms.dart';

WorkerForm workerForm = WorkerForm(hair: [
  ''
], makeup: [
  ''
], spa: [
  ''
], nails: [
  ''
], lashes: [
  ''
], wax: [
  ''
], experiences: [
  ['']
], selectedDays: '');

class WorkerRegisterScreen extends StatefulWidget {
  const WorkerRegisterScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorkerRegisterScreenState createState() => _WorkerRegisterScreenState();
}

class _WorkerRegisterScreenState extends State<WorkerRegisterScreen> {
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    workerForm = WorkerForm(hair: [
      ''
    ], makeup: [
      ''
    ], spa: [
      ''
    ], nails: [
      ''
    ], lashes: [
      ''
    ], wax: [
      ''
    ], experiences: [
      ['']
    ], selectedDays: '');
  }

  @override
  Widget build(BuildContext context) {
    List<Step> getSteps() => [
          Step(
            isActive: currentStep >= 0,
            title: const Text(''),
            content: const firstStep(),
          ),
          Step(
            isActive: currentStep >= 1,
            title: const Text(''),
            content: const secondStep(),
          ),
          Step(
            isActive: currentStep >= 2,
            title: const Text(''),
            content: const thirdStep(),
          ),
          Step(
            isActive: currentStep >= 3,
            title: const Text(''),
            content: const fourthStep(),
          ),
        ];

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
                    if (currentStep != 0)
                      TextButton(
                        onPressed: controls.onStepCancel,
                        child: const Text(
                          "BACK",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    if (currentStep >= 0 && currentStep <= 2)
                      ElevatedButton(
                        onPressed: controls.onStepContinue,
                        child: const Text("NEXT"),
                      ),
                    if (currentStep == 3)
                      ElevatedButton(
                        onPressed: () {
                          _dialogBuilder(context);
                        },
                        child: const Text("NEXT"),
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
    currentStep < 3 ? setState(() => currentStep += 1) : null;
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
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Summary()));
              },
            ),
          ],
        );
      },
    );
  }

  addRoleToFireStore() {
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    try {
      ref.doc(user!.uid).update({'role': 'freelancer'});
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const WorkerScreen();
      }));
      log("added freelancer role to firestore");
    } catch (e) {
      log("$user $ref");
      log(e.toString());
    }
  }
}
