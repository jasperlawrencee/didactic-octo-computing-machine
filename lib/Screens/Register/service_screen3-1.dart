import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Register/certificates4.dart';
import 'package:flutter_auth/Screens/Register/requirements5.dart';
import 'package:flutter_auth/Screens/Register/service_screen3.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class Experience extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
        child: SingleChildScrollView(
      child: Responsive(mobile: MobileExperience(), desktop: Row()),
    ));
  }
}

class MobileExperience extends StatefulWidget {
  @override
  _MobileExperienceState createState() => _MobileExperienceState();
}

class _MobileExperienceState extends State<MobileExperience> {
  final TextEditingController placeholder = TextEditingController();

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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 450,
                      child: Column(
                        children: <Widget>[
                          const Text("Experiences"),
                          textField(
                            "Additional Experiences",
                            Icons.room_service_rounded,
                            false,
                            placeholder,
                          ),
                          SizedBox(
                            height: defaultPadding,
                          ),
                          textField(
                            "Period of Experiences",
                            Icons.room_service_rounded,
                            false,
                            placeholder,
                          ),
                          nextButton(context, () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Certificates();
                            }));
                          }, "Next"),
                          backButton(context, () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ServiceScreen();
                            }));
                          }, "Back")
                        ],
                      ),
                    )
                  ],
                )),
            const Spacer()
          ],
        )
      ],
    );
  }
}
