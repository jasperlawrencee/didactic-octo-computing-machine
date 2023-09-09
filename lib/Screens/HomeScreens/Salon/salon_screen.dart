import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/Salon/profile_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../components/widgets.dart';
import '../../../constants.dart';

class SalonScreen extends StatefulWidget {
  const SalonScreen({Key? key}) : super(key: key);

  @override
  State<SalonScreen> createState() => _SalonScreenState();
}

class _SalonScreenState extends State<SalonScreen> {
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
    );
  }
}

List<Widget> screens() {
  return [
    const home(),
    // const calendarPage(),
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
      icon: const Icon(Icons.person),
      title: 'Salon',
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: kPrimaryLightColor,
    ),
  ];
}

class home extends StatelessWidget {
  const home({Key? key}) : super(key: key);

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
                  const Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const Row(
                children: [
                  Text(
                    "Good Day, {salon}!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              //put navbar here
            ],
          ),
        ),
      ),
    );
  }
}
