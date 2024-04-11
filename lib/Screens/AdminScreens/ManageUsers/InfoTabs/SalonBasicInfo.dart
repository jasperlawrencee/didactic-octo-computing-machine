import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/asset_strings.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

final db = FirebaseFirestore.instance;

class ClassSalonBasicInfo {
  final String salonName;
  final String salonContactNum;
  final String address;
  final String salonRep;
  final String repContact;
  final String repEmail;
  final String salonOwner;
  final String profPic;
  final String repID;

  ClassSalonBasicInfo(
      {required this.salonName,
      required this.address,
      required this.salonContactNum,
      required this.repContact,
      required this.repEmail,
      required this.salonRep,
      required this.salonOwner,
      required this.profPic,
      required this.repID});
}

class SalonBasicInfo extends StatefulWidget {
  final String currentID;
  final String role;
  const SalonBasicInfo(
      {super.key, required this.currentID, required this.role});

  @override
  State<SalonBasicInfo> createState() => _SalonBasicInfoState();
}

class _SalonBasicInfoState extends State<SalonBasicInfo> {
  final TextEditingController _salonName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _salonContact = TextEditingController();
  final TextEditingController _repContact = TextEditingController();
  final TextEditingController _repEmail = TextEditingController();
  final TextEditingController _salonRep = TextEditingController();
  final TextEditingController _salonOwner = TextEditingController();

  Future<ClassSalonBasicInfo> getSalonSalonBasicInfo() async {
    final DocumentSnapshot<Map<String, dynamic>> salonBasicInfo =
        await db.collection('users').doc(widget.currentID).get();

    return ClassSalonBasicInfo(
        salonName: salonBasicInfo.get('name'),
        address: salonBasicInfo.get('address'),
        salonContactNum: salonBasicInfo.get('salonNumber'),
        repContact: salonBasicInfo.get('representativeNum'),
        repEmail: salonBasicInfo.get('representativeEmail'),
        salonRep: salonBasicInfo.get('salonRepresentative'),
        salonOwner: salonBasicInfo.get('salonOwner'),
        profPic: salonBasicInfo.get('profilePicture'),
        repID: salonBasicInfo.get('representativeID'));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSalonSalonBasicInfo(),
        builder: (context, AsyncSnapshot<ClassSalonBasicInfo> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Loading...'));
          } else {
            final basicInfo = snapshot.data!;

            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        adminHeading('Salon Basic Information'),
                        basicInfo.profPic!.isEmpty
                            ? CircleAvatar(
                                radius: 50,
                                child: Text(
                                  'Profile Picture',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(basicInfo.profPic),
                              )
                      ]),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: adminTextField(
                              'Salon Name', basicInfo.salonName, _salonName)),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: adminTextField('Contact Number',
                              basicInfo.salonContactNum, _salonContact)),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: adminTextField(
                              'Owner', basicInfo.salonOwner, _salonOwner)),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  adminHeading('Representative'),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: adminTextField("Representative Name",
                              basicInfo.salonRep, _salonRep)),
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                          child: adminTextField("Contact Number",
                              basicInfo.repContact, _repContact)),
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                          child: adminTextField(
                              "Email Address", basicInfo.repEmail, _repEmail))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text('ID Picture'),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  adminHeading('Address'),
                  SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    Expanded(
                        child: adminTextField(
                            'Address', basicInfo.address, _address))
                  ])
                ],
              ),
            ));
          }
        });
  }
}
