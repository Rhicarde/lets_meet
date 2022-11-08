import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.blue,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0)
  ),
);

var containerDecor = Container(
  height: 50.0,
  width: 150.0,
  decoration: BoxDecoration(
    border: Border.all(width: 2.0, color: Colors.green),
  ),
);

const textStyleHeader = TextStyle(
  fontSize: 40.0
);