import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Register/bioData2.dart';
import 'package:flutter_auth/Screens/Register/service_screen3.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class Address extends StatelessWidget {
  final TextEditingController placeholder = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileAddress(),
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
                    textField(
                      "Full Name",
                      Icons.person,
                      false,
                      placeholder,
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField(
                      "Address",
                      Icons.location_city,
                      false,
                      placeholder,
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    textField(
                      "Phone Number",
                      Icons.phone,
                      false,
                      placeholder,
                    ),
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

class MobileAddress extends StatefulWidget {
  @override
  _MobileAddressState createState() => _MobileAddressState();
}

class _MobileAddressState extends State<MobileAddress> {
  final items = ['item 1', 'item 2', 'item 3'];
  final gender = ['Male', 'Female', 'Non-binary'];
  final TextEditingController placeholder = TextEditingController();
  FilePickerResult? result;
  String? _fileName;
  String? city;
  String? barangay;
  String? value;
  PlatformFile? pickedfile;
  bool isLoading = false;
  // File? fileToDisplay;

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
                      Text("City"),
                      Container(
                        decoration: BoxDecoration(
                            // border: Border.all(color: kPrimaryColor),
                            borderRadius: BorderRadius.circular(90),
                            color: kPrimaryLightColor),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text("  City"),
                            value: city,
                            items: items.map(buildMenuItem).toList(),
                            onChanged: (value) =>
                                setState(() => this.city = value),
                            isExpanded: true,
                            iconSize: 36,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                      Text("Barangay"),
                      Container(
                        decoration: BoxDecoration(
                            // border: Border.all(color: kPrimaryColor),
                            borderRadius: BorderRadius.circular(90),
                            color: kPrimaryLightColor),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text("  Barangay"),
                            value: barangay,
                            items: items.map(buildMenuItem).toList(),
                            onChanged: (value) =>
                                setState(() => this.barangay = value),
                            isExpanded: true,
                            iconSize: 36,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                      const Text("ADDRESS"),
                      textField(
                        "Street Address",
                        Icons.location_city,
                        false,
                        placeholder,
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField(
                        "Extended Address",
                        Icons.location_city,
                        false,
                        placeholder,
                      ),
                      nextButton(context, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ServiceScreen();
                        }));
                      }, "Next"),
                      backButton(context, () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return BioData();
                          },
                        ));
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
        child: Text(item,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      );
}
