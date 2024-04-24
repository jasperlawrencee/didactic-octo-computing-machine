import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/Screens/AdminScreens/ManageUsers/InfoTabs/FreelancerBasicInfo.dart';
import 'package:flutter_auth/Screens/AdminScreens/ManageUsers/ServicesOffered/GetClientServices.dart';
import 'package:flutter_auth/constants.dart';

class UnverifiedInfoFreelancers extends StatefulWidget {
  final String status;
  final String currentID;
  final String role;
  const UnverifiedInfoFreelancers(
      {super.key,
      required this.currentID,
      required this.role,
      required this.status});

  @override
  State<UnverifiedInfoFreelancers> createState() =>
      _UnverifiedInfoFreelancersState();
}

class _UnverifiedInfoFreelancersState extends State<UnverifiedInfoFreelancers> {
  Future<void> verifyFreelancer() async {
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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: true,
          actions: [
            widget.status == 'unverified'
                ? Padding(
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
                          foregroundColor: MaterialStateProperty.all<Color>(
                              kPrimaryLightColor),
                          iconColor: MaterialStateProperty.all<Color>(
                              kPrimaryLightColor),
                        ),
                        onPressed: verifyFreelancer,
                        icon: Icon(Icons.check),
                        label: Text('Approve')),
                  )
                : Padding(
                    padding: EdgeInsetsDirectional.only(end: 40),
                    child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.green[300];
                            }
                            return Colors.green[800];
                          }),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white54),
                          iconColor:
                              MaterialStateProperty.all<Color>(Colors.white54),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.check_circle_outline_outlined),
                        label: Text('Verified')),
                  )
          ],
          title: Text(
            "Freelancer Information",
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
                  text: 'Portfolio',
                ),
                Tab(
                  text: 'Services Offered',
                )
              ]),
        ),
        body: TabBarView(children: [
          FreelancerBasic(
            currentID: widget.currentID,
            role: widget.role,
          ),
          Center(
            child: Text('Documents'),
          ),
          Center(
            child: Text('Portfolio'),
          ),
          GetClientServices(
            currentID: widget.currentID,
            role: widget.role,
          )
        ]),
      ),
    );
  }
}
