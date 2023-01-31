import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class WorkerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Responsive(mobile: MobileWorkerScreen(), desktop: Row()),
      ),
    );
  }
}

class MobileWorkerScreen extends StatefulWidget {
  @override
  _MobileWorkerScreenState createState() => _MobileWorkerScreenState();
}

class _MobileWorkerScreenState extends State<MobileWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: kPrimaryColor,
      child: SafeArea(
        child: Column(
          children: [
            top(),
            bottom(),
          ],
        ),
      ),
    );
  }

  Widget top() {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15,
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

  Widget bottom() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45),
              topRight: Radius.circular(45),
            ),
            color: Colors.white),
        child: ListView(
          padding: EdgeInsets.only(top: 35),
          physics: BouncingScrollPhysics(),
          children: [
            itemChat(
                avatar: 'assets/avatars/2.jpg',
                name: 'Jane Doe',
                chat:
                    'Lorem impsum is simply the dummy text of the printing and typesetting industry',
                time: '19:00')
          ],
        ),
      ),
    );
  }

  Widget itemChat({String avatar = '', name = '', chat = '', time = '00.00'}) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Row(children: [
        Avatar(
          margin: EdgeInsets.only(right: 20),
          size: 60,
          image: avatar,
        ),
        Expanded(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$name',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$time',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '$chat',
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            )
          ],
        ))
      ]),
    );
  }
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
