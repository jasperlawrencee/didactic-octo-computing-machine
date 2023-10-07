import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

class Summary extends StatefulWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Background(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            const Text(
              'Summary',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            const Text(
              'User Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'First Name',
                ),
                Text(workerForm.firstName.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Middle Name',
                ),
                Text(workerForm.middleName.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Last Name',
                ),
                Text(workerForm.lastName.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Gender',
                ),
                Text(workerForm.gender.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            const Text(
              'Contact Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Primary Phone Number',
                ),
                Text(workerForm.phoneNum1.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Secondary Phone Number',
                ),
                Text(workerForm.phoneNum2.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            const Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'City',
                ),
                Text(workerForm.city.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Barangay',
                ),
                Text(workerForm.barangay.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Street Address',
                ),
                Text(workerForm.stAddress.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Extended Address',
                ),
                Text(workerForm.extAddress.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            const Text(
              'Service Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            if (workerForm.isHairClicked && workerForm.hair.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('Hair'), showServices(context)],
              ),
            const Text(
              'Experiences',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Salon Name',
                ),
                Text(workerForm.experienceName.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Salon Address',
                ),
                Text(workerForm.experienceAddress.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Salon Contact Number',
                ),
                Text(workerForm.experienceNum.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Duration',
                ),
                Text(workerForm.selectedDays.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            const Text(
              'Pictures',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Government ID',
                ),
                InkWell(
                  onTap: () {
                    showImage(workerForm.governmentID);
                  },
                  child: const Text(
                    'Preview',
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vaccination Card/Certificate',
                ),
                InkWell(
                  onTap: () {
                    showImage(workerForm.vaxCard);
                  },
                  child: const Text(
                    'Preview',
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'NBI Clearnace',
                ),
                InkWell(
                  onTap: () {
                    showImage(workerForm.nbiClearance);
                  },
                  child: const Text(
                    'Preview',
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Certificates',
                ),
                InkWell(
                  onTap: () {
                    workerForm.certificates!.isNotEmpty
                        ? showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: SizedBox(
                                  width: MediaQuery.of(context).size.width / 1,
                                  height:
                                      MediaQuery.of(context).size.height / 1,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          workerForm.certificates!.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            Image.file(File(workerForm
                                                .certificates![index].path)),
                                            Container(height: 1),
                                          ],
                                        );
                                      }),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'))
                                ],
                              );
                            })
                        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                              'No image(s) provided',
                            ),
                            action: SnackBarAction(
                                label: 'Close', onPressed: () {}),
                          ));
                  },
                  child: const Text(
                    'Preview',
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(height: defaultPadding),
            nextButton(context, () {}, 'Confirm'),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    ));
  }

  InkWell showServices(BuildContext context) {
    return InkWell(
      onTap: () {
        workerForm.hair.isNotEmpty
            ? showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width / 1,
                      height: MediaQuery.of(context).size.height / 4,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: workerForm.hair.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Text(workerForm.hair[index]),
                              Container(height: defaultPadding),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                })
            : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'No image(s) provided',
                ),
                action: SnackBarAction(label: 'Close', onPressed: () {}),
              ));
      },
      child: Text(
        'View',
        style: TextStyle(
            color: kPrimaryColor, decoration: TextDecoration.underline),
      ),
    );
  }

  showImage(File? image) {
    if (image != null) {
      showDialog(
          context: context,
          builder: ((context) {
            return Theme(
              data: ThemeData(
                  canvasColor: Colors.transparent,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: kPrimaryColor,
                        background: Colors.white70,
                        secondary: kPrimaryLightColor,
                      )),
              child: AlertDialog(
                content: Image.file(image),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'))
                ],
              ),
            );
          }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('No image provided'),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
    }
  }
}
