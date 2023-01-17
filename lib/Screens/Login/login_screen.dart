import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/home_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

import '../../components/background.dart';
import 'components/login_screen_top_image.dart';
import 'package:flutter_auth/components/widgets.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                flex: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 450,
                        child: Column(
                          children: <Widget>[
                            textField("Your email", Icons.person, false,
                                _emailTextController),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            textField("Your password", Icons.lock, true,
                                _passwordTextController),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Sign Up".toUpperCase()),
                            ),
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
                                      return SignUpScreen();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const LoginScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
                flex: 8,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 450,
                      child: textField("Your email", Icons.person, false,
                          _emailTextController),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField("Your password", Icons.lock, true,
                        _passwordTextController),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    SignInSignUp(context, true, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeScreen();
                      }));
                    }),
                    AlreadyHaveAnAccountCheck(
                      login: true,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                )),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
