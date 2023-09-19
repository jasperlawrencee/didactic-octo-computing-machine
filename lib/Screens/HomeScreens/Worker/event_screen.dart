import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  TextEditingController eventTitle = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: SafeArea(
              child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: kPrimaryColor,
                    ),
                  ),
                  const Text('Add Event',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold)),
                  const SizedBox(width: defaultPadding),
                ],
              ),
              const SizedBox(height: defaultPadding),
              flatTextField('Event Title', eventTitle),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                        decoration:
                            const BoxDecoration(color: kPrimaryLightColor),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('data'),
                        )),
                  )
                ],
              ),
              const SizedBox(height: defaultPadding),
              nextButton(context, () {}, 'Add Event')
            ],
          ),
        ),
      ))),
    );
  }
}
