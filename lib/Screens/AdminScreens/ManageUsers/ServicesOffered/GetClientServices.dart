import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AdminScreens/ManageUsers/ServicesOffered/services.dart';
import 'package:flutter_auth/constants.dart';
import 'package:intl/intl.dart';

class GetClientServices extends StatefulWidget {
  final String role;
  final String currentID;

  const GetClientServices(
      {super.key, required this.currentID, required this.role});

  @override
  State<GetClientServices> createState() => _GetClientServicesState();
}

class _GetClientServicesState extends State<GetClientServices> {
  Future<List<String>> getServiceCategories() async {
    List<String> mainCategories = [];
    try {
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

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,##0.00');
    return SingleChildScrollView(
      child: StreamBuilder<List<String>>(
          stream: Stream.fromFuture(getServiceCategories()),
          builder: (context, serviceType) {
            if (serviceType.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: serviceType.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, serviceTypeIndex) {
                  return Column(children: [
                    Text(serviceType.data![serviceTypeIndex]),
                    FutureBuilder<List<ClientService>>(
                        future: getServices(serviceType.data![serviceTypeIndex],
                            widget.currentID),
                        builder: (context, service) {
                          if (service.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: service.data!.length,
                                itemBuilder: (context, serviceIndex) {
                                  var serviceData = service.data!;
                                  return Container(
                                      padding: EdgeInsets.all(defaultPadding),
                                      decoration: const BoxDecoration(
                                          color: kPrimaryLightColor),
                                      margin: EdgeInsets.all(defaultPadding),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                serviceData[serviceIndex]
                                                    .serviceName,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                serviceData[serviceIndex]
                                                        .duration
                                                        .isEmpty
                                                    ? '-description to be added'
                                                    : '-${serviceData[serviceIndex].duration}',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                          Text(serviceData[serviceIndex]
                                                  .description
                                                  .isEmpty
                                              ? '(prices to be added)'
                                              : 'PHP ${serviceData[serviceIndex].price}')
                                          // Text(
                                          // "PHP ${format.format(double.parse(serviceData[serviceIndex].price))}")
                                        ],
                                      ));
                                });
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            );
                          }
                        })
                  ]);
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
