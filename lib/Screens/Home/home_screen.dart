import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/components/area.dart';
import 'package:flutter_auth/Screens/Home/components/services.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Background(
        child: SingleChildScrollView(
      child: Responsive(mobile: MobileHomeScreen(), desktop: Row()),
    ));
  }
}

class MobileHomeScreen extends StatelessWidget {
  final services = ['Hair', 'Makeup', 'Spa', 'Nails', 'Lashes'];

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Icon(Icons.navigation),
            SizedBox(width: defaultPadding),
            Area(
                city: "Damosa, Davao City",
                area: "#789, Venus St., Victoria Heights, Damosa, Davao"),
            SizedBox(height: defaultPadding)
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          for (int i = 0; i < 5; i++) Services(svcType: services[i])
        ])
      ],
    );
  }
}
