import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';

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
            children: [
              Text(
                "Services".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return serviceCard(index);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceCard(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: defaultPadding),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kPrimaryLightColor,
      ),
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
          )
        ],
      ),
    );
  }
}
