// ignore_for_file: camel_case_types, library_private_types_in_public_api, duplicate_ignore, must_be_immutable, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';

import '../../../constants.dart';
import '../../../models/servicenames.dart';

//parent widget
class secondStep extends StatefulWidget {
  const secondStep({Key? key}) : super(key: key);

  @override
  _secondStepState createState() => _secondStepState();
}

class _secondStepState extends State<secondStep> {
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
        const SizedBox(
          height: defaultPadding,
        ),
        ////////////HAIR////////////////////
        CheckboxListTile(
          value: hair,
          onChanged: (value) {
            setState(() {
              hair = value!;
              workerForm.isHairClicked = value;
            });
          },
          title: const Text("Hair"),
        ),
        if (hair)
          ServiceItems(
              addedServices: hairValues,
              enterServices: hairServices,
              addedValue: selectedHairValue,
              enterValue: enterHairValue,
              type: ServiceType.hair),
        ////////////MAKEUP////////////////////
        CheckboxListTile(
          value: makeup,
          onChanged: (value) {
            setState(() {
              makeup = value!;
              workerForm.isMakeupClicked = value;
            });
          },
          title: const Text("Makeup"),
        ),
        if (makeup)
          ServiceItems(
              addedServices: makeupValues,
              enterServices: makeupServices,
              addedValue: selectedMakeupValue,
              enterValue: enterMakeupValue,
              type: ServiceType.makeup),
        ////////////SPA////////////////////
        CheckboxListTile(
          value: spa,
          onChanged: (value) {
            setState(() {
              spa = value!;
              workerForm.isSpaClicked = value;
            });
          },
          title: const Text("Spa"),
        ),
        if (spa)
          ServiceItems(
              addedServices: spaValues,
              enterServices: spaServices,
              addedValue: selectedSpaValue,
              enterValue: enterSpaValue,
              type: ServiceType.spa),
        ////////////NAILS////////////////////
        CheckboxListTile(
          value: nails,
          onChanged: (value) {
            setState(() {
              nails = value!;
              workerForm.isNailsClicked = value;
            });
          },
          title: const Text("Nails"),
        ),
        if (nails)
          ServiceItems(
              addedServices: nailsValues,
              enterServices: nailsServices,
              addedValue: selectedNailsValue,
              enterValue: enterNailsValue,
              type: ServiceType.nails),
        ////////////LASHES////////////////////
        CheckboxListTile(
          value: lashes,
          onChanged: (value) {
            setState(() {
              lashes = value!;
              workerForm.isLashesClicked = value;
            });
          },
          title: const Text("Lashes"),
        ),
        if (lashes)
          ServiceItems(
              addedServices: lashesValues,
              enterServices: lashesServices,
              addedValue: selectedLashesValue,
              enterValue: enterLashesValue,
              type: ServiceType.lashes),
        ////////////WAX////////////////////
        CheckboxListTile(
          value: wax,
          onChanged: (value) {
            setState(() {
              wax = value!;
              workerForm.isWaxClicked = value;
            });
          },
          title: const Text("Wax"),
        ),
        if (wax)
          ServiceItems(
              addedServices: waxValues,
              enterServices: waxServices,
              addedValue: selectedWaxValue,
              enterValue: enterWaxValue,
              type: ServiceType.wax),
      ],
    );
  }
}

//child widget
class ServiceItems extends StatefulWidget {
  List<String> addedServices;
  List<String> enterServices;
  String enterValue;
  String addedValue;
  final ServiceType type;
  ServiceItems({
    Key? key,
    required this.addedServices,
    required this.enterServices,
    required this.addedValue,
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
        //Dropdown For Added Services
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
            value: widget.addedValue.isEmpty ? null : widget.addedValue,
            isExpanded: true,
            //List of Added Items
            items: widget.addedServices.isNotEmpty
                ? widget.addedServices.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList()
                : <DropdownMenuItem<String>>[],
            onChanged: (value) => setState(() {
              try {
                widget.addedValue = value!;
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
                  if (newValue.isNotEmpty &&
                      !widget.addedServices.contains(newValue)) {
                    widget.addedServices.add(newValue);
                    widget.addedValue = newValue;
                  } else if (widget.addedServices.contains(newValue)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Item Already Added'),
                      action: SnackBarAction(label: 'Close', onPressed: () {}),
                    ));
                  }
                  switch (widget.type) {
                    case ServiceType.hair:
                      workerForm.hair = widget.addedServices;
                      break;
                    case ServiceType.makeup:
                      workerForm.makeup = widget.addedServices;
                      break;
                    case ServiceType.spa:
                      workerForm.spa = widget.addedServices;
                      break;
                    case ServiceType.nails:
                      workerForm.nails = widget.addedServices;
                      break;
                    case ServiceType.lashes:
                      workerForm.lashes = widget.addedServices;
                      break;
                    case ServiceType.wax:
                      workerForm.wax = widget.addedServices;
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
                    if (widget.addedServices.contains(widget.addedValue)) {
                      widget.addedServices.remove(widget.addedValue);
                      try {
                        widget.addedValue = widget.addedServices.first;
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('No Items Remain'),
                          action:
                              SnackBarAction(label: 'Close', onPressed: () {}),
                        ));
                      }
                    } else if (widget.addedServices.isEmpty) {
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
