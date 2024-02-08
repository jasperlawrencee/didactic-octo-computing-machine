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
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text(
            "Thank You for Signing In!\nBefore Proceeding into the final step of signing up\nWe need to verify the validity of the documents that you have submitted\nThis will only take up to 3-5 business days.",
            textAlign: TextAlign.center,
            style: TextStyle(color: kPrimaryColor),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()));
              },
              child: const Text(
                "Proceed to Home",
                selectionColor: Colors.white,
                style: TextStyle(color: Colors.white),
              )),
          const SizedBox(height: defaultPadding),
        ],
      ),
    ));
  }
}
