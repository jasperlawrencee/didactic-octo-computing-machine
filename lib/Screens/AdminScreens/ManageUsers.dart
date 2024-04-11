import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AdminScreens/ManageUsers/Unverified.dart';
import 'package:flutter_auth/Screens/AdminScreens/ManageUsers/Verified.dart';
import 'package:flutter_auth/constants.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AdminBG,
        appBar: AppBar(
          toolbarHeight: 150,
          automaticallyImplyLeading: false,
          title: Text(
            'Manage Users',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              indicatorColor: kPrimaryColor,
              tabs: [
                Tab(
                  text: 'UNVERIFIED',
                ),
                Tab(
                  text: 'VERIFIED',
                )
              ]),
        ),
        body: TabBarView(
          children: [UnverifiedRegistrees(), VerifiedRegistrants()],
        ),
      ),
    );
  }
}
