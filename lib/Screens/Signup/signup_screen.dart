// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/sign_up_top_image.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/worker_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_logout.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/firebase/firebase_services.dart';

import '../../components/background.dart';
import 'package:flutter_auth/components/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseService _authService = FirebaseService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _username = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: SingleChildScrollView(
            reverse: true,
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
                const SignUpScreenTopImage(),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                        flex: 8,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              textField(
                                "Username",
                                Icons.person,
                                false,
                                _username,
                                emailType: false,
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              textField(
                                "Email Address",
                                Icons.mail,
                                false,
                                _email,
                                emailType: RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(_email.text),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
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
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90)),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        log("${_email.text} ${_password.text}");
                                        _signup(_email.text, _password.text);
                                      }
                                    },
                                    child: isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ))
                                        : const Text(
                                            'SIGN UP',
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
                                login: false,
                                press: () {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return const LoginScreen();
                                    },
                                  ), (route) => route.isFirst);
                                },
                              ),
                              const SizedBox(height: defaultPadding),
                            ],
                          ),
                        )),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // kulang og snackbar if invalid login
  void _signup(String email, String password) async {
    try {
      String email = _email.text;
      String password = _password.text;

      User? user =
          await _authService.signUpWithEmailAndPassword(email, password);

      //add email and username to firestore
      postEmailToFireStore();

      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const SignupLogout();
        }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email or Username already exists')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  postEmailToFireStore() {
    try {
      var user = FirebaseAuth.instance.currentUser;
      CollectionReference ref = FirebaseFirestore.instance.collection('users');
      ref
          .doc(user!.uid)
          .set({'email': _email.text, 'username': _username.text});
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WorkerScreen()));
    } catch (e) {
      log(e.toString());
    }
  }
}
