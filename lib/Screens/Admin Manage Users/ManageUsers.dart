import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AdminScreens/Sidebar.dart';
import 'package:flutter_auth/constants.dart';

class AdminManageUsers extends StatefulWidget {
  const AdminManageUsers({Key? key}) : super(key: key);

  @override
  State<AdminManageUsers> createState() => _AdminManageUsersState();
}

class _AdminManageUsersState extends State<AdminManageUsers> {
  late String selectedValue;
  String dropdownvalue = 'Salons';
  List<String> itemsOne = ['Salons', 'Freelancers'];

  String dropdownvalueTwo = 'Unverified';
  List<String> itemsTwo = ['Unverified', 'Verified', 'All'];

  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
          children: cells.map((cell) {
        final style = TextStyle(
          color: isHeader ? Colors.grey : Colors.black,
          fontWeight: isHeader ? FontWeight.w100 : FontWeight.normal,
          fontSize: 18,
        );

        return Padding(
            padding: const EdgeInsets.all(12),
            child: Text(cell, textAlign: TextAlign.left, style: style));
      }).toList());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SidebarAdmin(),
          Column(
            children: [
              Text(
                'Hi Admin!',
              ),
              SizedBox(
                width: 50,
              ),
              Row(
                children: [
                  Text(
                    'User Type:',
                    style: TextStyle(
                        fontSize: 16, fontFamily: 'Inter', color: Colors.black),
                  ),
                  Material(
                    child: DropdownButton(
                      value: dropdownvalue,
                      icon: Icon(Icons.arrow_downward),
                      items: itemsOne.map((String itemsOne) {
                        return DropdownMenuItem(
                            value: itemsOne, child: Text(itemsOne));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Material(
                    child: DropdownButton(
                      value: dropdownvalueTwo,
                      icon: Icon(Icons.arrow_downward),
                      items: itemsTwo.map((String itemsTwo) {
                        return DropdownMenuItem(
                            value: itemsTwo, child: Text(itemsTwo));
                      }).toList(),
                      onChanged: (String? newValueTwo) {
                        setState(() {
                          dropdownvalueTwo = newValueTwo!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width - 250,
                  // height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: kPrimaryColor, // Border color
                      width: 2.0, // Border width
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                            0, 2), // Shadow position (horizontal, vertical)
                        blurRadius: 6.0, // Shadow blur radius
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Unverified Users',
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Inter',
                            color: Colors.black),
                      ),
                      //
                      // DataTable(columns: columns, rows: rows)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
