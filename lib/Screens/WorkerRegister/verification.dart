// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class WorkerSummaryScreen extends StatefulWidget {
  const WorkerSummaryScreen({Key? key}) : super(key: key);

  @override
  _WorkerSummaryScreenState createState() => _WorkerSummaryScreenState();
}

class _WorkerSummaryScreenState extends State<WorkerSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Thank you for registering!\nKindly confirm your email address to complete\nthe registration",
          textAlign: TextAlign.center,
          style: TextStyle(color: kPrimaryColor),
        ),
        const SizedBox(height: defaultPadding),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()));
            },
            child: const Text("Proceed to Home")),
      ],
    ));
  }
}
