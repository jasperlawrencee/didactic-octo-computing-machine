// ignore_for_file: camel_case_types, library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/experience.dart';
import 'package:intl/intl.dart';

class thirdStep extends StatefulWidget {
  const thirdStep({Key? key}) : super(key: key);

  @override
  _thirdStepState createState() => _thirdStepState();
}

int index = 0;

class _thirdStepState extends State<thirdStep> {
  List<String> salonRegistered = <String>[];
  List<String> addedSalon = <String>[];
  List<Widget> widgets = [];
  String salonValue = '';
  String addedValue = '';
  bool experience = false;

  @override
  void initState() {
    getSalonRegistered();
    super.initState();
  }

  Future<List<String>> getSalonRegistered() async {
    List<String> salonNames = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'salon')
          .get();
      querySnapshot.docs.forEach((element) {
        salonNames.add(element['name']);
      });
      log(salonNames.toString());
    } catch (e) {
      log(e.toString());
    }
    return salonNames;
  }

  @override
  Widget build(BuildContext context) {
    if (workerForm.experiences.isEmpty) {
      workerForm.experiences.add(Experience());
    }
    return Column(
      children: [
        const Text(
          "Experiences\n(Optional)",
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Currently Employed',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Check if salon or parlor is listed',
                ),
              ],
            ),
            Checkbox(
              value: experience,
              onChanged: (value) {
                setState(() {
                  experience = value!;
                });
              },
            )
          ],
        ),
        if (experience == false)
          Column(
            children: [
              ExperienceSection(),
              const SizedBox(height: defaultPadding),
              Column(
                children: widgets,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widgets.add(ExperienceSection());
                        workerForm.experiences.add(Experience());
                        index++;
                        log(index.toString());
                      });
                    },
                    child: const Text("Add More+"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        try {
                          // ignore: unrelated_type_equality_checks
                          widgets != 0 ? widgets.removeLast() : null;
                          index--;
                          workerForm.experiences.removeLast();
                          log(index.toString());
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Unable to delete field')));
                        }
                      });
                    },
                    child: const Text("Delete Section"),
                  ),
                ],
              ),
            ],
          ),
        if (experience == true)
          Column(
            children: [
              const SizedBox(height: defaultPadding),
              //Dropdown of Salons to Add
              SizedBox(
                child: Theme(
                  data: ThemeData(canvasColor: Colors.white),
                  child: DropdownButton<String>(
                    hint: const Text('Added Items'),
                    isExpanded: true,
                    value: addedValue.isEmpty ? null : addedValue,
                    items: addedSalon.isNotEmpty
                        ? addedSalon
                            .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList()
                        : <DropdownMenuItem<String>>[],
                    onChanged: (String? value) {
                      try {
                        setState(() {
                          addedValue = value!;
                        });
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                  ),
                ),
              ),
              //Dropdown of Registered Salons
              Row(
                children: [
                  Expanded(
                    child: Theme(
                      data: ThemeData(canvasColor: Colors.white),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('Salon Registered'),
                        value: salonValue.isEmpty ? null : salonValue,
                        items: salonRegistered.isNotEmpty
                            ? salonRegistered
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : <DropdownMenuItem<String>>[],
                        onChanged: (String? value) {
                          setState(() {
                            try {
                              salonValue = value!;
                            } catch (e) {
                              log(e.toString());
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        try {
                          String newValue = salonValue;
                          if (newValue.isNotEmpty &&
                              addedValue.contains(newValue)) {
                            addedSalon.add(newValue);
                            addedValue = newValue;
                          }
                          log(addedSalon.toString());
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      child: const Text('Add')),
                  TextButton(onPressed: () {}, child: const Text('Delete')),
                ],
              )
            ],
          )
      ],
    );
  }
}

// ignore: must_be_immutable
class ExperienceSection extends StatefulWidget {
  ExperienceSection({
    Key? key,
  }) : super(key: key);

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  String dateString = '02-27-2002';
  TextEditingController salonName = TextEditingController();
  TextEditingController salonAddress = TextEditingController();
  TextEditingController salonNum = TextEditingController();
  DateTimeRange selectedDays =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  void initState() {
    super.initState();
    try {
      salonName.addListener(() {
        workerForm.experiences[index].name = salonName.text;
      });
      salonAddress.addListener(() {
        workerForm.experiences[index].address = salonAddress.text;
      });
      salonNum.addListener(() {
        workerForm.experiences[index].contactNum = salonNum.text;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        flatTextField("Salon Name", salonName),
        flatTextField("Salon Address", salonAddress),
        flatTextField("Salon Contact Number", salonNum),
        const SizedBox(height: defaultPadding),
        Column(
          children: [
            Text(
                "${DateFormat.yMMMd().format(selectedDays.start)} to ${DateFormat.yMMMd().format(selectedDays.end)}"),
            ElevatedButton(
              child: const Text('Select Dates'),
              onPressed: () async {
                final DateTimeRange? dateTimeRange = await showDateRangePicker(
                    initialEntryMode: DatePickerEntryMode.inputOnly,
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2500));
                if (dateTimeRange != null) {
                  setState(() {
                    selectedDays = dateTimeRange;
                    //temporary
                    workerForm.experiences[index].date =
                        "${DateFormat.yMMMd().format(selectedDays.start)} to ${DateFormat.yMMMd().format(selectedDays.end)}";
                  });
                } else {
                  log('no dates selected');
                }
              },
            )
          ],
        )
      ],
    );
  }
}
