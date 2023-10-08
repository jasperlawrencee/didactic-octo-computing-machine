// ignore_for_file: camel_case_types, library_private_types_in_public_api, non_constant_identifier_names, unrelated_type_equality_checks, must_be_immutable, unnecessary_nullable_for_final_variable_declarations

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';
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
  final ImagePicker picker = ImagePicker();
  List<XFile>? certificates = [];
  XFile? govIDRef;
  File? govID;
  XFile? vaxCardRef;
  File? vaxCard;
  XFile? nbiClearanceRef;
  File? nbiClearance;

  @override
  Widget build(BuildContext context) {
    tinID.addListener(
      () {
        workerForm.tinID = tinID.text;
      },
    );

    return Column(children: [
      const Text(
        "Goverment IDs",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: defaultPadding),
      AttachGovernmentID(context, 'Attach Government ID'),
      const SizedBox(height: defaultPadding),
      ShowImage(context, govIDRef, govID),
      const SizedBox(height: defaultPadding),
      AttachVaxCard(context, 'Attach Vaccination Certificate/Card'),
      const SizedBox(height: defaultPadding),
      ShowImage(context, vaxCardRef, vaxCard),
      const SizedBox(height: defaultPadding),
      AttachNBIClearance(context, 'Attach NBI Clearance'),
      const SizedBox(height: defaultPadding),
      ShowImage(context, nbiClearanceRef, nbiClearance),
      const SizedBox(height: defaultPadding),
      flatTextField("TIN ID", tinID),
      const SizedBox(height: defaultPadding),
      const Text(
        "Certificates\nYou may add multiple images",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: defaultPadding),
      AttachCertificatesButton(context),
      const SizedBox(height: defaultPadding),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // ClearCertificates(),
          ViewCertificates(context),
        ],
      )
    ]);
  }

  InkWell ClearCertificates() {
    return InkWell(
      onTap: () {
        if (certificates!.isNotEmpty) {
          setState(() {
            certificates = null;
          });
        }
      },
      child: const Text(
        'Clear',
        style:
            TextStyle(color: Colors.red, decoration: TextDecoration.underline),
        textAlign: TextAlign.center,
      ),
    );
  }

  InkWell ViewCertificates(BuildContext context) {
    return InkWell(
      onTap: () {
        certificates!.isNotEmpty
            ? showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width / 1,
                      height: MediaQuery.of(context).size.height / 1,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: certificates!.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Image.file(File(certificates![index].path)),
                                Container(height: 1),
                              ],
                            );
                          }),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'))
                    ],
                  );
                })
            : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'No image(s) provided',
                ),
                action: SnackBarAction(label: 'Close', onPressed: () {}),
              ));
      },
      child: certificates!.isNotEmpty || certificates != null
          ? const Text(
              'View Images',
              style: TextStyle(
                  color: kPrimaryColor, decoration: TextDecoration.underline),
              textAlign: TextAlign.center,
            )
          : const Text(
              'Please provide image(s)',
              style: TextStyle(
                  color: kPrimaryColor, decoration: TextDecoration.underline),
              textAlign: TextAlign.center,
            ),
    );
  }

  Container AttachCertificatesButton(BuildContext context) {
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
            AttachCertificates();
          },
          child: const Text(
            'Attach Certificates',
            style: TextStyle(color: Colors.black),
          )),
    );
  }

  AttachCertificates() async {
    final List<XFile>? selectedImages = await picker.pickMultipleMedia();
    if (selectedImages != null) {
      certificates!.addAll(selectedImages);
      try {
        setState(() {
          workerForm.certificates = certificates;
        });
      } catch (e) {
        log(e.toString());
      }
    }
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

  Container AttachGovernmentID(BuildContext context, String label) {
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
            PickImageGovernmentID(context);
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }

  Future<dynamic> PickImageGovernmentID(
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
                        GovernmentID(ImageSource.gallery);
                      },
                      child: const Row(
                        children: [Icon(Icons.image), Text('From Gallery')],
                      )),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                      onPressed: () async {
                        GovernmentID(ImageSource.camera);
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

  GovernmentID(ImageSource media) async {
    Navigator.of(context).pop();
    govIDRef = await picker.pickImage(source: media);
    try {
      setState(() {
        govID = File(govIDRef!.path);
        workerForm.governmentID = File(govIDRef!.path);
      });
    } catch (e) {
      log('${e.toString()} in');
    }
  }

  Container AttachVaxCard(BuildContext context, String label) {
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
            PickImageVaxCard(context);
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }

  Future<dynamic> PickImageVaxCard(
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
                        VaxCard(ImageSource.gallery);
                      },
                      child: const Row(
                        children: [Icon(Icons.image), Text('From Gallery')],
                      )),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                      onPressed: () async {
                        VaxCard(ImageSource.camera);
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

  VaxCard(ImageSource media) async {
    Navigator.of(context).pop();
    vaxCardRef = await picker.pickImage(source: media);
    try {
      setState(() {
        vaxCard = File(vaxCardRef!.path);
        workerForm.vaxCard = File(vaxCardRef!.path);
      });
    } catch (e) {
      log('${e.toString()} in');
    }
  }

  Container AttachNBIClearance(BuildContext context, String label) {
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
            PickImageNBIClearance(context);
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }

  Future<dynamic> PickImageNBIClearance(
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
                        NBIClearance(ImageSource.gallery);
                      },
                      child: const Row(
                        children: [Icon(Icons.image), Text('From Gallery')],
                      )),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                      onPressed: () async {
                        NBIClearance(ImageSource.camera);
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

  NBIClearance(ImageSource media) async {
    Navigator.of(context).pop();
    nbiClearanceRef = await picker.pickImage(source: media);
    try {
      setState(() {
        nbiClearance = File(nbiClearanceRef!.path);
        workerForm.nbiClearance = File(nbiClearanceRef!.path);
      });
    } catch (e) {
      log('${e.toString()} in');
    }
  }
}
