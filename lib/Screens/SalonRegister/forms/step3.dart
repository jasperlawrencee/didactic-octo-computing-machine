// ignore_for_file: camel_case_types, library_private_types_in_public_api, duplicate_ignore, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/SalonRegister/register_stepper.dart';
import 'package:flutter_auth/models/servicenames.dart';

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

  final List<String> hairServices = ServiceNames().hairServices;
  final List<String> makeupServices = ServiceNames().makeupServices;
  final List<String> spaServices = ServiceNames().spaServices;
  final List<String> nailsServices = ServiceNames().nailsServices;
  final List<String> lashesServices = ServiceNames().lashesServices;
  final List<String> waxServices = ServiceNames().waxServices;

  String selectedHairValue = '';
  String enterHairValue = '';
  String selectedMakeupValue = '';
  String enterMakeupValue = '';
  String selectedSpaValue = '';
  String enterSpaValue = '';
  String selectedNailsValue = '';
  String enterNailsValue = '';
  String selectedLashesValue = '';
  String enterLashesValue = '';
  String selectedWaxValue = '';
  String enterWaxValue = '';

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
        //////////////////////////HAIR//////////////////////////////
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
              enterServices: hairServices,
              selectedValue: selectedHairValue,
              enterValue: enterHairValue,
              type: ServiceType.hair),
        //////////////////////////MAKEUP//////////////////////////////
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
              enterServices: makeupServices,
              selectedValue: selectedMakeupValue,
              enterValue: enterMakeupValue,
              type: ServiceType.makeup),
        //////////////////////////SPA//////////////////////////////
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
              enterServices: spaServices,
              selectedValue: selectedSpaValue,
              enterValue: enterSpaValue,
              type: ServiceType.spa),
        //////////////////////////NAILS//////////////////////////////
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
              enterServices: nailsServices,
              selectedValue: selectedNailsValue,
              enterValue: enterNailsValue,
              type: ServiceType.nails),
        //////////////////////////LASHES//////////////////////////////
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
              enterServices: lashesServices,
              selectedValue: selectedLashesValue,
              enterValue: enterLashesValue,
              type: ServiceType.lashes),
        //////////////////////////WAX//////////////////////////////
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
              enterServices: waxServices,
              selectedValue: selectedWaxValue,
              enterValue: enterWaxValue,
              type: ServiceType.wax),
        const SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }
}

//child widget
class ServiceItems extends StatefulWidget {
  List<String> items;
  List<String> enterServices;
  String selectedValue;
  String enterValue;
  final ServiceType type;
  ServiceItems({
    Key? key,
    required this.items,
    required this.enterServices,
    required this.selectedValue,
    required this.enterValue,
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
                //Dropdown For Specific Services Type
                child: Theme(
              data: ThemeData(canvasColor: Colors.white),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text(
                  "Specific Service",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                value: widget.enterValue.isEmpty ? null : widget.enterValue,
                items: widget.enterServices.isNotEmpty
                    ? widget.enterServices
                        .map<DropdownMenuItem<String>>((item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList()
                    : <DropdownMenuItem<String>>[],
                onChanged: (value) => setState(() {
                  try {
                    widget.enterValue = value!;
                  } catch (e) {
                    log(e.toString());
                  }
                }),
              ),
            )),
            //Add Button
            TextButton(
              onPressed: () => setState(() {
                try {
                  String newValue = widget.enterValue;
                  if (newValue.isNotEmpty && !widget.items.contains(newValue)) {
                    widget.items.add(newValue);
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
