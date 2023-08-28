import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class WorkerScreen extends StatelessWidget {
  const WorkerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Responsive(mobile: MobileWorkerScreen(), desktop: Row()),
      ),
    );
  }
}

class MobileWorkerScreen extends StatefulWidget {
  const MobileWorkerScreen({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome Louise!",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                  child: SizedBox(
                height: 100,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: ((context, index) {
                      return Avatar(
                        margin: const EdgeInsets.only(right: 15),
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
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45),
              topRight: Radius.circular(45),
            ),
            color: Colors.white),
        child: ListView(
          padding: const EdgeInsets.only(top: 35),
          physics: const BouncingScrollPhysics(),
          children: [
            itemChat(
                avatar: 'assets/avatars/3.jpg',
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => const ChatPage())));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Row(children: [
          Avatar(
            margin: const EdgeInsets.only(right: 20),
            size: 60,
            image: avatar,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$name',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$time',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '$chat',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              )
            ],
          ))
        ]),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;

  const Avatar(
      {Key? key,
      this.size = 50,
      this.image,
      this.margin = const EdgeInsets.all(0)})
      : super(key: key);

  @override
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

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Stack(children: [
          Column(
            children: [
              topChat(),
              bottomChat(),
            ],
          ),
          formChat(),
        ]),
      ),
    );
  }

  Widget topChat() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Jane Doe',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.call,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.video_call,
                  size: 25,
                  color: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget bottomChat() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          color: Colors.white,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            itemChat(
                avatar: 'assets/avatars/5.jpg',
                chat: 1,
                message:
                    'Lorem impsum is simply the dummy text of the printing and typesetting industry',
                time: '18:00'),
            itemChat(
                avatar: 'assets/avatars/5.jpg',
                chat: 0,
                message:
                    'Lorem impsum is simply the dummy text of the printing and typesetting industry',
                time: '18:00'),
            itemChat(
                avatar: 'assets/avatars/5.jpg',
                chat: 1,
                message: "Okay po, I'll book the transaction",
                time: '19:00'),
          ],
        ),
      ),
    );
  }

  // if chat = 0 : Send
  // if chat = 1 : Recieved
  Widget itemChat({required int chat, required String avatar, message, time}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        chat == 1
            ? Avatar(
                image: avatar,
                size: 50,
              )
            : Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: chat == 0 ? kPrimaryLightColor : Colors.indigo.shade50,
                borderRadius: chat == 0
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
            child: Text('$message'),
          ),
        ),
        chat == 1
            ? Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              )
            : const SizedBox()
      ],
    );
  }

  Widget formChat() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 120,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: kPrimaryLightColor,
              labelStyle: const TextStyle(
                fontSize: 12,
              ),
              contentPadding: const EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: kPrimaryLightColor),
                  borderRadius: BorderRadius.circular(25)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: kPrimaryLightColor),
                  borderRadius: BorderRadius.circular(25)),
              prefixIcon: Container(
                child: const Icon(Icons.add),
              ),
              suffixIcon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kPrimaryColor,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
