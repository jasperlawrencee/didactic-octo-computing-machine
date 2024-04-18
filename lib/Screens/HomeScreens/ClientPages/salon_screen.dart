// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/calendar_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/message_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/profile_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/services_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/booking_history.dart';
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
      inactiveColorPrimary: kPrimaryLightColor,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {'/calendar': (context) => const CalendarPage()}),
    ),
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
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {'/calendar': (context) => const CalendarPage()}),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.message),
      title: 'Messages',
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: kPrimaryLightColor,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {'/calendar': (context) => const CalendarPage()}),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person),
      title: 'Salon',
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: kPrimaryLightColor,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {'/calendar': (context) => const CalendarPage()}),
    ),
  ];
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

final _firestore = FirebaseFirestore.instance;
User? currentUser = FirebaseAuth.instance.currentUser;

class _homeState extends State<home> {
  String salonName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              FutureBuilder<List<Booking>>(
                future: getBookingHistory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return salonHomeCard(
                      'Appointments History',
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          if (index == 2) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BookingsHistory(
                                    bookings: snapshot.data!,
                                  ),
                                ));
                              },
                              child: const Text(
                                'View More',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    decoration: TextDecoration.underline),
                              ),
                            );
                          } else {
                            return Container(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(snapshot.data![index].customerUsername),
                                  Text(snapshot.data![index].status
                                      .toUpperCase())
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: defaultPadding),
              FutureBuilder<List<Staff>>(
                future: getStaffList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return salonHomeCard(
                        'Staff List Preview',
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            if (index == 2) {
                              return const Text('. . .');
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(snapshot.data![index].name),
                                  Text(snapshot.data![index].role),
                                ],
                              );
                            }
                          },
                        ));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Booking>> getBookingHistory() async {
    try {
      List<Booking> history = [];
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('bookings')
          .get();
      querySnapshot.docs.forEach((element) {
        history.add(Booking(
          clientId: element['clientId'],
          clientUsername: element['clientUsername'],
          customerUsername: element['customerUsername'],
          dateFrom: element['dateFrom'].toDate(),
          dateTo: element['dateTo'].toDate(),
          location: element['location'],
          paymentMethod: element['paymentMethod'],
          reference: element['reference'],
          serviceFee: element['serviceFee'],
          services: element['services'],
          status: element['status'],
          totalAmount: element['totalAmount'],
          worker: element['worker'],
        ));
      });
      return history;
    } catch (e) {
      log('error getting booking history $e');
      return [];
    }
  }

  Future<List<Staff>> getStaffList() async {
    try {
      List<Staff> staffList = [];
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('staff')
          .get();
      querySnapshot.docs.forEach((element) {
        staffList.add(Staff(
          contactNum: element['contact'],
          name: element['name'],
          role: element['role'],
        ));
      });
      return staffList;
    } catch (e) {
      log('error getting staff list');
      return [];
    }
  }
}

class Booking {
  String clientId;
  String clientUsername;
  String customerUsername;
  DateTime dateFrom;
  DateTime dateTo;
  String location;
  String paymentMethod;
  String reference;
  String serviceFee;
  List<dynamic> services;
  String status;
  String totalAmount;
  String? worker;

  Booking({
    required this.clientId,
    required this.clientUsername,
    required this.customerUsername,
    required this.dateFrom,
    required this.dateTo,
    required this.location,
    required this.paymentMethod,
    required this.reference,
    required this.serviceFee,
    required this.services,
    required this.status,
    required this.totalAmount,
    required this.worker,
  });
}

class Staff {
  String contactNum;
  String name;
  String role;

  Staff({
    required this.contactNum,
    required this.name,
    required this.role,
  });
}

class Client {
  String address;
  String? gender;
  String? birthday;
  String email;
  String name;
  String? primaryPhoneNum;
  String? secondaryPhoneNum;
  String? representativeNum;
  String role;
  double rating;
  String profilePicutre;
  String? username;
  String? salonNumber;
  String? salonOwner;
  String? salonRepresentative;

  Client({
    required this.address,
    this.gender,
    this.birthday,
    required this.email,
    required this.name,
    this.primaryPhoneNum,
    this.secondaryPhoneNum,
    required this.role,
    required this.rating,
    required this.profilePicutre,
    this.username,
    this.salonNumber,
    this.salonOwner,
    this.salonRepresentative,
    this.representativeNum,
  });
}
