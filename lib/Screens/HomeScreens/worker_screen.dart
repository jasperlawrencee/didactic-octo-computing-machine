import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

class WorkerScreen extends StatefulWidget {
  const WorkerScreen({Key? key}) : super(key: key);

  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const home(),
    const services(),
    const profile(),
  ];

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
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
                  Icons.notifications_active,
                  color: kPrimaryColor,
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Row(
              children: [
                Text("Welcome, {name}!"),
              ],
            ),
            //put navbar here
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class home extends StatelessWidget {
  const home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Page 1 Content'),
    );
  }
}

class services extends StatelessWidget {
  const services({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Page 2 Content'),
    );
  }
}

class profile extends StatelessWidget {
  const profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Page 3 Content'),
    );
  }
}
