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
              serviceTextEditingController: _hairController),
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
              serviceTextEditingController: _makeupController),
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
              serviceTextEditingController: _spaController),
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
              serviceTextEditingController: _nailsController),
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
              serviceTextEditingController: _lashesController),
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
              serviceTextEditingController: _waxController)
      ],
    );
  }
}

//child widget
class ServiceItems extends StatefulWidget {
  List<String> items;
  String selectedValue;
  TextEditingController serviceTextEditingController = TextEditingController();
  ServiceItems(
      {Key? key,
      required this.items,
      required this.selectedValue,
      required this.serviceTextEditingController})
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
            items: widget.items.map(buildMenuItem).toList(),
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
              onPressed: (() {
                setState(() {
                  String newValue = widget.serviceTextEditingController.text;
                  if (newValue.isNotEmpty && widget.items.contains(newValue)) {
                    widget.items.add(newValue);
                    widget.serviceTextEditingController.clear();
                    widget.selectedValue = newValue;
                    log('added on list ${newValue}');
                  }
                });
              }),
              child: const Text("Add"),
            ),
            //Delete Button
            TextButton(
              onPressed: (() {
                setState(() {
                  if (widget.items.contains(widget.selectedValue)) {
                    widget.items.remove(widget.selectedValue);
                    widget.selectedValue = '';
                    log('deleted on list ${widget.items}');
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      );
}
