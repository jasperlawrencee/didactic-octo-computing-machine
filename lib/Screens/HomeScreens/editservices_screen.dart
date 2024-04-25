import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditServices extends StatefulWidget {
  String serviceType;
  String serviceName;
  String? price;
  String? description;
  String? duration;

  EditServices({
    super.key,
    required this.serviceType,
    required this.serviceName,
    this.price,
    this.description,
    this.duration,
  });

  @override
  State<EditServices> createState() => _EditServicesState();
}

List<String> hrMin = <String>['hr', 'min'];
List<String> hrs = List.generate(24, (index) => (index + 1).toString());
List<String> mins = List.generate(60, (index) => (index + 1).toString());

class _EditServicesState extends State<EditServices> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String type = hrMin.first;
  String timeOftype = '1';
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();
  File? profileImage;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> timeList = type == 'hr'
        ? hrs.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList()
        : mins.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList();
    return SafeArea(
        child: Background(
            child: Container(
      margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Column(
        children: [
          Text(
            "Edit Service".toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: kPrimaryColor,
            ),
          ),
          Text("${widget.serviceType} - ${widget.serviceName}"),
          const SizedBox(height: defaultPadding),
          // flatTextField('Description', _descriptionController),
          TextFormField(
            controller: _descriptionController,
            maxLength: 25,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
          ),
          const SizedBox(height: defaultPadding),
          flatTextField('Price', _priceController, istext: false),
          const SizedBox(height: defaultPadding),
          durationDropdowns(timeList),
          const SizedBox(height: defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    if (mounted) {
                      _priceController.clear();
                      _descriptionController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('BACK')),
              TextButton(
                  onPressed: () {
                    editServiceDetails(
                            widget.serviceType, //servicetype
                            widget.serviceName, //servicename
                            _priceController.text, //price
                            "$timeOftype $type", //duration
                            _descriptionController.text //description
                            )
                        .then((value) {
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                      setState(() {});
                    });
                  },
                  child: const Text('EDIT')),
            ],
          ),
        ],
      ),
    )));
  }

  Container durationDropdowns(List<DropdownMenuItem<String>> timeList) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Duration'),
          Row(
            children: [
              DropdownButton(
                value: timeOftype,
                items: timeList,
                onChanged: (String? newVale) {
                  setState(() {
                    timeOftype = newVale!;
                  });
                },
              ),
              const SizedBox(width: defaultPadding),
              DropdownButton<String>(
                value: type,
                onChanged: ((String? newValue) {
                  setState(() {
                    type = newValue!;
                  });
                }),
                items: hrMin.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> editServiceDetails(
    String serviceType,
    String serviceName,
    String price,
    String duration,
    String description,
  ) async {
    try {
      DocumentReference docRef = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('services')
          .doc(serviceType)
          .collection('${currentUser!.uid}services')
          .doc(serviceName);
      if (price.isNotEmpty || duration.isNotEmpty || description.isNotEmpty) {
        price.isNotEmpty
            ? await docRef.update({'price': price})
            : log('empty price');
        duration.isNotEmpty
            ? await docRef.update({'duration': duration})
            : log('empty duration');
        description.isNotEmpty
            ? await docRef.update({'description': description})
            : log('empty description');
        log('updated service');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Empty Fields'),
          action: SnackBarAction(label: 'Close', onPressed: () {}),
        ));
      }
    } catch (e) {
      log('Error in editing service details - ${e.toString()}');
    }
  }

  Future addServiceImage(String serviceType, String serviceName) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(img, serviceType, serviceName);
      setState(() => profileImage = img);
    } on PlatformException catch (e) {
      log(e.toString());
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future cropImage(File imgFile, String serviceType, String serviceName) async {
    try {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      );
      if (croppedImage == null) {
        return null;
      } else {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child('salonImage')
            .child(currentUser!.uid)
            .child('serviceImages')
            .child(serviceName);
        await reference.putFile(File(croppedImage.path));
        final serviceImage = await reference.getDownloadURL();
        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .collection('services')
            .doc(serviceType)
            .collection('${currentUser!.uid}services')
            .doc(serviceName)
            .update({'image': serviceImage}).then((value) {
          log('added $serviceName image');
        });
        return File(croppedImage.path);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
