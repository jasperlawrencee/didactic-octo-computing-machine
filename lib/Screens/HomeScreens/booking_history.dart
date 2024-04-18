import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/salon_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class BookingsHistory extends StatelessWidget {
  List<Booking> bookings;
  BookingsHistory({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Container(
      padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Booking History',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
                fontSize: 16),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              return Text(bookings[index].reference);
            },
          ),
        ],
      ),
    ));
  }
}
