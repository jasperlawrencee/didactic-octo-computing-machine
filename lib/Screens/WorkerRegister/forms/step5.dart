// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/user_auth/firebase_auth.dart';

class fifthStep extends StatefulWidget {
  const fifthStep({Key? key}) : super(key: key);

  @override
  _fifthStepState createState() => _fifthStepState();
}

class _fifthStepState extends State<fifthStep> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Account Information"),
        const SizedBox(height: defaultPadding),
        flatTextField("Email", email),
        flatTextField("Password", password),
      ],
    );
  }

  void signUp() async {
    String _email = email.text;
    String _password = password.text;

    User? user = await _auth.signUpWithEmailAndPassword(_email, _password);

    if (user != null) {
      print("User Created");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const WelcomeScreen();
      }));
    } else {
      print("error has occured");
    }
  }
}
