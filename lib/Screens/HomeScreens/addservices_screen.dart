import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/servicenames.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  List<String> serviceTypes = [
    'Hair',
    'Makeup',
    'Spa',
    'Nails',
    'Lashes',
    'Wax',
  ];
  String selectedServiceType = '';
  String serviceTypeValue = '';
  final TextEditingController _servicePrice = TextEditingController();
  final TextEditingController _serviceDuration = TextEditingController();
  final TextEditingController _serviceDescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Background(
            child: Container(
      margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Column(
        children: [
          Text(
            "Add Service".toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: defaultPadding),
          const Row(
            children: [
              Text(
                'Select Service Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
            decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(50)),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedServiceType.isEmpty ? null : selectedServiceType,
              items: serviceTypes.isNotEmpty
                  ? serviceTypes.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(fontSize: 14),
                          ));
                    }).toList()
                  : <DropdownMenuItem<String>>[],
              onChanged: (value) {
                setState(() {
                  serviceTypeValue = '';
                  selectedServiceType = value!;
                });
              },
            ),
          ),
          if (selectedServiceType.toLowerCase() == 'hair')
            serviceDropdown(ServiceNames().hair),
          if (selectedServiceType.toLowerCase() == 'makeup')
            serviceDropdown(ServiceNames().makeup),
          if (selectedServiceType.toLowerCase() == 'spa')
            serviceDropdown(ServiceNames().spa),
          if (selectedServiceType.toLowerCase() == 'nails')
            serviceDropdown(ServiceNames().nails),
          if (selectedServiceType.toLowerCase() == 'lashes')
            serviceDropdown(ServiceNames().lashes),
          if (selectedServiceType.toLowerCase() == 'wax')
            serviceDropdown(ServiceNames().wax),
          const SizedBox(height: defaultPadding),
          const Row(
            children: [
              Text(
                'Price',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          flatTextField('Serivce Price', _servicePrice),
          const SizedBox(height: defaultPadding),
          const Row(
            children: [
              Text(
                'Duration',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          flatTextField('Serivce Duration', _serviceDuration),
          const SizedBox(height: defaultPadding),
          const Row(
            children: [
              Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          flatTextField('Serivce Description', _serviceDescription),
          const SizedBox(height: defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('BACK')),
              TextButton(
                  onPressed: () {
                    log('Service Type: $selectedServiceType');
                    log('Specific Service: $serviceTypeValue');
                    log('Service Text: ${_servicePrice.text}');
                    log('Service Duration: ${_serviceDuration.text}');
                    log('Service Description: ${_serviceDescription.text}');
                  },
                  child: const Text('ADD'))
            ],
          )
        ],
      ),
    )));
  }

  Widget serviceDropdown(List<String> services) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        const Row(
          children: [
            Text(
              'Select Service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
            decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(50)),
            child: DropdownButton<String>(
              isExpanded: true,
              value: serviceTypeValue.isEmpty ? null : serviceTypeValue,
              items: services.isNotEmpty
                  ? services.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(fontSize: 14),
                          ));
                    }).toList()
                  : <DropdownMenuItem<String>>[],
              onChanged: (value) => setState(() {
                try {
                  serviceTypeValue = value!;
                } catch (e) {
                  log(e.toString());
                }
              }),
            )),
      ],
    );
  }
}
