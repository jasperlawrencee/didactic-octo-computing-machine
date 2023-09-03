// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/Verification/verification_page.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/Screens/logout_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/user_auth/firebase_auth.dart';

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
                                  print("email and password clear");
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const SignupScreen();
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

  void _login() async {
    String email = _email.text;
    String password = _password.text;

    User? user = await _authService.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("User Logged In");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Verification();
      }));
    } else {
      print("email: " + email);
      print("password: " + password);
    }
  }
}
