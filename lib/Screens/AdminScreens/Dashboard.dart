import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/asset_strings.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AdminBG,
        appBar: AppBar(
          title: Text(
            'Welcome, Admin!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
        ),
        body: Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                defaultPadding, 20, defaultPadding, defaultPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    DashboardCard(
                      name: 'Total Service Fee Earnings',
                      image: cash,
                      value: 'PHP 50,000',
                      verified: true,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DashboardCard(
                      name: 'All Verified Freelancers',
                      image: worker,
                      value: '200',
                      verified: true,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DashboardCard(
                      name: 'All Verified Salons',
                      image: salon,
                      value: '350',
                      verified: true,
                    )
                  ],
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  children: [
                    DashboardCard(
                      name: 'ALL REGISTERED CLIENTS',
                      image: user,
                      value: '800',
                      verified: true,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DashboardCard(
                      name: 'ALL UNVERIFIED FREELANCERS',
                      image: worker,
                      value: '120',
                      verified: false,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DashboardCard(
                      name: 'ALL UNVERIFIED SALONS',
                      image: salon,
                      value: '150',
                      verified: false,
                    )
                  ],
                )
              ],
            ),
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
                  widget.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.verified ? textVerified : nameUnverified),
                )
              ])),
    );
  }
}
