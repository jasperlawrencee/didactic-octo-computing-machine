import 'package:flutter/material.dart';

class SidebarAdmin extends StatefulWidget {
  const SidebarAdmin({Key? key});

  @override
  State<SidebarAdmin> createState() => _SidebarAdminState();
}

class _SidebarAdminState extends State<SidebarAdmin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      width:
          250, // Adjust the width as per your design // Adjust the color as per your design
      child: Column(
        children: [
          Material(
            child: ListTile(
              title: Container(
                  width: 250,
                  height: 180,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.scaleDown,
                  )),
              onTap: () {},
            ),
          ),
          Material(
            child: ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              hoverColor: Color.fromARGB(70, 111, 53, 165),
              onTap: () {
                // Add functionality for Item 2 here
              },
            ),
          ),
          Material(
            child: ListTile(
              leading: Icon(Icons.people),
              title: Text('Manage Users'),
              hoverColor: Color.fromARGB(70, 111, 53, 165),
              onTap: () {
                // Add functionality for Item 2 here
              },
            ),
          ),
          // Add more ListTiles for additional sidebar items
        ],
      ),
    );
  }
}
