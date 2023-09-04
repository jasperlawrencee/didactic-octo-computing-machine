// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/sign_up_top_image.dart';
import 'package:flutter_auth/Screens/logout_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/user_auth/firebase_auth.dart';
import 'package:flutter_auth/responsive.dart';

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
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                          "Email Address",
                          Icons.person,
                          false,
                          _email,
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        textField(
                          "Password",
                          Icons.lock,
                          false,
                          _password,
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
                                  print("email and password filled up dady");
                                  log("${_email.text} ${_password.text}");
                                  _signup();
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
                  )),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  void _signup() async {
    String email = _email.text;
    String password = _password.text;

    User? user = await _authService.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      print("User Successfuly Created");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const LogoutScreen();
      }));
    } else {
      print("email: $email");
      print("password: $password");
    }
  }
}
