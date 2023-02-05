import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Register/requirements5.dart';
import 'package:flutter_auth/Screens/Register/service_screen3-1.dart';
import 'package:flutter_auth/Screens/Register/service_screen3.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/responsive.dart';

class Certificates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileCertificates(),
          desktop: Row(),
        ),
      ),
    );
  }
}

class MobileCertificates extends StatefulWidget {
  @override
  _MobileCertificatesState createState() => _MobileCertificatesState();
}

class _MobileCertificatesState extends State<MobileCertificates> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 450,
                    child: Column(
                      children: <Widget>[
                        const Text("CERTIFICATES"),
                        nextButton(context, () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Experience();
                          }));
                        }, "Next"),
                        backButton(context, () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ServiceScreen();
                          }));
                        }, "Back")
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
