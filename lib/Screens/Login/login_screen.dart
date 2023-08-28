// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
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

class MobileLoginScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  MobileLoginScreen({Key? key}) : super(key: key);

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
                child: Column(
                  children: <Widget>[
                    textField(
                      "Your Username",
                      Icons.person,
                      false,
                      usernameController,
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField(
                      "Your Password",
                      Icons.lock,
                      true,
                      passwordController,
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    SignInSignUp(context, true, () {
                      usernameController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty
                          ? loginUser()
                          : const AlertDialog(
                              content:
                                  Text("Please write username and password"),
                            );
                    }),
                    AlreadyHaveAnAccountCheck(
                      login: true,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SignUpScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                )),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  void loginUser() async {
    const AlertDialog(
      content: Text("Authenticating, Please Wait..."),
    );
  }
}
