import 'package:flutter/material.dart';
import 'package:sae_mobile/UI/resto_view.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _listevue = <Widget>[RestoView(), RestoView()];

  int _index = 0;

  void _onItemTapped(int currentindex) {
    setState(() {
      _index = currentindex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rest'O"),
        centerTitle: true,
      ),
      body: _listevue[_index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label: "Restos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Paramètres",
            ),
          ]),
    );
  }
}