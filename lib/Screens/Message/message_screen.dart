import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Responsive(mobile: MobileMessageScreen(), desktop: Row()),
    ));
  }
}

class MobileMessageScreen extends StatefulWidget {
  @override
  _MobileMessageScreenState createState() => _MobileMessageScreenState();
}

class _MobileMessageScreenState extends State<MobileMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: kPrimaryColor,
      child: SafeArea(
        child: Column(
          children: [_top(), _bottom(context)],
        ),
      ),
    );
  }
}

Widget _top() {
  return Container(
    padding: EdgeInsets.only(top: 30, left: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const Text(
          "Messaging",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
        Row(
          children: [
            Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: kPrimaryLightColor),
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                      size: 25,
                    ))),
            SizedBox(
              width: defaultPadding,
            ),
            Expanded(
                child: Container(
              height: 100,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: ((context, index) {
                    return Avatar(
                      margin: EdgeInsets.only(right: 15),
                      image: 'assets/avatars/${index + 1}.jpg',
                    );
                  })),
            ))
          ],
        )
      ],
    ),
  );
}

Widget _bottom(BuildContext context) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          color: Colors.white),
    ),
  );
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;

  Avatar(
      {Key? key,
      this.size = 50,
      this.image,
      this.margin = const EdgeInsets.all(0)})
      : super(key: key);

  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(image),
            )),
      ),
    );
  }
}
