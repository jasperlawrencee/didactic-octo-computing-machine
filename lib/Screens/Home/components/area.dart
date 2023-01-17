import 'package:flutter/material.dart';

class Area extends StatelessWidget {
  final String city, area;
  const Area({Key? key, required this.city, required this.area})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$city\n$area",
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
