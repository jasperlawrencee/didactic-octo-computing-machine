// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/SalonRegister/register_screen.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';
import '../../components/background.dart';
import 'components/sign_up_top_image.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
            mobile: const MobileSignupScreen(), desktop: Container()),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SignUpScreenTopImage(),
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
                        AlreadyHaveAnAccountCheck(
                          login: false,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const LoginScreen();
                                },
                              ),
                            );
                          },
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
