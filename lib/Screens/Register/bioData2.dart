import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Register/bioData2-1.dart';
import 'package:flutter_auth/Screens/Register/register_screen1.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class BioData extends StatelessWidget {
  final TextEditingController placeholder = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileBioData(),
          desktop: Row(
            children: [
              SizedBox(
                width: 450,
                child: Column(
                  children: [
                    const Text("BIO DATA INFORMATION"),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField("Full Name", Icons.person, false, placeholder),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField(
                        "Address", Icons.location_city, false, placeholder),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField("Phone Number", Icons.phone, false, placeholder),
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

class MobileBioData extends StatefulWidget {
  @override
  _MobileBioDataState createState() => _MobileBioDataState();
}

class _MobileBioDataState extends State<MobileBioData> {
  final items = ['item 1', 'item 2', 'item 3'];
  final gender = ['Male', 'Female', 'Non-binary'];
  final TextEditingController placeholder = TextEditingController();
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
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
              child: Column(children: <Widget>[
                SizedBox(
                  width: 450,
                  child: Column(
                    children: <Widget>[
                      const Text("BIO DATA INFORMATION"),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField("First Name", Icons.person, false, placeholder),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField(
                          "Middle Name", Icons.person, false, placeholder),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField("Last Name", Icons.person, false, placeholder),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      // Text("Gender"),
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
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField(
                          "Phone Number 1", Icons.phone, false, placeholder),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField(
                          "Phone Number 2", Icons.phone, false, placeholder),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField(
                          "Phone Number 3", Icons.phone, false, placeholder),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      nextButton(context, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Address();
                        }));
                      }, "Next"),
                      backButton(context, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RegisterScreen();
                        }));
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
