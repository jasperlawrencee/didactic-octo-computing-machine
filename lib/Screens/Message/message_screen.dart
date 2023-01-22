import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/components/area.dart';
import 'package:flutter_auth/Screens/Home/components/navbar.dart';
import 'package:flutter_auth/Screens/Home/home_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
        child: SingleChildScrollView(
      child: Responsive(mobile: MobileMessageScreen(), desktop: Row()),
    ));
  }
}

class MobileMessageScreen extends StatefulWidget {
  @override
  _MobileMessageScreenState createState() => _MobileMessageScreenState();
}

class _MobileMessageScreenState extends State<MobileMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.navigation)),
            SizedBox(width: defaultPadding),
            Area(
                city: "Damosa, Davao City",
                area: "#789, Venus St., Victoria Heights, Damosa, Davao"),
            SizedBox(height: defaultPadding)
          ],
        ),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: kPrimaryLightColor),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(),
                        );
                      },
                      icon: Icon(Icons.search)),
                  Text("Search")
                ],
              ),
            )
          ],
        ),
        Container(
          child: NavBar(),
        )
      ],
    ));
  }
}
