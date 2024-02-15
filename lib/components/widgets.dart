// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/constants.dart';

TextFormField textField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller,
    {bool? emailType}) {
  return TextFormField(
    validator: emailType == false
        ? (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty';
            }
            if (value.length < 3) {
              return '$text must be at least 3 characters long';
            }
            return null;
          }
        : null,
    controller: controller,
    obscureText: isPasswordType,
    style: const TextStyle(
      fontSize: 13,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
    ),
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    cursorColor: kPrimaryColor,
    decoration: InputDecoration(
      hintText: text,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Icon(icon),
      ),
    ),
  );
}

TextFormField flatTextField(
  String text,
  TextEditingController? controller,
) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter text';
      }
      return null;
    },
    style: const TextStyle(
      fontSize: 13,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
    ),
    cursorColor: kPrimaryColor,
    decoration: InputDecoration(
      hintText: text,
    ),
  );
}

Container nextButton(BuildContext context, Function onTap, String text) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

Container backButton(BuildContext context, Function onTap, String text) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

Container addImage(BuildContext context, String label) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
      color: kPrimaryLightColor,
    ),
    child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          padding: const EdgeInsets.all(defaultPadding),
        ),
        onPressed: () {},
        child: Text(
          label,
          style: const TextStyle(color: Colors.black),
        )),
  );
}

SizedBox logOutButton(BuildContext context) {
  return SizedBox(
    child: InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Theme(
                  data: ThemeData(
                      canvasColor: Colors.transparent,
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: kPrimaryColor,
                            background: Colors.white,
                            secondary: kPrimaryLightColor,
                          )),
                  child: AlertDialog(
                    title: const Text("Confirm Logout?"),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Logged Out")));
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }), (route) => route.isFirst);
                          } catch (e) {
                            log('error: $e');
                          }
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ));
            });
      },
      child: const Icon(
        Icons.logout,
        color: kPrimaryColor,
      ),
    ),
  );
}
