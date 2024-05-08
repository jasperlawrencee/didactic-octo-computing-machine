import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AdminScreens/Dashboard.dart';
import 'package:flutter_auth/constants.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  Future<List<AdminTransaction>> transactionHistory() async {
    try {
      List<AdminTransaction> history = [];
      QuerySnapshot querySnapshot = await db
          .collection('users')
          .doc(adminID)
          .collection('transaction')
          .get();
      querySnapshot.docs.forEach((element) {
        history.add(AdminTransaction(
            username: element['user'],
            amount: element['amount'],
            description: element['description'],
            timestamp: element['timestamp'].toDate()));
      });
      return history;
    } catch (e) {
      log('error getting transaction histroy $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminBG,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Transactions',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Expanded(
          child: FutureBuilder<List<AdminTransaction>>(
            future: transactionHistory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: defaultPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "PHP ${snapshot.data![index].amount.toStringAsFixed(2)}"),
                                  const SizedBox(width: defaultPadding),
                                  Text(" - ${snapshot.data![index].username}"),
                                ],
                              ),
                              Text('${snapshot.data![index].timestamp}'),
                            ],
                          ),
                          Text(snapshot.data![index].description.toUpperCase()),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class AdminTransaction {
  num amount;
  String description;
  DateTime timestamp;
  String username;

  AdminTransaction({
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.username,
  });
}
