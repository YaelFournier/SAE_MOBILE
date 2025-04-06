import 'package:flutter/material.dart';
import 'package:sae_mobile/UI/accueil_view.dart';
import 'package:sae_mobile/UI/resto_view.dart';
import 'package:sae_mobile/UI/inscription.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _listevue = <Widget>[AccueilView(), RestoView(), RestoView()];
  int _index = 0;
  bool _pushed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_pushed) {
      _pushed = true;
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Inscription()),
        );
      });
    }
  }

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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: "Restos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Paramètres",
          ),
        ],
      ),
    );
  }
}
