import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/Admin/SidebarScreens/applications_screen.dart';
import 'package:flutter_auth/Screens/HomeScreens/Admin/SidebarScreens/home_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:sidebarx/sidebarx.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _sidebarController =
      SidebarXController(selectedIndex: 0, extended: true);
  final key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        key: key,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text('Admin'),
          leading: IconButton(
              onPressed: () {
                key.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu)),
        ),
        body: Row(
          children: [
            Expanded(
                child: Center(
              child: AnimatedBuilder(
                animation: _sidebarController,
                builder: (context, child) {
                  switch (_sidebarController.selectedIndex) {
                    case 0:
                      log('index 0');
                      return Center(
                        child: AdminHome(),
                      );
                    case 1:
                      log('index 1');
                      return Center(
                        child: Applications(),
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ))
          ],
        ),
        drawer: SidebarXWidget(sidebarXController: _sidebarController),
      );
    });
  }
}

class SidebarXWidget extends StatelessWidget {
  const SidebarXWidget({Key? key, required this.sidebarXController})
      : super(key: key);
  final SidebarXController sidebarXController;
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: sidebarXController,
      theme: const SidebarXTheme(
        decoration: BoxDecoration(color: kPrimaryLightColor),
        iconTheme: IconThemeData(color: kPrimaryColor),
      ),
      extendedTheme: const SidebarXTheme(width: 200),
      headerBuilder: (context, extended) {
        return SizedBox(
          child: Image.asset('assets/images/logo.png'),
        );
      },
      items: const [
        SidebarXItem(icon: Icons.widgets, label: 'Home'),
        SidebarXItem(icon: Icons.work, label: 'Applications'),
      ],
    );
  }
}
