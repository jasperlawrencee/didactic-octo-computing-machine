// ignore_for_file: camel_case_types, library_private_types_in_public_api, duplicate_ignore, must_be_immutable, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';

import '../../../constants.dart';

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

  final TextEditingController _hairController = TextEditingController();
  final TextEditingController _makeupController = TextEditingController();
  final TextEditingController _spaController = TextEditingController();
  final TextEditingController _nailsController = TextEditingController();
  final TextEditingController _lashesController = TextEditingController();
  final TextEditingController _waxController = TextEditingController();

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

  List<String> hairServices = <String>[
    'Haircut',
    'Hair Color',
    'Highlights',
    'Balayage',
    'Ombre',
    'Hair Extensions',
    'Perms',
    'Straightening/Relaxing',
    'Keratin Treatment',
    'Scalp Treatment',
    'Deep Conditioning',
    'Hair Styling',
    'Updos',
    'Braiding',
    'Beard Trim',
    'Shaving',
    'Hair and Scalp Massage',
    'Hair Threading',
    'Hair Glossing',
    'Hair Glazing',
  ];
  List<String> makeupServices = <String>[
    'Makeup Application',
    'Bridal Makeup',
    'Airbrush Makeup',
    'Special Effects Makeup',
    'Editorial/Fashion Makeup',
    'Glamour Makeup',
    'Natural Makeup',
    'Evening Makeup',
    'Prom Makeup',
    'Pageant Makeup',
    'Stage Makeup',
    'Photoshoot Makeup',
    'TV/Film Makeup',
    'Theatrical Makeup',
    'Fantasy Makeup',
    'Face Painting',
    'Makeup Lessons/Tutorials',
    'Makeup Consultations',
  ];
  List<String> spaServices = <String>[
    'Massage Therapy',
    'Body Scrub',
    'Hydrotherapy',
    'Reflexology',
    'Reiki',
    'Acupuncture',
    'Cupping Therapy',
    'Aromatherapy',
    'Meditation and Mindfulness',
    'Body Contouring',
    'Ear Candling',
    'Holistic Healing',
  ];
  List<String> nailsServices = <String>[
    'Manicure',
    'Pedicure',
    'Nail Extensions',
    'Nail Art',
    'Nail Repair',
    'Nail Removal',
    'Nail Buffing and Shaping',
    'Cuticle Care',
    'Nail Whitening',
    'Nail Strengthening',
    'Nail Hardening',
    'Nail Conditioning',
    'Nail Polish Applications',
    'Nail Polish Removal',
    'Paraffin Wax Treatment for Hands and Feet',
    'Moisturizing Treatments',
    'Nail and Cuticle Oil Application',
    'Nail Extensions Refill',
    'Nail Design Consultations',
  ];
  List<String> lashesServices = <String>[
    'Eyelash Extensions',
    'Lash Lift',
    'Lash Tinting',
    'Eyelash Removal',
    'Eyelash Refills',
    'Eyelash Extension Correction',
    'Eyelash Extension Consultations',
    'Bottom Lash Extensions',
    'Eyelash Extension Removal',
    'Lash Health Treatments',
    'Eyelash Serum Application',
    'Lash Growth Treatments',
    'Eyelash Extension Aftercare Instructions',
    'Eyelash Extension Fills',
    'Eyelash Extension Touch-ups',
    'Custom Eyelash Design',
  ];
  List<String> waxServices = <String>[
    'Eyebrow Waxing',
    'Lip Waxing',
    'Chin Waxing',
    'Full Face Waxing',
    'Underarm Waxing',
    'Arm Waxing',
    'Leg Waxing',
    'Bikini Waxing',
    'Chest Waxing',
    'Back Waxing',
    'Stomach Waxing',
    'Shoulder Waxing',
    'Neck Waxing',
    'Buttocks Waxing',
    'Nose Waxing',
    'Ear Waxing',
    'Full Body Waxing',
    'Male Waxing Services',
    'Female Intimate Waxing',
  ];

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
              serviceTextEditingController: _hairController,
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
              serviceTextEditingController: _makeupController,
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
              serviceTextEditingController: _spaController,
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
              serviceTextEditingController: _nailsController,
              type: ServiceType.nails),
        ////////////LASHES////////////////////
        CheckboxListTile(
          value: lashes,
          onChanged: (value) {
            setState(() {
              lashes = value!;
              workerForm.isNailsClicked = value;
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
              serviceTextEditingController: _lashesController,
              type: ServiceType.lashes),
        ////////////WAX////////////////////
        CheckboxListTile(
          value: wax,
          onChanged: (value) {
            setState(() {
              wax = value!;
              workerForm.isNailsClicked = value;
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
              serviceTextEditingController: _waxController,
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
  TextEditingController serviceTextEditingController = TextEditingController();
  final ServiceType type;
  ServiceItems({
    Key? key,
    required this.addedServices,
    required this.enterServices,
    required this.addedValue,
    required this.enterValue,
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
                    widget.serviceTextEditingController.clear();
                    widget.addedValue = newValue;
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
