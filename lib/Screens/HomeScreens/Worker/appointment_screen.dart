import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class WorkerAppointmentScreen extends StatefulWidget {
  const WorkerAppointmentScreen({super.key});

  @override
  State<WorkerAppointmentScreen> createState() =>
      _WorkerAppointmentScreenState();
}

class _WorkerAppointmentScreenState extends State<WorkerAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: Container(
        margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "booking details".toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: defaultPadding),
              ],
            ),
            Text(
              'Ref. 123456789abc',
              style: const TextStyle(
                  color: Colors.black54, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: defaultPadding),
            //////////////////APPOINTMENT DETAILS///////////////////////////
            bookingCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer Name'),
                  SizedBox(height: 1),
                  Text(
                    'Juan dela Cruz',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: defaultPadding),
                  Text('Salon Place'),
                  SizedBox(height: 1),
                  Text(
                    'Salon Place, Barangay Kuan, Davao City',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: defaultPadding),
                  Text('Time & Date'),
                  SizedBox(height: 1),
                  Text(
                    '9:30 AM - 11:00 AM | JAN 25',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: defaultPadding),
                  Text('Service Appointment'),
                  SizedBox(height: 1),
                  Row(
                    children: [
                      serviceCard('Haircut'),
                      serviceCard('Hair Color'),
                      serviceCard('Rebond'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            //////////////////TRANSACTION DETAILS///////////////////////////
            bookingCard(const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Payment Method'), Text('GCash')],
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Php 810.00',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 1),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Haircut',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Php 350.00',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hair Color',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Php 350.00',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Manicure',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Php 500.00',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Service Fee',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Php 10.00',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                SizedBox(height: 1),
              ],
            )),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('BACK')),
                TextButton(onPressed: () {}, child: Text('CONFIRM')),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Container serviceCard(String service) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
      decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(
        service,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget bookingCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            offset: Offset(8, 8),
          )
        ],
      ),
      child: child,
    );
  }
}
