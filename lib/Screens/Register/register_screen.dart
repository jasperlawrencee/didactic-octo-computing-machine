import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Signup/components/sign_up_top_image.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                  children: [],
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
              child: Column(children: <Widget>[
                SizedBox(
                  width: 450,
                  child: Column(
                    children: <Widget>[
                      textField(
                          "Full name", Icons.menu, false, _nameTextController),
                      const SizedBox(
                        height: defaultPadding,
                      ),
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
                      textField(
                          "NBI clearance",
                          Icons.add_photo_alternate_outlined,
                          false,
                          _nbiTextController),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField("Years of experience (Optional)",
                          Icons.timelapse, false, _ExpTextController),
                    ],
                  ),
                )
              ]),
            )
          ],
        )
      ],
    );
  }
}
