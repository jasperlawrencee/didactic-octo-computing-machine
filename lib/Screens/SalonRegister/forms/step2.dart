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
        AttachImage(
          context,
          "Business Permit +",
          businessPermit,
          businessPermitRef,
          isBusinessAdded,
        ),
        const SizedBox(height: defaultPadding),
        InkWell(
            onTap: () {
              if (businessPermitRef != null) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog();
                    });
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
            )),
        const SizedBox(height: defaultPadding),
        AttachImage(context, "Secondary License (BIR/Mayor's Permit) +",
            secondary, secondaryRef, isSecondaryAdded),
        const SizedBox(height: defaultPadding),
        const Text(
          "Place of Salon",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        AttachImage(context, "Salon Photo - Outside +", salonOutside,
            salonOutsideRef, isOutsideAdded),
        const SizedBox(height: defaultPadding),
        AttachImage(context, "Salon Photo - Inside +", salonInside,
            salonInsideRef, isInsideAdded),
        const SizedBox(height: defaultPadding),
      ],
    );
  }

  Future<String> getImage(
      ImageSource media, File? image, XFile? imageReference) async {
    var img = await picker.pickImage(source: media);

    imageReference = img!;
    image = File(imageReference.path);
    // setState(() {
    //   try {
    //   } catch (e) {
    //     isBusinessAdded = false;
    //   }
    //   isBusinessAdded = true;
    // });
    log(imageReference.name);
    return imageReference.name;
  }

  Container AttachImage(BuildContext context, String label, File? image,
      XFile? imageReference, bool isAdded) {
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
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Please choose media to select'),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                      child: Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop;
                                getImage(
                                    ImageSource.gallery, image, imageReference);
                                log(imageReference!.name);
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.image),
                                  Text('From Gallery')
                                ],
                              )),
                          const SizedBox(height: defaultPadding),
                          ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                try {
                                  imageReference = await picker.pickImage(
                                      source: ImageSource.camera);
                                  setState(() {
                                    if (imageReference != null) {
                                      image = File(imageReference!.path);
                                    }
                                    isAdded = true;
                                  });
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.camera),
                                  Text('From Camera')
                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }
}
