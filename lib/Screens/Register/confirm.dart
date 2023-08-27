import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerHome/worker_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class ConfirmScreen extends StatelessWidget {
  final TextEditingController placeholder = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileConfirmScreen(),
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
                    textField("Username", Icons.person, false, placeholder),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField("Email", Icons.email, false, placeholder),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField("Password", Icons.lock, true, placeholder),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField(
                        "Confirm Password", Icons.check, true, placeholder),
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

class MobileConfirmScreen extends StatelessWidget {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _ExpTextController = TextEditingController();
  TextEditingController _nbiTextController = TextEditingController();
  String? value;

  MobileConfirmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Spacer(),
            Expanded(
                flex: 8,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Thank you for registering! \nKindly confirm your email address to complete the registration",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    nextButton(context, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return WorkerScreen();
                      }));
                    }, "Proceed to Home")
                  ],
                )),
            Spacer(),
          ],
        )
      ],
    );
  }
}
