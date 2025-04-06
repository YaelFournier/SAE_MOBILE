import 'package:flutter/material.dart';

Color type2color(String? type){
  switch (type) {
    case "restaurant":
      return Colors.orange;
    case "fast_food":
      return Colors.redAccent;
    case "bar":
      return Colors.pinkAccent;
    case "pub":
      return Colors.lightGreen;
    case "cafe":
      return Colors.deepOrangeAccent;
    case "ice_cream":
      return Colors.lightBlueAccent;
    default:
      return Colors.grey;
  }
