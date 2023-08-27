import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Register/service_screen3-1.dart';
import 'package:flutter_auth/Screens/Register/summary.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class Requirements extends StatelessWidget {
  final TextEditingController placeholder = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileRequirements(),
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
                    nextButton(context, () {}, "Submit")
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

class MobileRequirements extends StatefulWidget {
  @override
  _MobileRequirementsState createState() => _MobileRequirementsState();
}

class _MobileRequirementsState extends State<MobileRequirements> {
  final TextEditingController placeholder = TextEditingController();
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        _fileName = result!.files.first.name;
        pickedfile = result!.files.first;
        fileToDisplay = File(pickedfile!.path.toString());
        print(_fileName);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

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
                      const Text("REQUIREMENTS NEEDED"),
                      addImage(context, "Attach Government ID"),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      addImage(context, "Attach Vaccination Certificate"),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      addImage(context, "Attach NBI Clearance"),
                      // if (pickedfile != null)
                      //   SizedBox(
                      //       height: 30,
                      //       width: 30,
                      //       child: Image.file(fileToDisplay!)),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      textField("TIN ID", Icons.pin, false, placeholder),
                      nextButton(context, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Summary();
                        }));
                      }, "Submit"),
                      backButton(context, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return Experience();
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
}
