// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_auth/responsive.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
      child: Responsive(mobile: MobileProfileScreen(), desktop: Row()),
    ));
  }
}

class MobileProfileScreen extends StatefulWidget {
  const MobileProfileScreen({Key? key}) : super(key: key);

  @override
  _MobileProfileScreenState createState() => _MobileProfileScreenState();
}

class _MobileProfileScreenState extends State<MobileProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [const Text("ProfileScreen"), Container()],
    );
  }
}
