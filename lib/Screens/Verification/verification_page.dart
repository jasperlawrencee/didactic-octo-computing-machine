// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/SalonRegister/register_stepper.dart';
import 'package:flutter_auth/Screens/Verification/components/verification_top_image.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_screen.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
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

class MobileVerification extends StatelessWidget {
  const MobileVerification({Key? key}) : super(key: key);
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const WorkerRegisterScreen();
                          }));
                        }, "REGISTER AS WORKER"),
                        nextButton(context, () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SalonRegisterScreen();
                          }));
                        }, "REGISTER AS STORE"),
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
