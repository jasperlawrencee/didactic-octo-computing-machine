// ignore_for_file: camel_case_types, library_private_types_in_public_api, non_constant_identifier_names, use_build_context_synchronously

import 'dart:developer';
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
  File? businessPermit;
  XFile? businessPermitRef;
  File? secondary;
  XFile? secondaryRef;
  File? salonOutside;
  XFile? salonOutsideRef;
  File? salonInside;
  XFile? salonInsideRef;
  bool isBusinessAdded = false;
  bool isSecondaryAdded = false;
  bool isOutsideAdded = false;
  bool isInsideAdded = false;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Salon Permits",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        AttachImage(context, "Business Permit +"),
        const SizedBox(height: defaultPadding),
        InkWell(
            onTap: () {
              if (businessPermitRef != null) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.file(businessPermit!),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'))
                        ],
                      );
                    });
              } else {
                log('$businessPermit $businessPermitRef $isBusinessAdded');
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
            )),
        const SizedBox(height: defaultPadding),
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
          onPressed: () {
            PickImageDialog(context, businessPermitRef, businessPermit);
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }

  Future<dynamic> PickImageDialog(
      BuildContext context, XFile? imageRef, File? image) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        tryMethod(businessPermitRef, businessPermit);
                      },
                      child: const Row(
                        children: [Icon(Icons.image), Text('From Gallery')],
                      )),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        imageRef =
                            await picker.pickImage(source: ImageSource.camera);
                        try {
                          setState(() {
                            image = File(imageRef!.path);
                            log("${imageRef!.name} 1");
                          });
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      child: const Row(
                        children: [Icon(Icons.camera), Text('From Camera')],
                      )),
                  TextButton(
                      onPressed: () {
                        log(imageRef!.name);
                      },
                      child: Text('data'))
                ],
              ),
            ),
          );
        });
  }

  tryMethod(XFile? imageReference, File? image) async {
    Navigator.of(context).pop();
    imageReference = await picker.pickImage(source: ImageSource.gallery);
    try {
      setState(() {
        image = File(imageReference!.path);
        log("${imageReference.name} 2");
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
