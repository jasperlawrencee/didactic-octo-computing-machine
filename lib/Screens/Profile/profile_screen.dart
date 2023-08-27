import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/responsive.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Responsive(mobile: MobileProfileScreen(), desktop: Row()),
    ));
  }
}

class MobileProfileScreen extends StatefulWidget {
  @override
  _MobileProfileScreenState createState() => _MobileProfileScreenState();
}

class _MobileProfileScreenState extends State<MobileProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [Text("ProfileScreen"), Container()],
    ));
  }
}
