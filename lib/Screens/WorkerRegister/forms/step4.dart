// ignore_for_file: camel_case_types, library_private_types_in_public_api, non_constant_identifier_names, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:image_picker/image_picker.dart';

class fourthStep extends StatefulWidget {
  const fourthStep({Key? key}) : super(key: key);

  @override
  _fourthStepState createState() => _fourthStepState();
}

class _fourthStepState extends State<fourthStep> {
  TextEditingController tinID = TextEditingController();
  XFile? image;
  final ImagePicker picker = ImagePicker();
  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: defaultPadding),
      const Text(
        "Goverment IDs",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: defaultPadding),
      AttachImage(context, "Attach Government ID*"),
      const SizedBox(height: defaultPadding),
      AttachImage(context, "Attach Vaccination Card*"),
      const SizedBox(height: defaultPadding),
      AttachImage(context, "Attach NBI Clearance*"),
      const SizedBox(height: defaultPadding),
      flatTextField("TIN ID", tinID),
      const SizedBox(height: defaultPadding),
      const Text(
        "Certificates\nYou may add multiple images",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const addCertificate(),
      Column(
        children: widgets,
      ),
      const SizedBox(height: defaultPadding),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                widgets.add(const addCertificate());
              });
            },
            child: const Text("Add More+"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                try {
                  widgets != 0 ? widgets.removeLast() : null;
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cannot delete fields')));
                }
              });
            },
            child: const Text("Delete Section"),
          ),
        ],
      ),
    ]);
  }

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

class addCertificate extends StatefulWidget {
  const addCertificate({Key? key}) : super(key: key);

  @override
  State<addCertificate> createState() => _addCertificateState();
}

class _addCertificateState extends State<addCertificate> {
  TextEditingController tinID = TextEditingController();
  XFile? image;
  final ImagePicker picker = ImagePicker();
  late List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            const SizedBox(height: defaultPadding),
            AttachImage(context, "Attach Certificate"),
          ],
        ),
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

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }
}
