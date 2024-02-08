import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up".toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                'assets/icons/enter.svg',
                height: 220,
                width: 300,
              ),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
