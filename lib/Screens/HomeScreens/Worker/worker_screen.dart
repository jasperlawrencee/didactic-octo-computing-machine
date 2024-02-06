// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/Worker/calendar_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/Worker/message_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/Worker/profile_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/Worker/services_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class WorkerScreen extends StatefulWidget {
  const WorkerScreen({Key? key}) : super(key: key);

  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
  PersistentTabController navbarController =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PersistentTabView(
        context,
        controller: navbarController,
        stateManagement: true,
        screens: screens(),
        items: navbarItems(),
        confineInSafeArea: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10),
          colorBehindNavBar: Colors.white,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 100)),
        navBarStyle: NavBarStyle.style9,
      ),
    );
  }

  List<Widget> screens() {
    return [
      const home(),
      const WorkerCalendarPage(),
      const ServicesPage(),
      const MessagePage(),
      const ProfilePage(
        parentDocumentId: 'users',
      ),
    ];
  }
}

List<PersistentBottomNavBarItem> navbarItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: 'Home',
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: kPrimaryLightColor,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.calendar_month_outlined),
      title: 'Calendar',
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: kPrimaryLightColor,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.room_service_outlined),
      title: 'Services',
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: kPrimaryLightColor,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.message),
      title: 'Messages',
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: kPrimaryLightColor,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person),
      title: 'Profile',
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: kPrimaryLightColor,
    ),
  ];
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  String name = '';

  @override
  void initState() {
    super.initState;
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get()
        .then(((DocumentSnapshot documentSnapshot) {
      // log(documentSnapshot.get('username'));
      setState(() {
        name = documentSnapshot.get('username');
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 35, 20, 0),
          child: Column(
            children: <Widget>[
              // const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Logout Button
                  logOutButton(context),
                  //App name
                  Text(
                    "Pamphere".toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: kPrimaryColor,
                    ),
                  ),
                  //Notification Widget
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.settings,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Column(children: [
                Text('Welcome back, $name!'),
              ]),
              //put navbar here
            ],
          ),
        ),
      ),
    );
  }
}
