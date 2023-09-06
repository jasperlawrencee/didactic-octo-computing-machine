import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: Container(
        margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
        child: Column(
          children: [Text("Profile Page")],
        ),
      )),
    );
  }
}
