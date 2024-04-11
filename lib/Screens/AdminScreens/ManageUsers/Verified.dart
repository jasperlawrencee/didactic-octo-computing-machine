import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

final db = FirebaseFirestore.instance;

class VerifiedTile {
  final String name;
  final String type;
  final String status;

  VerifiedTile({required this.name, required this.type, required this.status});
}

class VerifiedRegistrants extends StatefulWidget {
  const VerifiedRegistrants({super.key});

  @override
  State<VerifiedRegistrants> createState() => _VerifiedRegistrantsState();
}

class _VerifiedRegistrantsState extends State<VerifiedRegistrants> {
  Future<List<String>> getVerifiedIds() async {
    List<String> verifiedIDS = [];
    await db
        .collection('users')
        .where('role', whereIn: ['freelancer', 'salon'])
        .where('status', isEqualTo: 'verified')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              verifiedIDS.add(element.reference.id.toString());
            }));
    return verifiedIDS;
  }

  Future<VerifiedTile?> getUserDetails(String userId) async {
    final DocumentSnapshot verifiedUser =
        await db.collection('users').doc(userId).get();

    if (!verifiedUser.exists) {
      return null;
    }

    return VerifiedTile(
        name: verifiedUser.get('name'),
        type: verifiedUser.get('role'),
        status: verifiedUser.get('status'));
  }

  Future<List<VerifiedTile>> allUnverified() async {
    List<Future<VerifiedTile?>> futures = [];

    for (var userId in (await getVerifiedIds())) {
      futures.add(getUserDetails(userId));
    }

    List<VerifiedTile?> resultsWithNull =
        await Future.wait<VerifiedTile?>(futures);

    return resultsWithNull.whereType<VerifiedTile>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<VerifiedTile>>(
        stream: Stream.fromFuture(allUnverified()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No verified workers/salons'));
          } else {
            List<VerifiedTile> verifiedUsers = snapshot.data!;

            return DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Action'))
                ],
                rows: verifiedUsers
                    .map((item) => DataRow(cells: [
                          DataCell(Text(item.name)),
                          DataCell(Text(
                              item.type.substring(0, 1).toUpperCase() +
                                  item.type.substring(1))),
                          DataCell(Text(
                            item.status.toUpperCase(),
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          )),
                          DataCell(TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.deepPurple[300];
                                  }
                                  return kPrimaryColor;
                                }),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kPrimaryLightColor),
                                iconColor: MaterialStateProperty.all<Color>(
                                    kPrimaryLightColor),
                              ),
                              onPressed: () {},
                              icon: Icon(Icons.visibility),
                              label: Text('View')))
                        ]))
                    .toList());
          }
        });
  }
}

DataRow _buildDataRow(VerifiedTile item) {
  final capitalRole =
      item.type.substring(0, 1).toUpperCase() + item.type.substring(1);
  return DataRow(cells: [
    DataCell(Text(item.name)),
    DataCell(Text(capitalRole)),
    DataCell(Text(
      item.status.toUpperCase(),
      style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
    )),
    DataCell(TextButton.icon(
        onPressed: () {},
        icon: Icon(Icons.edit_attributes),
        label: Text('Review')))
  ]);
}
