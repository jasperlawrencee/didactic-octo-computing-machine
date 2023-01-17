import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class Services extends StatelessWidget {
  final String svcType;
  final Function? press;

  const Services({Key? key, this.press, required this.svcType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: press as void Function()?,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            width: 70,
            height: 70,
            // padding: const EdgeInsets.all(20),
            color: kPrimaryColor,
            child: Center(
              child: Text(
                svcType,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }
}
