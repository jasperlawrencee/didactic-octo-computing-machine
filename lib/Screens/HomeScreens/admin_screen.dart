import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AdminScreens/Sidebar.dart';
import 'package:flutter_auth/components/background.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 247, 251),
      body: SidebarAdmin(),
    );
  }
}
