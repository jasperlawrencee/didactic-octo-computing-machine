import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class Applications extends StatefulWidget {
  const Applications({Key? key}) : super(key: key);

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  List<String> type = ['All', 'Salon', 'Freelancer'];
  List<String> verification = ['Unverified', 'Verified'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Theme(
        data: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: kPrimaryColor,
                  secondary: kPrimaryLightColor,
                )),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Sort by: '),
                DropdownMenu(
                    initialSelection: type[0],
                    dropdownMenuEntries:
                        type.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList()),
                const SizedBox(width: defaultPadding),
                DropdownMenu(
                    initialSelection: verification[0],
                    dropdownMenuEntries: verification
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
