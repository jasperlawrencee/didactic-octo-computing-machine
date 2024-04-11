import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/widgets.dart';

final db = FirebaseFirestore.instance;

class SalonDocs {
  final String outsideSalon;
  final String insideSalon;
  final String businessPermit;
  final String secondLicense;

  SalonDocs(
      {required this.outsideSalon,
      required this.insideSalon,
      required this.businessPermit,
      required this.secondLicense});
}

class SalonIDs extends StatefulWidget {
  final String currentID;
  const SalonIDs({super.key, required this.currentID});

  @override
  State<SalonIDs> createState() => _SalonIDsState();
}

class _SalonIDsState extends State<SalonIDs> {
  Future<SalonDocs> getSalonDocs() async {
    final DocumentSnapshot<Map<String, dynamic>> salonDocs = await db
        .collection('users')
        .doc(widget.currentID)
        .collection('portfolio')
        .doc('requirements')
        .get();

    return SalonDocs(
        outsideSalon: salonDocs.get('outsideSalon'),
        insideSalon: salonDocs.get('insideSalon'),
        businessPermit: salonDocs.get('businessPermit'),
        secondLicense: salonDocs.get('secondaryLicense'));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSalonDocs(),
        builder: (context, AsyncSnapshot<SalonDocs> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Loading...'));
          } else {
            final salonDoc = snapshot.data!;
            return Expanded(
                child: Container(
              padding: EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  adminHeading('Salon Images'),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: adminImageContainer(
                              'Outside Picture', salonDoc.outsideSalon)),
                      Expanded(
                          child: adminImageContainer(
                              'Inside Picture', salonDoc.insideSalon))
                    ],
                  )
                ],
              ),
            ));
          }
        });
  }
}
