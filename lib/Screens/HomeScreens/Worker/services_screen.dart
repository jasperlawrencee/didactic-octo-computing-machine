import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: Container(
        margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
        child: Column(
          children: [Text("Services Page")],
        ),
      )),
    );
  }
}
