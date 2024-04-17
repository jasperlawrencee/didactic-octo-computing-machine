import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomeScreens/chatBubble.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/features/firebase/chatservice.dart';
import 'package:image_picker/image_picker.dart';
import 'package:badges/badges.dart' as badges;

class ChatScreen extends StatefulWidget {
  String username;
  ChatScreen({super.key, required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();
  String currentUsername = '';
  User? currentUser = FirebaseAuth.instance.currentUser;
  File? image;
  XFile? imageRef;
  bool imageAdded = false;

  getCurrentuserid() async {
    try {
      final docRef =
          _firebaseFirestore.collection('users').doc(currentUser!.uid);
      final docSnapshot = await docRef.get();
      final username = docSnapshot.data()?['name'];
      setState(() {
        currentUsername = username;
      });
    } catch (e) {
      log('Error getting currentuser name of customer: $e');
    }
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      log("recieved by: ${widget.username} sent by $currentUsername");
      await chatService.sendMessage(widget.username, messageController.text);
      messageController.clear();
    }
  }

  void sendImage() async {
    if (!imageAdded || image.toString().isEmpty) {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference dirImages =
          referenceRoot.child('chatImages').child(currentUser!.uid);
      await dirImages.putFile(image!);
      String imageUrl = await dirImages.getDownloadURL();
      chatService.sendMessage(widget.username, imageUrl).then((value) {
        setState(() {
          imageAdded = false;
          image = null;
          imageRef = null;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentuserid();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      padding: const EdgeInsets.only(top: 45),
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
          backgroundColor: kPrimaryColor,
          title: Text(
            widget.username,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Background(
            child: Column(
          children: [Expanded(child: messageList()), messageInput()],
        )),
      )),
    );
  }

  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessages(widget.username, currentUsername),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => messageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget messageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == currentUsername)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(data['senderId']),
          ChatBubble(message: data['messageText'])
        ],
      ),
    );
  }

  Widget messageInput() {
    return Row(
      children: [
        !imageAdded
            ? Container()
            : SizedBox.square(
                dimension: 80,
                child: badges.Badge(
                  position: badges.BadgePosition.topEnd(end: 18),
                  badgeContent: const Text(
                    '-',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Image.file(image!),
                  onTap: () {
                    setState(() {
                      imageAdded = false;
                      image = null;
                      imageRef = null;
                    });
                  },
                ),
              ),
        Expanded(
            child: TextField(
          controller: messageController,
          decoration: const InputDecoration(hintText: 'Input Message'),
          obscureText: false,
        )),
        IconButton(
            onPressed: attachImage,
            icon: const Icon(
              Icons.image,
              color: kPrimaryColor,
            )),
        IconButton(
            onPressed: () {
              log('sending..');
              sendImage();
              sendMessage();
            },
            icon: const Icon(
              Icons.send,
              color: kPrimaryColor,
            )),
        Padding(padding: EdgeInsets.only(bottom: 30))
      ],
    );
  }

  Future<dynamic> attachImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text(
              "Select Image From",
              style: TextStyle(fontSize: 16),
            ),
            content: SizedBox.square(
              dimension: 80,
              // height: MediaQuery.of(context).size.height * .20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      imageRef =
                          await picker.pickImage(source: ImageSource.camera);
                      try {
                        setState(() {
                          image = File(imageRef!.path);
                          imageAdded = true;
                        });
                        log(image.toString());
                      } catch (e) {
                        log('???');
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded),
                            Text('Camera')
                          ],
                        )),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      imageRef =
                          await picker.pickImage(source: ImageSource.gallery);
                      try {
                        setState(() {
                          image = File(imageRef!.path);
                          imageAdded = true;
                        });
                        log(image.toString());
                      } catch (e) {
                        log('???');
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.image), Text('Gallery')],
                        )),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
