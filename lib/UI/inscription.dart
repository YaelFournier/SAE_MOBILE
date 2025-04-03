import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      version: 1,
      onOpen: (db) {
        _database = db;
      },
    );
  }

  Future<bool> _emailExiste(String email) async {
    final List<Map<String, dynamic>> users = await _database!.query(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );
    return users.isNotEmpty;
  }

  Future<void> _inscrire() async {
    final nom = _nomController.text;
    final prenom = _prenomController.text;
    final email = _emailController.text;
    final mdp = _mdpController.text;

    if (await _emailExiste(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cet email est déjà utilisé.')),
      );
      return;
    }

    await _database!.insert(
      'User',
      {'nom': nom, 'prenom': prenom, 'email': email, 'mdp': mdp},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Inscription réussie !')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscription"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prenom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),

              TextField(
                controller: _mdpController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  print("Nom: ${_nomController.text}");
                  print("Prenom: ${_prenomController.text}");
                  print("Email: ${_emailController.text}");
                  print("Mot de passe: ${_mdpController.text}");
                },
                child: Text("S'inscrire"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  textStyle: TextStyle(fontSize: 18),
                  primary: Colors.orange,
                ),
              ),
              SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  // faire la redirection
                },
                child: Text("Déjà un compte ? Connexion"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
