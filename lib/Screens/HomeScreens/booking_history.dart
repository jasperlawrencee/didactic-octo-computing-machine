import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/ClientPages/salon_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:intl/intl.dart';

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
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(bookings[index].customerUsername),
                      Text(bookings[index].status),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              History(booking: bookings[index]),
                        ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class History extends StatelessWidget {
  Booking booking;
  History({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Container(
      padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('BOOKING DETAILS'),
          Text('ref ${booking.reference}'),
          const SizedBox(height: defaultPadding),
          bookingCard(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Customer Name'),
              Text(booking.customerUsername),
              const SizedBox(height: defaultPadding),
              const Text('Salon Place'),
              Text(booking.location),
              const SizedBox(height: defaultPadding),
              const Text('Time & Date'),
              Text(
                  '${DateFormat.jm().format(booking.dateFrom)} - ${DateFormat.jm().format(booking.dateTo)} | ${DateFormat('MMMMd').format(booking.dateTo)}'),
              const SizedBox(height: defaultPadding),
              const Text('Service Appointment'),
              const SizedBox(height: 1),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: 30,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: booking.services.length,
                      itemBuilder: (context, index) {
                        return serviceCard(
                            booking.services[index]['serviceName']);
                      },
                    ),
                  );
                },
              ),
            ],
          )),
          const SizedBox(height: defaultPadding),
          bookingCard(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment Method'),
                  Text(booking.paymentMethod)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  Text("PHP ${booking.totalAmount}")
                ],
              ),
            ],
          )),
        ],
      ),
    ));
  }
}
