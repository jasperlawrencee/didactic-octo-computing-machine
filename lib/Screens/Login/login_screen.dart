// ignore_for_file: must_be_immutable, use_build_context_synchronously, unused_local_variable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/admin_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/salon_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/worker_screen.dart';
import 'package:flutter_auth/Screens/SalonRegister/verification.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/Verification/verification_page.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/Screens/WorkerRegister/verification.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/firebase/firebase_services.dart';
import '../../components/background.dart';
import 'components/login_screen_top_image.dart';
import 'package:flutter_auth/components/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseService _authService = FirebaseService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() async {
    String email = _email.text;
    String password = _password.text;
    try {
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        route();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sucessfully Logged In')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email or password invalid')));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // route constructor to salon or worker when logged in
  // verifies if user has finalized roles in 'verification' page at the same time
  route() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        try {
          dynamic nested = documentSnapshot.get(FieldPath(const ['role']));
          if (documentSnapshot.exists) {
            if (documentSnapshot.get('role') == 'freelancer' &&
                documentSnapshot.get('status') == 'verified') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const WorkerScreen();
              }));
            } else if (documentSnapshot.get('role') == 'salon' &&
                documentSnapshot.get('status') == 'verified') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const SalonScreen();
              }));
            } else if (documentSnapshot.get('role') == 'admin') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AdminScreen();
              }));
            } else if (documentSnapshot.get('role') == 'freelancer' &&
                documentSnapshot.get('status') == 'unverified') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const WorkerSummaryScreen();
              }));
            } else if (documentSnapshot.get('role') == 'salon' &&
                documentSnapshot.get('status') == 'unverified') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SalonSummaryScreen();
              }));
            }
          }
        } on StateError {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Verification();
          }));
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login Error: Check email and password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              const SizedBox(width: defaultPadding),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ));
                },
                icon: const Icon(Icons.arrow_back),
                color: kPrimaryColor,
              ),
            ],
          ),
          const LoginScreenTopImage(),
          Row(
            children: [
              const Spacer(),
              Expanded(
                  flex: 8,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: defaultPadding),
                        textField(
                          "Email Address",
                          Icons.person,
                          false,
                          _email,
                          emailType: false,
                        ),
                        const SizedBox(height: defaultPadding),
                        textField(
                          "Password",
                          Icons.lock,
                          true,
                          _password,
                          emailType: false,
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        SizedBox(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90)),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  _login();
                                }
                              },
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ))
                                  : const Text(
                                      'LOG IN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        AlreadyHaveAnAccountCheck(
                          login: true,
                          press: () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return const SignupScreen();
                              },
                            ), (route) => route.isFirst);
                          },
                        ),
                      ],
                    ),
                  )),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
