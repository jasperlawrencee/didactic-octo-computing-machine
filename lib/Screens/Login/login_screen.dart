// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/Signup/verification_page.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

import '../../components/background.dart';
import 'components/login_screen_top_image.dart';
import 'package:flutter_auth/components/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(mobile: MobileLoginScreen(), desktop: Container()),
      ),
    );
  }
}

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({Key? key}) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  //firebase auth call function
  signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid or user not found"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (e.code == 'wrong-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong password"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  final snackbar = const SnackBar(
    content: Text("Logged In"),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        email,
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField(
                        "Password",
                        Icons.lock,
                        false,
                        password,
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
                                // signInWithEmailAndPassword();
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
                      // SignInSignUp(context, true, () {
                      //   if (formKey.currentState!.validate()) {
                      //     signInWithEmailAndPassword();
                      //   }
                      // }),
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
    );
  }
}
