import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Register/confirm.dart';
import 'package:flutter_auth/Screens/Register/requirements5.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
        child: SingleChildScrollView(
      child: Responsive(mobile: MobileSummary(), desktop: Row()),
    ));
  }
}

class MobileSummary extends StatefulWidget {
  @override
  _MobileSummaryState createState() => _MobileSummaryState();
}

class _MobileSummaryState extends State<MobileSummary> {
  final gender = ['Male', 'Female', 'Non-binary'];
  TextEditingController textController = TextEditingController();
  String? value;
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
                        const Text("Registration Summary"),
                        Text("Username"),
                        textField(
                            "Username", Icons.person, false, textController),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text("Email"),
                        textField("Email", Icons.person, false, textController),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text("Password"),
                        textField(
                            "Username", Icons.person, true, textController),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text("First Name"),
                        textField("", Icons.person, false, textController),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text("Middle Name"),
                        textField("", Icons.person, false, textController),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text("Last Name"),
                        textField("", Icons.person, false, textController),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text("Gender"),
                        Container(
                          decoration: BoxDecoration(
                              // border: Border.all(color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(90),
                              color: kPrimaryLightColor),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text("  Gender"),
                              value: value,
                              items: gender.map(buildMenuItem).toList(),
                              onChanged: (value) =>
                                  setState(() => this.value = value),
                              isExpanded: true,
                              iconSize: 36,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        textField(
                            "Phone Number", Icons.phone, false, textController),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        textField("City", Icons.home, false, textController),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        textField(
                            "Barangay", Icons.home, false, textController),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        textField("Street Address", Icons.home, false,
                            textController),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        textField("Extended Address", Icons.home, false,
                            textController),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        nextButton(context, () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ConfirmScreen();
                          }));
                        }, "Submit"),
                        backButton(context, () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return Requirements();
                          })));
                        }, "Back")
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer()
          ],
        )
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
