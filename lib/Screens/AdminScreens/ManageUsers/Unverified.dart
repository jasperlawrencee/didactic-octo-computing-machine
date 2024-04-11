import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AdminScreens/ManageUsers/ApproveUnverifiedFreelancers.dart';
import 'package:flutter_auth/Screens/AdminScreens/ManageUsers/ApproveUnverifiedSalons.dart';
import 'package:flutter_auth/constants.dart';

final db = FirebaseFirestore.instance;

class UnverifiedTile {
  final String id;
  final String name;
  final String type;
  final String status;

  UnverifiedTile(
      {required this.id,
      required this.name,
      required this.type,
      required this.status});
}

class UnverifiedRegistrees extends StatefulWidget {
  const UnverifiedRegistrees({super.key});

  @override
  State<UnverifiedRegistrees> createState() => _UnverifiedRegistreesState();
}

class _UnverifiedRegistreesState extends State<UnverifiedRegistrees> {
  Future<List<String>> getUnverifiedIds() async {
    List<String> unverifiedIDS = [];
    await db
        .collection('users')
        .where('role', whereIn: ['freelancer', 'salon'])
        .where('status', isEqualTo: 'unverified')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              unverifiedIDS.add(element.reference.id.toString());
            }));
    return unverifiedIDS;
  }

  Future<UnverifiedTile?> getUserDetails(String userId) async {
    final DocumentSnapshot unverifiedUser =
        await db.collection('users').doc(userId).get();

    if (!unverifiedUser.exists) {
      return null;
    }

    return UnverifiedTile(
        id: unverifiedUser.id.toString(),
        name: unverifiedUser.get('name'),
        type: unverifiedUser.get('role'),
        status: unverifiedUser.get('status'));
  }

  Future<List<UnverifiedTile>> allUnverified() async {
    List<Future<UnverifiedTile?>> futures = [];

    for (var userId in (await getUnverifiedIds())) {
      futures.add(getUserDetails(userId));
    }

    List<UnverifiedTile?> resultsWithNull =
        await Future.wait<UnverifiedTile?>(futures);

    return resultsWithNull.whereType<UnverifiedTile>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UnverifiedTile>>(
        stream: Stream.fromFuture(allUnverified()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No unverified workers/salons'));
          } else {
            List<UnverifiedTile> unverifiedUsers = snapshot.data!;

            return DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Action'))
                ],
                rows: unverifiedUsers
                    .map((item) => DataRow(cells: [
                          DataCell(Text(item.name)),
                          DataCell(Text(
                              item.type.substring(0, 1).toUpperCase() +
                                  item.type.substring(1))),
                          DataCell(Text(item.status.toUpperCase())),
                          DataCell(TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.black26;
                                  }
                                  return adminUnverified;
                                }),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white70),
                                iconColor: MaterialStateProperty.all<Color>(
                                    Colors.white70),
                              ),
                              onPressed: () {
                                if (item.type == 'salon') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UnverifiedInfo(
                                              currentID: item.id,
                                              role: item.type,
                                            )),
                                  );
                                } else if (item.type == 'freelancer') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UnverifiedInfoFreelancers(
                                              currentID: item.id,
                                              role: item.type,
                                            )),
                                  );
                                }
                              },
                              icon: Icon(Icons.edit_document),
                              label: Text('Approve')))
                        ]))
                    .toList());
          }
        });
  }
}
