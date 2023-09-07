import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map> dashboardItem =
      List.generate(6, (index) => {'id': index + 1, 'name': 'Item $index'})
          .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: dashboardItem.length,
          itemBuilder: (BuildContext ctx, index) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadiusDirectional.circular(15)),
              child: Text(dashboardItem[index]['name']),
            );
          }),
    );
  }
}
