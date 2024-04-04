import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AdminScreens/Dashboard.dart';
import 'package:flutter_auth/asset_strings.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:side_navigation/side_navigation.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Widget> views = const [
    AdminDashboard(),
    Center(
      child: Text('Account'),
    ),
    Center(
      child: Text('Settings'),
    ),
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
                title: Text(
                  'Admin',
                  style: TextStyle(fontSize: 25),
                ),
                subtitle: Text('Manage your users')),
            footer: SideNavigationBarFooter(
                label: TextButton(
              child: Text('Logout'),
              onPressed: () {},
              onHover: (value) {},
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
                icon: Icons.settings,
                label: 'Settings',
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
                togglerTheme: SideNavigationBarTogglerTheme(
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
