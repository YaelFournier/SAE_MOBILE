import 'package:flutter/material.dart';
import 'package:sae_mobile/models/resto.dart';

class DetailScreenResto extends StatelessWidget {
  const DetailScreenResto({super.key, required this.resto});

  final Resto resto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(resto.name)),
    );
  }
}