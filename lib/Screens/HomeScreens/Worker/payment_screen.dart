import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/Worker/completePayment_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: SafeArea(
              child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
                  child: Theme(
                    data: ThemeData(
                        canvasColor: Colors.transparent,
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: kPrimaryColor,
                              background: Colors.white70,
                              secondary: kPrimaryLightColor,
                            )),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.arrow_back),
                              color: kPrimaryColor,
                            ),
                            const Text(
                              'Payment Details',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: kPrimaryColor,
                              ),
                            ),
                            const SizedBox(width: 36),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        const Row(
                          children: [
                            Text('Customer Details'),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Juan dela Cruz',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    SizedBox(width: 5),
                                    Text(
                                        'Magallanes, Bolton Extension, Davao City'),
                                  ],
                                )
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.call),
                              color: kPrimaryColor,
                            )
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(color: kPrimaryColor),
                        ),
                        const SizedBox(height: defaultPadding),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Transaction Details'),
                            Text(
                              'Ref. 123456',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        const SingleChildScrollView(
                          child: Column(
                            children: [],
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CompletePayment()));
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 10,
                          )),
                          child: const Text(
                            'Finish Transaction',
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: defaultPadding)
                      ],
                    ),
                  )))),
    );
  }
}
