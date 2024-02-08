import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

import 'package:badges/badges.dart' as badges;
import 'package:flutter_auth/features/firebase/firebase_services.dart';

class DisplayCertificates extends StatefulWidget {
  const DisplayCertificates({Key? key}) : super(key: key);

  @override
  State<DisplayCertificates> createState() => _DisplayCertificatesState();
}

class _DisplayCertificatesState extends State<DisplayCertificates> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  Iterable imageUrls = [];

  @override
  void initState() {
    super.initState();
    getUserCertificates();
  }

  void deleteCertificate(var image) async {
    try {
      log(image);
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('portfolio')
          .doc('requirements')
          .get();
      if (documentSnapshot.exists) {
        // final delete = <String, dynamic>{image: FieldValue.delete()};
        // documentSnapshot.reference.delete();
      }
    } catch (e) {
      log(e.toString());
    }
  }

// function for getting imageurls in subcollection
// this returns the list of urls sulod sa 'certificates' na field
  void getUserCertificates() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('portfolio')
          .doc('requirements')
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        Map<String, dynamic> certificates = Map.fromEntries(data.entries
            .where((element) => element.key.contains("certificates")));
        Iterable certUrls = certificates.values;
        setState(() {
          imageUrls = certUrls;
        });
      } else {
        log('document not exist');
      }
    } catch (e) {
      log('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Background(
          child: Container(
        margin: const EdgeInsets.fromLTRB(20, 35, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: kPrimaryColor,
                  ),
                ),
                Text(
                  'Certificates'.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kPrimaryColor,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.add,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Expanded(
                child: ListView(
              children: imageUrls.map((url) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(),
                  showBadge: true,
                  onTap: () {
                    deleteCertificate(url.toString());
                  },
                  badgeContent: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                  child: Image.network(url),
                );
              }).toList(),
            )),
          ],
        ),
      )),
    ));
  }
}
