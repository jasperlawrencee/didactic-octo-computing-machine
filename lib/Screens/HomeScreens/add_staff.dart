import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Container(
      margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Add staff".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: defaultPadding),
              flatTextField('Name', nameController),
              const SizedBox(height: defaultPadding),
              flatTextField('Role', roleController),
              const SizedBox(height: defaultPadding),
              flatTextField('Contact Number', contactController),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                  onPressed: addStaffToFirestore,
                  child: const Text(
                    'Add',
                    style: TextStyle(color: kPrimaryLightColor),
                  )),
              const SizedBox(height: defaultPadding),
            ],
          )
        ],
      ),
    ));
  }

  Future<void> addStaffToFirestore() async {
    try {
      if (nameController.text.isNotEmpty &&
          roleController.text.isNotEmpty &&
          contactController.text.isNotEmpty) {
        //add to firestore
        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .collection('staff')
            .add({
          'name': nameController.text,
          'role': roleController.text,
          'contact': contactController.text,
        });
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Incomplete Forms')));
      }
    } catch (e) {
      log('error adding to firestore $e');
    }
  }
}
