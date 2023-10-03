// ignore_for_file: camel_case_types, library_private_types_in_public_api, non_constant_identifier_names, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/SalonRegister/register_stepper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';

class step2 extends StatefulWidget {
  const step2({Key? key}) : super(key: key);

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
        AttachBusinessImage(context, "Business Permit +"),
        const SizedBox(height: defaultPadding),
        ShowImage(context, businessPermitRef, businessPermit),
        const SizedBox(height: defaultPadding),
        AttachSecondaryImage(
            context, "Secondary License (Mayor's Permit/BIR) +"),
        const SizedBox(height: defaultPadding),
        ShowImage(context, secondaryRef, secondary),
        const SizedBox(height: defaultPadding),
        const Text(
          "Salon Photos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        AttachOutSideImage(context, 'Salon Photo - Outside'),
        const SizedBox(height: defaultPadding),
        ShowImage(context, salonOutsideRef, salonOutside),
        const SizedBox(height: defaultPadding),
        AttachInsideImage(context, 'Salon Photo - Inside'),
        const SizedBox(height: defaultPadding),
        ShowImage(context, salonInsideRef, salonInside),
      ],
    );
  }

  InkWell ShowImage(BuildContext context, XFile? imageRef, File? image) {
    return InkWell(
        onTap: () {
          if (imageRef != null) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Image.file(image!),
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
            log('$businessPermit $businessPermitRef');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('No image provided'),
              action: SnackBarAction(label: 'Close', onPressed: () {}),
            ));
          }
        },
        child: Text(
          imageRef != null ? imageRef.name : 'Please provide an image',
          style: const TextStyle(
              color: kPrimaryColor, decoration: TextDecoration.underline),
          textAlign: TextAlign.center,
        ));
  }

  Container AttachBusinessImage(BuildContext context, String label) {
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
            PickImageBusiness(context);
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }

  Future<dynamic> PickImageBusiness(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        BusinessPermit(ImageSource.gallery);
                      },
                      child: const Row(
                        children: [Icon(Icons.image), Text('From Gallery')],
                      )),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                      onPressed: () async {
                        BusinessPermit(ImageSource.camera);
                      },
                      child: const Row(
                        children: [Icon(Icons.camera), Text('From Camera')],
                      )),
                ],
              ),
            ),
          );
        });
  }

  BusinessPermit(ImageSource media) async {
    Navigator.of(context).pop();
    businessPermitRef = await picker.pickImage(source: media);
    try {
      setState(() {
        businessPermit = File(businessPermitRef!.path);
        salonForm.businessPermit = File(businessPermitRef!.path);
      });
    } catch (e) {
      log('${e.toString()} in');
    }
  }

  Container AttachSecondaryImage(BuildContext context, String label) {
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
            PickImageSecondary(context);
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }

  Future<dynamic> PickImageSecondary(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        SecondaryPermit(ImageSource.gallery);
                      },
                      child: const Row(
                        children: [Icon(Icons.image), Text('From Gallery')],
                      )),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                      onPressed: () async {
                        SecondaryPermit(ImageSource.camera);
                      },
                      child: const Row(
                        children: [Icon(Icons.camera), Text('From Camera')],
                      )),
                ],
              ),
            ),
          );
        });
  }

  SecondaryPermit(ImageSource media) async {
    Navigator.of(context).pop();
    secondaryRef = await picker.pickImage(source: media);
    try {
      setState(() {
        secondary = File(secondaryRef!.path);
        salonForm.secondaryLicense = File(secondaryRef!.path);
      });
    } catch (e) {
      log('${e.toString()} in');
    }
  }

  Container AttachOutSideImage(BuildContext context, String label) {
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
            PickImageOutSide(context);
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }

  Future<dynamic> PickImageOutSide(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        OutSide(ImageSource.gallery);
                      },
                      child: const Row(
                        children: [Icon(Icons.image), Text('From Gallery')],
                      )),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                      onPressed: () async {
                        OutSide(ImageSource.camera);
                      },
                      child: const Row(
                        children: [Icon(Icons.camera), Text('From Camera')],
                      )),
                ],
              ),
            ),
          );
        });
  }

  OutSide(ImageSource media) async {
    Navigator.of(context).pop();
    salonOutsideRef = await picker.pickImage(source: media);
    try {
      setState(() {
        salonOutside = File(salonOutsideRef!.path);
        salonForm.outsideSalonPhoto = File(salonOutside!.path);
      });
    } catch (e) {
      log('${e.toString()} in');
    }
  }

  Container AttachInsideImage(BuildContext context, String label) {
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
            PickImageInside(context);
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }

  Future<dynamic> PickImageInside(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        Inside(ImageSource.gallery);
                      },
                      child: const Row(
                        children: [Icon(Icons.image), Text('From Gallery')],
                      )),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                      onPressed: () async {
                        Inside(ImageSource.camera);
                      },
                      child: const Row(
                        children: [Icon(Icons.camera), Text('From Camera')],
                      )),
                ],
              ),
            ),
          );
        });
  }

  Inside(ImageSource media) async {
    Navigator.of(context).pop();
    salonInsideRef = await picker.pickImage(source: media);
    try {
      setState(() {
        salonInside = File(salonInsideRef!.path);
        salonForm.insideSalonPhoto = File(salonInsideRef!.path);
      });
    } catch (e) {
      log('${e.toString()} in');
    }
  }
}
