import 'package:flutter/material.dart';

class Connexion extends StatefulWidget {
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();

  void _connecter() {
    final email = _emailController.text;
    final mdp = _mdpController.text;

    print("Email: $email");
    print("Mot de passe: $mdp");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connexion réussie !')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _mdpController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _connecter,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.orange,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Se connecter"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Redirection vers l'inscription
                },
                child: const Text("Pas de compte ? S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
