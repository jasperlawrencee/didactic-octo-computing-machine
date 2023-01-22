import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Register/requirements4.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class ServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
        child: SingleChildScrollView(
      child: Responsive(mobile: MobileServiceScreen(), desktop: Row()),
    ));
  }
}

class MobileServiceScreen extends StatelessWidget {
  TextEditingController _serviceTextController = TextEditingController();
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
                          const Text("SERVICE CATEGORY"),
                          checkBox(context, () {}, "Hair"),
                          SizedBox(height: defaultPadding),
                          checkBox(context, () {}, "Makeup"),
                          SizedBox(height: defaultPadding),
                          checkBox(context, () {}, "Spa"),
                          SizedBox(height: defaultPadding),
                          checkBox(context, () {}, "Nails"),
                          SizedBox(height: defaultPadding),
                          checkBox(context, () {}, "Lashes"),
                          SizedBox(height: defaultPadding),
                          checkBox(context, () {}, "Wax"),
                          SizedBox(height: defaultPadding),
                          const Text("OPTIONAL"),
                          textField(
                              "Additional Experiences",
                              Icons.room_service_rounded,
                              false,
                              _serviceTextController),
                          SizedBox(
                            height: defaultPadding,
                          ),
                          textField(
                              "Period of Experiences",
                              Icons.room_service_rounded,
                              false,
                              _serviceTextController),
                          nextButton(context, () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Requirements();
                            }));
                          }, "Next")
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
