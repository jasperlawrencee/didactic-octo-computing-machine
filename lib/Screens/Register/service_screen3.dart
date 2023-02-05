import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Register/bioData2-1.dart';
import 'package:flutter_auth/Screens/Register/requirements5.dart';
import 'package:flutter_auth/Screens/Register/service_screen3-1.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class ServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
        child: SingleChildScrollView(
      child: Responsive(mobile: MobileServiceScreen(), desktop: Row()),
    ));
  }
}

class MobileServiceScreen extends StatefulWidget {
  @override
  _MobileServiceScreenState createState() => _MobileServiceScreenState();
}

class _MobileServiceScreenState extends State<MobileServiceScreen> {
  bool hair = false;
  bool makeup = false;
  bool spa = false;
  bool nails = false;
  bool lashes = false;
  bool wax = false;
  TextEditingController _serviceTextController = TextEditingController();

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            const Spacer(),
            Expanded(
                flex: 8,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 450,
                      child: Column(
                        children: <Widget>[
                          const Text("SERVICE CATEGORY"),
                          CheckboxListTile(
                            tileColor: kPrimaryLightColor,
                            value: hair,
                            onChanged: (value) {
                              setState(() {
                                hair = value!;
                              });
                            },
                            title: Text("Hair"),
                          ),
                          if (hair) ServiceItems(),
                          SizedBox(height: defaultPadding),
                          CheckboxListTile(
                            tileColor: kPrimaryLightColor,
                            value: makeup,
                            onChanged: (value) {
                              setState(() {
                                makeup = value!;
                              });
                            },
                            title: Text("Makeup"),
                          ),
                          if (makeup) ServiceItems(),
                          SizedBox(height: defaultPadding),
                          CheckboxListTile(
                            tileColor: kPrimaryLightColor,
                            value: spa,
                            onChanged: (value) {
                              setState(() {
                                spa = value!;
                              });
                            },
                            title: Text("Spa"),
                          ),
                          if (spa) ServiceItems(),
                          SizedBox(height: defaultPadding),
                          CheckboxListTile(
                            tileColor: kPrimaryLightColor,
                            value: nails,
                            onChanged: (value) {
                              setState(() {
                                nails = value!;
                              });
                            },
                            title: Text("Nails"),
                          ),
                          if (nails) ServiceItems(),
                          SizedBox(height: defaultPadding),
                          CheckboxListTile(
                            tileColor: kPrimaryLightColor,
                            value: lashes,
                            onChanged: (value) {
                              setState(() {
                                lashes = value!;
                              });
                            },
                            title: Text("Lashes"),
                          ),
                          if (lashes) ServiceItems(),
                          SizedBox(height: defaultPadding),
                          CheckboxListTile(
                            tileColor: kPrimaryLightColor,
                            value: wax,
                            onChanged: (value) {
                              setState(() {
                                wax = value!;
                              });
                            },
                            title: Text("Wax"),
                          ),
                          if (wax) ServiceItems(),
                          SizedBox(height: defaultPadding),
                          nextButton(context, () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Experience();
                            }));
                          }, "Next"),
                          backButton(context, () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Address();
                            }));
                          }, "Back")
                        ],
                      ),
                    )
                  ],
                )),
            const Spacer()
          ],
        )
      ],
    );
  }
}

class ServiceItems extends StatefulWidget {
  @override
  _ServiceItemsState createState() => _ServiceItemsState();
}

class _ServiceItemsState extends State<ServiceItems> {
  String? value;
  List<String> _items = [];
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DropdownButton<String>(
            hint: Text("Service Type"),
            value: value,
            isExpanded: true,
            items: _items.map(buildMenuItem).toList(),
            onChanged: (value) => setState(() => this.value = value),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration:
                      const InputDecoration(hintText: "Enter Service Type"),
                  controller: _textController,
                ),
              ),
              //Add Button
              TextButton(
                onPressed: (() {
                  setState(() {
                    _items.add(_textController.text);
                    _textController.clear();
                  });
                }),
                child: Text("Add"),
              ),
              //Delete Button
              TextButton(
                onPressed: (() {
                  setState(() {
                    if (value != null) {
                      _items.remove(value);
                      value = null;
                    }
                  });
                }),
                child: Text("Delete"),
              )
            ],
          )
        ],
      ),
    );
  }
}

class DropdownService extends StatelessWidget {
  final String service;

  const DropdownService({
    Key? key,
    required this.service,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(service),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
