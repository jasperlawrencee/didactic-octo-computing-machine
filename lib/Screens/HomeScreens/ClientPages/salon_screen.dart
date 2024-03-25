// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/calendar_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/message_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/profile_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/services_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../components/widgets.dart';
import '../../../../constants.dart';

//https://www.behance.net/gallery/181941113/Salon-Booking-App-UIUX-Design?tracking_source=search_projects|salon+app+design&l=60

class SalonScreen extends StatefulWidget {
  const SalonScreen({Key? key}) : super(key: key);

  @override
  State<SalonScreen> createState() => _SalonScreenState();
}

class _SalonScreenState extends State<SalonScreen> {
  PersistentTabController navbarController =
      PersistentTabController(initialIndex: 0);

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Leaving this page will log you out',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Log Out'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _showBackDialog();
      },
      child: Scaffold(
        bottomNavigationBar: PersistentTabView(
          context,
          controller: navbarController,
          stateManagement: true,
          screens: screens(),
          items: navBarItems(),
          confineInSafeArea: true,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10),
            colorBehindNavBar: Colors.white,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(microseconds: 100)),
          navBarStyle: NavBarStyle.style9,
        ),
      ),
    );
  }
}

List<Widget> screens() {
  return [
    const home(),
    const CalendarPage(),
    const ServicesPage(),
    const MessagePage(),
    const ProfilePage(),
  ];
}

List<PersistentBottomNavBarItem> navBarItems() {
  return [
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'Home',
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: kPrimaryLightColor),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.calendar_month_outlined),
      title: 'Bookings',
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
      title: 'Salon',
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
  String salonName = '';
  final _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getSalonName();
    super.initState();
  }

  void getSalonName() {
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .get()
        .then(((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot != null) {
        setState(() {
          salonName = documentSnapshot.get('name');
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    List<String> views = ['This Month', 'This Year', 'This Week'];
    List<String> branches = ['Branch 1', 'Branch 2', 'Branch 3'];
    String dropdownValue = views.first;
    String dropdownBranch = branches.first;

    return SafeArea(
      child: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                  const Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Text(
                    salonName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(defaultPadding),
                decoration: const BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointments',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Staff',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Feedbacks',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardButton(IconData icon, Function() function, String text) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return function();
          },
        ));
      },
      icon: Icon(icon),
      label: Text(text),
    );
  }
}
