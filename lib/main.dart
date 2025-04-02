import 'package:flutter/material.dart';
import 'package:sae_mobile/UI/home.dart';

void main() {
  runApp( Rest_O());
}

class Rest_O extends StatelessWidget {
  Rest_O({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Rest'O",
        home: Home()
    );
  }
}
