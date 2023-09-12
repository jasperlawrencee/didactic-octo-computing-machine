// ignore_for_file: library_private_types_in_public_api, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:image_picker/image_picker.dart';

class step1 extends StatefulWidget {
  const step1({Key? key}) : super(key: key);

  @override
  _step1State createState() => _step1State();
}

class _step1State extends State<step1> {
  TextEditingController salonName = TextEditingController();
  TextEditingController roomBuilding = TextEditingController();
  TextEditingController streetRoad = TextEditingController();
  TextEditingController barangay = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController salonOwner = TextEditingController();
  TextEditingController salonNumber = TextEditingController();
  TextEditingController salonRepresentative = TextEditingController();
  TextEditingController representativeEmail = TextEditingController();
  TextEditingController representativeNum = TextEditingController();
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  void imageAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.topRight,
          child: Text(
            "Required*",
            style: TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontFamily: 'Inter',
            ),
          ),
        ),
        const SizedBox(height: defaultPadding),
        const Text(
          "Salon Data",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        flatTextField("Salon Name*", salonName),
        const SizedBox(height: defaultPadding),
        const Text(
          "Salon Address",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flatTextField("Room No./Building*", roomBuilding),
        flatTextField("Street/Road*", streetRoad),
        flatTextField("Barangay*", barangay),
        flatTextField("City*", city),
        const SizedBox(height: defaultPadding),
        const Text(
          "Salon Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        flatTextField("Salon Owner Name*", salonOwner),
        flatTextField("Salon Contact Number*", salonNumber),
        flatTextField("Salon Representative Name*", salonRepresentative),
        flatTextField("Representative Email Address*", representativeEmail),
        flatTextField("Representative Contact Number*", representativeNum),
        const SizedBox(height: defaultPadding),
        AttachImage(context, "Attach Representative ID+"),
      ],
    );
  }

  Container AttachImage(BuildContext context, String label) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        color: kPrimaryLightColor,
      ),
      child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor,
            padding: const EdgeInsets.all(defaultPadding),
          ),
          onPressed: imageAlert,
          child: Text(
            label,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }
}
