import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Background(
          child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
          child: Column(
            children: [
              Text(
                "Notifications".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              Container(
                height: height * 0.4,
                color: kPrimaryColor,
                child: LayoutBuilder(builder: (contex, constraints) {
                  double innerHeight = constraints.maxHeight;
                  double innerWidth = constraints.maxWidth;
                  return Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: innerHeight * 0.65,
                          color: kPrimaryLightColor,
                        ),
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
