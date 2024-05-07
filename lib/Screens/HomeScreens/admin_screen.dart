import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AdminScreens/Dashboard.dart';
import 'package:flutter_auth/Screens/AdminScreens/ManageUsers.dart';
import 'package:flutter_auth/Screens/AdminScreens/Transactions.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/asset_strings.dart';
import 'package:flutter_auth/constants.dart';
import 'package:side_navigation/side_navigation.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Future<void> signUserOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    } catch (e) {
      log('error signing out $e');
    }
  }

  List<Widget> views = const [
    AdminDashboard(),
    ManageUsers(),
    Transactions(),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            expandable: true,
            header: SideNavigationBarHeader(
                image: Image.asset(
                  Logo,
                  width: 60,
                ),
                title: const Text(
                  'Admin',
                  style: TextStyle(fontSize: 25),
                ),
                subtitle: const Text('Manage your users')),
            footer: SideNavigationBarFooter(
                label: TextButton(
              onPressed: signUserOut,
              onHover: (value) {},
              child: const Text('Logout'),
            )),
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
              ),
              SideNavigationBarItem(
                icon: Icons.people,
                label: 'Manage Users',
              ),
              SideNavigationBarItem(
                icon: Icons.monetization_on,
                label: 'Transactions',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            theme: SideNavigationBarTheme(
                itemTheme: SideNavigationBarItemTheme(
                    selectedItemColor: kPrimaryColor,
                    selectedBackgroundColor: kPrimaryLightColor),
                togglerTheme: const SideNavigationBarTogglerTheme(
                    expandIconColor: kPrimaryColor),
                dividerTheme: SideNavigationBarDividerTheme.standard()),
          ),
          Expanded(
            child: views.elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}
