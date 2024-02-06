// ignore_for_file: camel_case_types, library_private_types_in_public_api, duplicate_ignore, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/SalonRegister/register_stepper.dart';

import '../../../constants.dart';

//parent widget
class step3 extends StatefulWidget {
  const step3({Key? key}) : super(key: key);

  @override
  _step3State createState() => _step3State();
}

class _step3State extends State<step3> {
  bool hair = false;
  bool makeup = false;
  bool spa = false;
  bool nails = false;
  bool lashes = false;
  bool wax = false;

  final TextEditingController _hairController = TextEditingController();
  final TextEditingController _makeupController = TextEditingController();
  final TextEditingController _spaController = TextEditingController();
  final TextEditingController _nailsController = TextEditingController();
  final TextEditingController _lashesController = TextEditingController();
  final TextEditingController _waxController = TextEditingController();

  String selectedHairValue = '';
  String selectedMakeupValue = '';
  String selectedSpaValue = '';
  String selectedNailsValue = '';
  String selectedLashesValue = '';
  String selectedWaxValue = '';

  List<String> hairValues = [];
  List<String> makeupValues = [];
  List<String> spaValues = [];
  List<String> nailsValues = [];
  List<String> lashesValues = [];
  List<String> waxValues = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          "Service Category\nYou may select multiple",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        CheckboxListTile(
          value: hair,
          onChanged: (value) {
            setState(() {
              hair = value!;
              salonForm.isHairClicked = value;
            });
          },
          title: const Text("Hair"),
        ),
        if (hair)
          ServiceItems(
            items: hairValues,
            selectedValue: selectedHairValue,
            serviceTextEditingController: _hairController,
            type: ServiceType.hair,
          ),
        CheckboxListTile(
          value: makeup,
          onChanged: (value) {
            setState(() {
              makeup = value!;
              salonForm.isMakeupClicked = value;
            });
          },
          title: const Text("Makeup"),
        ),
        if (makeup)
          ServiceItems(
            items: makeupValues,
            selectedValue: selectedMakeupValue,
            serviceTextEditingController: _makeupController,
            type: ServiceType.makeup,
          ),
        CheckboxListTile(
          value: spa,
          onChanged: (value) {
            setState(() {
              spa = value!;
              salonForm.isSpaClicked = value;
            });
          },
          title: const Text("Spa"),
        ),
        if (spa)
          ServiceItems(
            items: spaValues,
            selectedValue: selectedSpaValue,
            serviceTextEditingController: _spaController,
            type: ServiceType.spa,
          ),
        CheckboxListTile(
          value: nails,
          onChanged: (value) {
            setState(() {
              nails = value!;
              salonForm.isNailsClicked = value;
            });
          },
          title: const Text("Nails"),
        ),
        if (nails)
          ServiceItems(
            items: nailsValues,
            selectedValue: selectedNailsValue,
            serviceTextEditingController: _nailsController,
            type: ServiceType.nails,
          ),
        CheckboxListTile(
          value: lashes,
          onChanged: (value) {
            setState(() {
              lashes = value!;
              salonForm.isLashesClicked = value;
            });
          },
          title: const Text("Lashes"),
        ),
        if (lashes)
          ServiceItems(
            items: lashesValues,
            selectedValue: selectedLashesValue,
            serviceTextEditingController: _lashesController,
            type: ServiceType.lashes,
          ),
        CheckboxListTile(
          value: wax,
          onChanged: (value) {
            setState(() {
              wax = value!;
              salonForm.isWaxClicked = value;
            });
          },
          title: const Text("Wax"),
        ),
        if (wax)
          ServiceItems(
            items: waxValues,
            selectedValue: selectedWaxValue,
            serviceTextEditingController: _waxController,
            type: ServiceType.wax,
          ),
      ],
    );
  }
}

//child widget
class ServiceItems extends StatefulWidget {
  List<String> items;
  String selectedValue;
  TextEditingController serviceTextEditingController = TextEditingController();
  final ServiceType type;
  ServiceItems({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.serviceTextEditingController,
    required this.type,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ServiceItemsState createState() => _ServiceItemsState();
}

class _ServiceItemsState extends State<ServiceItems> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Theme(
          data: ThemeData(canvasColor: Colors.white),
          child: DropdownButton<String>(
            hint: const Text(
              "Service Type",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            value: widget.selectedValue.isEmpty ? null : widget.selectedValue,
            isExpanded: true,
            items: widget.items.isNotEmpty
                ? widget.items.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList()
                : <DropdownMenuItem<String>>[],
            onChanged: (value) => setState(() {
              try {
                widget.selectedValue = value!;
              } catch (e) {
                log(e.toString());
              }
            }),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                decoration:
                    const InputDecoration(hintText: "Enter Service Type"),
                controller: widget.serviceTextEditingController,
              ),
            ),
            //Add Button
            TextButton(
              onPressed: () => setState(() {
                try {
                  String newValue = widget.serviceTextEditingController.text;
                  if (newValue.isNotEmpty && !widget.items.contains(newValue)) {
                    widget.items.add(newValue);
                    widget.serviceTextEditingController.clear();
                    widget.selectedValue = newValue;
                  }
                  switch (widget.type) {
                    case ServiceType.hair:
                      salonForm.hair = widget.items;
                      break;
                    case ServiceType.makeup:
                      salonForm.makeup = widget.items;
                      break;
                    case ServiceType.spa:
                      salonForm.spa = widget.items;
                      break;
                    case ServiceType.nails:
                      salonForm.nails = widget.items;
                      break;
                    case ServiceType.lashes:
                      salonForm.lashes = widget.items;
                      break;
                    case ServiceType.wax:
                      salonForm.wax = widget.items;
                      break;
                    default:
                      [];
                  }
                } catch (e) {
                  log(e.toString());
                }
              }),
              child: const Text("Add"),
            ),
            //Delete Button
            TextButton(
              onPressed: (() {
                try {
                  setState(() {
                    if (widget.items.contains(widget.selectedValue)) {
                      widget.items.remove(widget.selectedValue);
                      try {
                        widget.selectedValue = widget.items.first;
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('No Items Remain'),
                          action:
                              SnackBarAction(label: 'Close', onPressed: () {}),
                        ));
                      }
                    } else if (widget.items.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Nothing to Delete'),
                        action:
                            SnackBarAction(label: 'Close', onPressed: () {}),
                      ));
                    }
                  });
                } catch (e) {
                  log(e.toString());
                }
              }),
              child: const Text("Delete"),
            )
          ],
        )
      ],
    );
  }
}

enum ServiceType { hair, makeup, spa, nails, lashes, wax }
