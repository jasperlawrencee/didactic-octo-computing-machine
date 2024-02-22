import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class SalonDetails extends StatefulWidget {
  const SalonDetails({super.key});

  @override
  State<SalonDetails> createState() => _SalonDetailsState();
}

class _SalonDetailsState extends State<SalonDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Background(
            child: Container(
      margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Column(
        children: <Widget>[
          Text(
            "Salon Profile".toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    )));
  }
}
