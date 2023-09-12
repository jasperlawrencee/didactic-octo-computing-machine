import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
          child: Column(
            children: [
              Text(
                "Salon Profile".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //salon name and picture
                  salonCard(Column(
                    children: [
                      SizedBox(
                        height: 90,
                        child: ClipOval(
                            child: Image.asset('assets/avatars/5.jpg')),
                      ),
                      const Spacer(),
                      const Text(
                        'Jollibee Beauty Salon',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  )),
                  //salon address
                  salonCard(const Column(
                    children: [
                      SizedBox(
                        height: 75,
                        child: Icon(
                          Icons.location_on,
                          color: kPrimaryColor,
                          size: 50,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Salon Address, Barangay, Building Number',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  )),
                  //salon phone number
                ],
              ),
              const SizedBox(height: defaultPadding),
              //call salon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Call: '),
                  InkWell(
                    //call function
                    onTap: (() {}),
                    child: const Text(
                      '+639123456789',
                      style: TextStyle(
                          color: kPrimaryColor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return salonServiceCard(index);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget salonServiceCard(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: defaultPadding),
      color: kPrimaryLightColor,
      width: double.infinity,
      height: 100,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Service #$index',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Spacer(),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text('price-range'),
          ),
        ],
      ),
    );
  }

  Container salonCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 150,
      width: 150,
      decoration: const BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: child,
    );
  }
}
