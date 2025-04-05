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
}

TimeOfDay parseTime(String timeString) {
  final parts = timeString.split(':');
  return TimeOfDay(
    hour: int.parse(parts[0]),
    minute: int.parse(parts[1]),
  );
}