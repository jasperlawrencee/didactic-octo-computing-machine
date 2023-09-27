// ignore_for_file: camel_case_types, library_private_types_in_public_api, duplicate_ignore, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/models/forms.dart';

import '../../../constants.dart';

//parent widget
class secondStep extends StatefulWidget {
  final WorkerForm wForm;
  const secondStep({Key? key, required this.wForm}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    TextEditingController _hairController = TextEditingController();
    TextEditingController _makeupController = TextEditingController();
    TextEditingController _spaController = TextEditingController();
    TextEditingController _nailsController = TextEditingController();
    TextEditingController _lashesController = TextEditingController();
    TextEditingController _waxController = TextEditingController();
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
            });
          },
          title: const Text("Hair"),
        ),
        if (hair)
          ServiceItems(
            items: hairValues,
            selectedValue: selectedHairValue,
            serviceTextEditingController: _hairController,
            wForm: widget.wForm,
            type: ServiceType.hair,
          ),
        CheckboxListTile(
          value: makeup,
          onChanged: (value) {
            setState(() {
              makeup = value!;
            });
          },
          title: const Text("Makeup"),
        ),
        if (makeup)
          ServiceItems(
            items: makeupValues,
            selectedValue: selectedMakeupValue,
            serviceTextEditingController: _makeupController,
            wForm: widget.wForm,
            type: ServiceType.makeup,
          ),
        CheckboxListTile(
          value: spa,
          onChanged: (value) {
            setState(() {
              spa = value!;
            });
          },
          title: const Text("Spa"),
        ),
        if (spa)
          ServiceItems(
            items: spaValues,
            selectedValue: selectedSpaValue,
            serviceTextEditingController: _spaController,
            wForm: widget.wForm,
            type: ServiceType.spa,
          ),
        CheckboxListTile(
          value: nails,
          onChanged: (value) {
            setState(() {
              nails = value!;
            });
          },
          title: const Text("Nails"),
        ),
        if (nails)
          ServiceItems(
            items: nailsValues,
            selectedValue: selectedNailsValue,
            serviceTextEditingController: _nailsController,
            wForm: widget.wForm,
            type: ServiceType.nails,
          ),
        CheckboxListTile(
          value: lashes,
          onChanged: (value) {
            setState(() {
              lashes = value!;
            });
          },
          title: const Text("Lashes"),
        ),
        if (lashes)
          ServiceItems(
            items: lashesValues,
            selectedValue: selectedLashesValue,
            serviceTextEditingController: _lashesController,
            wForm: widget.wForm,
            type: ServiceType.lashes,
          ),
        CheckboxListTile(
          value: wax,
          onChanged: (value) {
            setState(() {
              wax = value!;
            });
          },
          title: const Text("Wax"),
        ),
        if (wax)
          ServiceItems(
            items: waxValues,
            selectedValue: selectedWaxValue,
            serviceTextEditingController: _waxController,
            wForm: widget.wForm,
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
  final WorkerForm wForm;
  final ServiceType type;
  ServiceItems(
      {Key? key,
      required this.items,
      required this.selectedValue,
      required this.serviceTextEditingController,
      required this.type,
      required this.wForm})
      : super(key: key);

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
            hint: const Text("Service Type"),
            value: widget.selectedValue,
            isExpanded: true,
            items: widget.items.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) => setState(() => widget.selectedValue = value!),
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
                String newValue = widget.serviceTextEditingController.text;
                if (newValue.isNotEmpty && !widget.items.contains(newValue)) {
                  widget.items.add(newValue);
                  widget.serviceTextEditingController.clear();
                  widget.selectedValue = newValue;
                }
                switch (widget.type) {
                  case ServiceType.hair:
                    widget.wForm.hair = widget.items;
                    break;
                  case ServiceType.makeup:
                    widget.wForm.makeup = widget.items;
                    break;
                  case ServiceType.spa:
                    widget.wForm.spa = widget.items;
                    break;
                  case ServiceType.nails:
                    widget.wForm.nails = widget.items;
                    break;
                  case ServiceType.lashes:
                    widget.wForm.lashes = widget.items;
                    break;
                  case ServiceType.wax:
                    widget.wForm.wax = widget.items;
                    break;
                  default:
                }
              }),
              child: const Text("Add"),
            ),
            //Delete Button
            TextButton(
              onPressed: (() {
                setState(() {
                  if (widget.items.contains(widget.selectedValue)) {
                    widget.items.remove(widget.selectedValue);
                    try {
                      widget.selectedValue = widget.items.first;
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No Items Remain')));
                    }
                  } else if (widget.items.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nothing to Delete')));
                  }
                });
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
