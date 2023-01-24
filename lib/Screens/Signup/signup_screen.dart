// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/CustomerHome/home_screen.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Register/register_screen1.dart';
import 'package:flutter_auth/Screens/Register/toRegister.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';
import '../../components/background.dart';
import 'components/sign_up_top_image.dart';
import 'components/socal_sign_up.dart';

class SignUpScreen extends StatelessWidget {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileSignupScreen(),
          desktop: Row(
            children: [
              Expanded(
                child: SignUpScreenTopImage(),
              ),
              Expanded(
                child: Column(
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
                          AlreadyHaveAnAccountCheck(
                            login: false,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // SocalSignUp()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  MobileSignupScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SignUpScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 450,
                    child: Column(
                      children: <Widget>[
                        textField("Your username", Icons.person, false,
                            _emailTextController),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        textField("Your password", Icons.lock, true,
                            _passwordTextController),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        SignInSignUp(context, false, () {
                          // FirebaseAuth.instance
                          //     .createUserWithEmailAndPassword(
                          //         email: _emailTextController.text,
                          //         password: _passwordTextController.text)
                          //     .then(
                          //   (value) {
                          //     print("Created New Account");
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => HomeScreen()));
                          //   },
                          // ).onError(((error, stackTrace) {
                          //   print("Error ${error.toString()}");
                          // }));
                        }),
                        AlreadyHaveAnAccountCheck(
                          login: false,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen();
                                },
                              ),
                            );
                          },
                        ),
                        ToRegister(press: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return RegisterScreen();
                          })));
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
        // const SocalSignUp()
      ],
    );
  }
}
