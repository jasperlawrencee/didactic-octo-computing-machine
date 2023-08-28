// ignore_for_file: camel_case_types, library_private_types_in_public_api, duplicate_ignore

import 'package:flutter/material.dart';

import '../../../constants.dart';

class ServiceItems extends StatefulWidget {
  const ServiceItems({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ServiceItemsState createState() => _ServiceItemsState();
}

class _ServiceItemsState extends State<ServiceItems> {
  String? value;
  final List<String> _items = [];
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          hint: const Text("Service Type"),
          value: value,
          isExpanded: true,
          items: _items.map(buildMenuItem).toList(),
          onChanged: (value) => setState(() => this.value = value),
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
              child: const Text("Add"),
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          "Service Category\nYou may select multiple",
          textAlign: TextAlign.center,
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
        if (hair) const ServiceItems(),
        CheckboxListTile(
          value: makeup,
          onChanged: (value) {
            setState(() {
              makeup = value!;
            });
          },
          title: const Text("Makeup"),
        ),
        if (makeup) const ServiceItems(),
        CheckboxListTile(
          value: spa,
          onChanged: (value) {
            setState(() {
              spa = value!;
            });
          },
          title: const Text("Spa"),
        ),
        if (spa) const ServiceItems(),
        CheckboxListTile(
          value: nails,
          onChanged: (value) {
            setState(() {
              nails = value!;
            });
          },
          title: const Text("Nails"),
        ),
        if (nails) const ServiceItems(),
        CheckboxListTile(
          value: lashes,
          onChanged: (value) {
            setState(() {
              lashes = value!;
            });
          },
          title: const Text("Lashes"),
        ),
        if (lashes) const ServiceItems(),
        CheckboxListTile(
          value: wax,
          onChanged: (value) {
            setState(() {
              wax = value!;
            });
          },
          title: const Text("Wax"),
        ),
        if (wax) const ServiceItems(),
      ],
    );
  }
}
