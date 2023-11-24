import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class SignupLogout extends StatefulWidget {
  const SignupLogout({Key? key}) : super(key: key);

  @override
  State<SignupLogout> createState() => _SignupLogout();
}

class _SignupLogout extends State<SignupLogout> {
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
            'Thank you for Signing up!\nYou can now proceed to selecting which service provider you are by loggin in.',
            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const WelcomeScreen();
              }));
            },
            child: const Text("Back to Home Screen"),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    ));
  }
}
