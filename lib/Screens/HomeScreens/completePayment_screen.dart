// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class CompletePayment extends StatefulWidget {
  const CompletePayment({Key? key}) : super(key: key);

  @override
  State<CompletePayment> createState() => _CompletePaymentState();
}

class _CompletePaymentState extends State<CompletePayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: SafeArea(
              child: Container(
        margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
        child: Theme(
            data: ThemeData(
                canvasColor: Colors.transparent,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: kPrimaryColor,
                      background: Colors.white70,
                      secondary: kPrimaryLightColor,
                    )),
            child: Column(
              children: <Widget>[
                const Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 30,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.check_circle_outline_sharp,
                  color: kPrimaryColor,
                  size: 120,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Juan dela Cruz',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 5),
                        Text('Magallanes, Bolton Extension, Davao City'),
                      ],
                    ),
                    Text(
                      'Ref. 123456',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                const SingleChildScrollView(),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Placeholder()));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                    horizontal: 75,
                    vertical: 10,
                  )),
                  child: const Text(
                    'View Calendar',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: defaultPadding)
              ],
            )),
      ))),
    );
  }
}
