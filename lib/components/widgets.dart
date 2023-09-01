import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

TextFormField textField(
  String text,
  IconData icon,
  bool isPasswordType,
  TextEditingController controller,
) {
  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty) return 'This field cannot be empty';
      return null;
    },
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

TextField flatTextField(String text, TextEditingController controller,
    {void Function(String)? onchanged}) {
  return TextField(
    onChanged: onchanged,
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
