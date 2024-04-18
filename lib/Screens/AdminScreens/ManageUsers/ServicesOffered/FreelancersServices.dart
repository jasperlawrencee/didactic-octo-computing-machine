import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientService {
  String serviceName;
  String price;
  String duration;
  String description;

  ClientService({
    required this.serviceName,
    required this.price,
    required this.duration,
    required this.description,
  });
}

class FreelancerServices extends StatefulWidget {
  final String currentID;

  const FreelancerServices({super.key, required this.currentID});

  @override
  State<FreelancerServices> createState() => _FreelancerServicesState();
}

class _FreelancerServicesState extends State<FreelancerServices> {
  Future<List<String>> getServiceCategories() async {
    try {
      List<String> mainCategories = [];

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentID)
          .collection('services')
          .get();

      querySnapshot.docs.forEach((element) {
        mainCategories.add(element.id);
      });

      return mainCategories;
    } catch (e) {
      log('error getting service types $e' as num);
      return [];
    }
  }

  Future<List<ClientService>> getServices(String serviceType) async {
    List<ClientService> services = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentID)
          .collection('services')
          .doc(serviceType)
          .collection('${widget.currentID}services')
          .get();

      for (var service in querySnapshot.docs) {
        if (service.exists) {
          services.add(ClientService(
              serviceName: service.id.toString(),
              price: service['price'],
              duration: service['duration'],
              description: service['description']));
        }
      }
      return services;
    } catch (e) {
      log('error getting services $e' as num);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
  return Text('hahha');
  }
}
