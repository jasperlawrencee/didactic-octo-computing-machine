import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/asset_strings.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardValues {
  String verifiedFreelancers;
  String verifiedSalons;
  String unverifiedFreelancers;
  String unverifiedSalons;
  String allClients;

  DashboardValues(
      {required this.verifiedSalons,
      required this.verifiedFreelancers,
      required this.unverifiedSalons,
      required this.unverifiedFreelancers,
      required this.allClients});
}

final db = FirebaseFirestore.instance;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<String> status = ['verified', 'unverified'];

  Future<DashboardValues> getDashboardValues() async {
    QuerySnapshot clients = await db
        .collection('users')
        .where('status', whereIn: List.from(status))
        .get();

    final clientsCount = clients.docs.length;

    QuerySnapshot uvFreelancers = await db
        .collection('users')
        .where('status', isEqualTo: 'unverified')
        .where('role', isEqualTo: 'freelancer')
        .get();

    final uvFreelancersCount = uvFreelancers.docs.length;

    QuerySnapshot uvSalons = await db
        .collection('users')
        .where('status', isEqualTo: 'unverified')
        .where('role', isEqualTo: 'salon')
        .get();

    final uvSalonsCount = uvSalons.docs.length;

    QuerySnapshot verFreelancers = await db
        .collection('users')
        .where('status', isEqualTo: 'verified')
        .where('role', isEqualTo: 'freelancer')
        .get();

    final verFreelancersCount = verFreelancers.docs.length;

    QuerySnapshot verSalons = await db
        .collection('users')
        .where('status', isEqualTo: 'verified')
        .where('role', isEqualTo: 'salon')
        .get();

    final verSalonsCount = verSalons.docs.length;

    return DashboardValues(
        verifiedSalons: verSalonsCount.toString(),
        verifiedFreelancers: verFreelancersCount.toString(),
        unverifiedSalons: uvSalonsCount.toString(),
        unverifiedFreelancers: uvFreelancersCount.toString(),
        allClients: clientsCount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AdminBG,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Welcome, Admin!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
        ),
        body: Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                defaultPadding, 20, defaultPadding, defaultPadding),
            child: FutureBuilder<DashboardValues>(
                future: getDashboardValues(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var dashboardValues = snapshot.data!;
                    return Column(
                      children: [
                        Row(
                          children: [
                            // DashboardCard(
                            // name: 'Total Service Fee \nEarnings',
                            // image: cash,
                            // value: 'PHP 50,000',
                            // verified: true,
                            // ),
                            // SizedBox(
                            // width: 20,
                            // ),
                            DashboardCard(
                              name: 'All Verified \nFreelancers',
                              image: worker,
                              value: dashboardValues.verifiedFreelancers,
                              verified: true,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            DashboardCard(
                              name: 'All Verified \nSalons',
                              image: salon,
                              value: dashboardValues.verifiedSalons,
                              verified: true,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            DashboardCard(
                              name: 'ALL REGISTERED \nCLIENTS',
                              image: user,
                              value: dashboardValues.allClients,
                              verified: true,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          children: [
                            // SizedBox(
                            // width: 20,
                            // ),
                            DashboardCard(
                              name: 'ALL UNVERIFIED \nFREELANCERS',
                              image: worker,
                              value: dashboardValues.unverifiedFreelancers,
                              verified: false,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            DashboardCard(
                              name: 'ALL UNVERIFIED \nSALONS',
                              image: salon,
                              value: dashboardValues.unverifiedSalons,
                              verified: false,
                            )
                          ],
                        )
                      ],
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(color: kPrimaryColor));
                  }
                }),
          ),
        ));
  }
}

class DashboardCard extends StatefulWidget {
  final String name;
  final String image;
  final String value;
  final bool verified;
  const DashboardCard(
      {super.key,
      required this.name,
      required this.image,
      required this.value,
      required this.verified});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20)),
          height: 220,
          width: 330,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      widget.image,
                      width: 100,
                      color: widget.verified ? kPrimaryColor : iconUnverified,
                    ),
                    Text(widget.value,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.verified
                                ? kPrimaryColor
                                : iconUnverified))
                  ],
                ),
                Text(
                  widget.name.toUpperCase(),
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: widget.verified ? textVerified : nameUnverified),
                )
              ])),
    );
  }
}
