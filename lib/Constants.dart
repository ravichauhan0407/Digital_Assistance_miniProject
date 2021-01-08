import 'package:flutter/material.dart';

// Colors that we use in our app
var appColor = [Colors.teal[100], Colors.teal[200]];

const double kDefaultPadding = 20.0;

Future<Widget> errorDialogue(String message, context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
        );
      });
}

Widget appLogo() {
  return Image(image: AssetImage('assets/appLogo.JPG'));
}

List<String> kservices = [
  "Refrigerator Mechanic",
  "R.O. Mechanic",
  "Geyser Mechanic",
  "WashingMachine Mechanic",
  "Plumber",
  "Carpenter",
  "Painter",
  "Electrician"
];
