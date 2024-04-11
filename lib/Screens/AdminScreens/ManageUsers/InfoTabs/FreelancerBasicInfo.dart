import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

final db = FirebaseFirestore.instance;

class ClassFreelancerBasicInfo {
  final String name;
  final String gender;
  final String birthday;
  final String phoneNum1;
  final String phoneNum2;
  final String email;
  final String address;
  final String profPic;
  // final String street;
  // final String extAddress;
  // final String brgy;
  // final String city;

  ClassFreelancerBasicInfo(
      {required this.name,
      required this.gender,
      required this.birthday,
      required this.phoneNum1,
      required this.phoneNum2,
      required this.email,
      required this.address,
      required this.profPic});
}

class FreelancerBasic extends StatefulWidget {
  final String currentID;
  final String role;
  const FreelancerBasic(
      {super.key, required this.currentID, required this.role});

  @override
  State<FreelancerBasic> createState() => _FreelancerBasicState();
}

class _FreelancerBasicState extends State<FreelancerBasic> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _phoneNum1 = TextEditingController();
  final TextEditingController _phoneNum2 = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();

  Future<ClassFreelancerBasicInfo> getFreelancerInfo() async {
    final DocumentSnapshot<Map<String, dynamic>> info =
        await db.collection('users').doc(widget.currentID).get();

    return ClassFreelancerBasicInfo(
        name: info.get('name'),
        address: info.get('address'),
        birthday: info.get('birthday'),
        email: info.get('email'),
        gender: info.get('gender'),
        phoneNum1: info.get('primaryPhoneNumber'),
        phoneNum2: info.get('secondaryPhoneNumber'),
        profPic: info.get('profilePicture'));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFreelancerInfo(),
        builder: (context, AsyncSnapshot<ClassFreelancerBasicInfo> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          } else {
            final info = snapshot.data!;
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
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                adminHeading('Freelancer Personal Information'),
                                info.profPic!.isEmpty
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
                                            NetworkImage(info.profPic),
                                      )
                              ]),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: adminTextField(
                                      'Full Name', info.name, _name)),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  child: adminTextField(
                                      'Gender', info.gender, _gender)),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  child: adminTextField(
                                      'Birthday', info.birthday, _birthday)),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          adminHeading('Contact Information'),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: adminTextField(
                                      'Primary Contact Number',
                                      info.phoneNum1,
                                      _phoneNum1)),
                              Expanded(
                                  child: adminTextField(
                                      'Secondary Contact Number',
                                      info.phoneNum2,
                                      _phoneNum2)),
                              Expanded(
                                  child: adminTextField(
                                      'Email Address', info.email, _email)),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          adminHeading('Address'),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: adminTextField('Complete Address',
                                      info.address, _address)),
                            ],
                          )
                        ])));
          }
        });
  }
}
