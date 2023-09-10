import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    const Text(
                      'Thank you for Signing up!\nYou can now proceed to selecting which provider you are by loggin in',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginScreen();
                        }));
                      },
                      child: const Text("Back to Home Screen"),
                    )
                  ],
                ),
              ),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
