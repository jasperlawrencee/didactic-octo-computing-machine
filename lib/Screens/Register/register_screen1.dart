import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Register/bioData2.dart';
import 'package:flutter_auth/Screens/Signup/components/sign_up_top_image.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _ExpTextController = TextEditingController();
  TextEditingController _nbiTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileRegisterScreen(),
          desktop: Row(
            children: [
              SizedBox(
                width: 450,
                child: Column(
                  children: [
                    const Text("ACCOUNT INFORMATION"),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField(
                        "Username", Icons.person, false, _nameTextController),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField(
                        "Email", Icons.email, false, _emailTextController),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField(
                        "Password", Icons.lock, true, _passwordTextController),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField("Confirm Password", Icons.check, true,
                        _passwordTextController),
                    nextButton(context, () {}, "Next")
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

class MobileRegisterScreen extends StatelessWidget {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _ExpTextController = TextEditingController();
  TextEditingController _nbiTextController = TextEditingController();
  final items = ['Hair', 'Makeup', 'Spa', 'Nails', 'Lashes'];
  String? value;

  MobileRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Column(children: <Widget>[
                SizedBox(
                  width: 450,
                  child: Column(
                    children: <Widget>[
                      const Text("ACCOUNT INFORMATION"),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField(
                          "Username", Icons.person, false, _nameTextController),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField(
                          "Email", Icons.email, false, _emailTextController),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField("Password", Icons.lock, true,
                          _passwordTextController),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField("Confirm Password", Icons.check, true,
                          _passwordTextController),
                      nextButton(context, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return BioData();
                        })));
                      }, "Next"),
                      backButton(context, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return SignUpScreen();
                        })));
                      }, "Back")
                    ],
                  ),
                )
              ]),
            ),
            const Spacer()
          ],
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}
