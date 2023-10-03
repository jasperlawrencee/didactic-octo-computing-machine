// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/SalonRegister/register_stepper.dart';
import 'package:flutter_auth/Screens/Verification/components/verification_top_image.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/firebase/firebase_services.dart';
import 'package:flutter_auth/responsive.dart';
import '../../components/background.dart';

class Verification extends StatelessWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
            mobile: const MobileVerification(), desktop: Container()),
      ),
    );
  }
}

class MobileVerification extends StatefulWidget {
  const MobileVerification({Key? key}) : super(key: key);

  @override
  State<MobileVerification> createState() => _MobileVerificationState();
}

class _MobileVerificationState extends State<MobileVerification> {
  final FirebaseService firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const VerificationTopImage(),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 450,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        nextButton(context, () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Theme(
                                  data: ThemeData(
                                      canvasColor: Colors.transparent,
                                      colorScheme: Theme.of(context)
                                          .colorScheme
                                          .copyWith(
                                            primary: kPrimaryColor,
                                            background: Colors.white70,
                                            secondary: kPrimaryLightColor,
                                          )),
                                  child: AlertDialog(
                                    title: const Text(
                                        "Continue Registering as Worker?"),
                                    actions: <Widget>[
                                      TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("No")),
                                      TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const WorkerRegisterScreen();
                                            }));
                                          },
                                          child: const Text("Yes")),
                                    ],
                                  ),
                                );
                              });
                        }, "REGISTER AS WORKER"),
                        nextButton(context, () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Theme(
                                  data: ThemeData(
                                      canvasColor: Colors.transparent,
                                      colorScheme: Theme.of(context)
                                          .colorScheme
                                          .copyWith(
                                            primary: kPrimaryColor,
                                            background: Colors.white70,
                                            secondary: kPrimaryLightColor,
                                          )),
                                  child: AlertDialog(
                                    title: const Text(
                                        "Continue Registering as Salon?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("No")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return SalonRegisterScreen();
                                            }));
                                          },
                                          child: const Text("Yes")),
                                    ],
                                  ),
                                );
                              });
                        }, "REGISTER AS SALON"),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
