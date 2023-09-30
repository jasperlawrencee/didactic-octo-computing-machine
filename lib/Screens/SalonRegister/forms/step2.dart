// ignore_for_file: camel_case_types, library_private_types_in_public_api, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth/models/forms.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';

class step2 extends StatefulWidget {
  final SalonForm sForm;
  const step2({Key? key, required this.sForm}) : super(key: key);

  @override
  _step2State createState() => _step2State();
}

class _step2State extends State<step2> {
  final ImagePicker picker = ImagePicker();
  File? businessPermit;
  XFile? businessPermitRef;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Salon Permits",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        AttachImage(context, "Business Permit"),
        const SizedBox(height: defaultPadding),
        InkWell(
          onTap: () {
            if (businessPermit != null) {
              showDialog(
                  context: context,
                  builder: ((context) {
                    return Theme(
                      data: ThemeData(
                          canvasColor: Colors.transparent,
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                                primary: kPrimaryColor,
                                background: Colors.white70,
                                secondary: kPrimaryLightColor,
                              )),
                      child: AlertDialog(
                        content: Image.file(businessPermit!),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'))
                        ],
                      ),
                    );
                  }));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('No image provided'),
                action: SnackBarAction(label: 'Close', onPressed: () {}),
              ));
            }
          },
          child: Text(
            businessPermitRef != null
                ? businessPermitRef!.name
                : 'Please provide an image',
            style: const TextStyle(
                color: kPrimaryColor, decoration: TextDecoration.underline),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: defaultPadding),
        const SizedBox(height: defaultPadding),
        AttachImage(context, "Secondary License (BIR/Mayor's Permit)"),
        const SizedBox(height: defaultPadding),
        const Text(
          "Place of Salon",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        AttachImage(context, "Salon Photo - Outside"),
        const SizedBox(height: defaultPadding),
        AttachImage(context, "Salon Photo - Inside"),
        const SizedBox(height: defaultPadding),
      ],
    );
  }

  Future getImage(ImageSource media) async {
    final img = await picker.pickImage(source: media);

    setState(() {
      businessPermitRef = img;
      try {
        businessPermit = File(img!.path);
      } catch (e) {}
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
