import 'package:flutter/material.dart';

Widget loader() {
  return const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'Please Wait',
        style: TextStyle(fontFamily: 'MontMed', fontSize: 14),
      ),
    ],
  );
}
