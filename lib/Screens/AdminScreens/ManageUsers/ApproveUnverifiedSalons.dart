import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/Screens/AdminScreens/ManageUsers/IDs/SalonIDs.dart';
import 'package:flutter_auth/Screens/AdminScreens/ManageUsers/InfoTabs/SalonBasicInfo.dart';
import 'package:flutter_auth/constants.dart';

import 'Unverified.dart';
import 'Verified.dart';

class UnverifiedInfo extends StatefulWidget {
  final String currentID;
  final String role;

  const UnverifiedInfo(
      {super.key, required this.currentID, required this.role});

  @override
  State<UnverifiedInfo> createState() => _UnverifiedInfoState();
}

class _UnverifiedInfoState extends State<UnverifiedInfo> {
  Future<void> verifySalon() async {
    // Get a reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('users');

    // Update the specific field
    await collection.doc(widget.currentID).update({
      'status': 'verified', // Replace with the actual field name
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: true,
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 40),
              child: TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.deepPurple[300];
                      }
                      return kPrimaryColor;
                    }),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(kPrimaryLightColor),
                    iconColor:
                        MaterialStateProperty.all<Color>(kPrimaryLightColor),
                  ),
                  onPressed: verifySalon,
                  icon: Icon(Icons.check),
                  label: Text('Approve')),
            )
          ],
          title: Text(
            "Salon Information",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              indicatorColor: kPrimaryColor,
              tabs: [
                Tab(
                  text: 'Basic Information',
                ),
                Tab(
                  text: 'Documents',
                ),
                Tab(
                  text: 'Services Offered',
                )
              ]),
        ),
        body: TabBarView(
          children: [
            SalonBasicInfo(
              currentID: widget.currentID,
              role: widget.role,
            ),
            SalonIDs(currentID: widget.currentID),
            Center(
              child: Text('Services Offered'),
            ),
          ],
        ),
      ),
    );
  }
}
