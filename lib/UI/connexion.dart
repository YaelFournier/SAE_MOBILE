import 'package:flutter/material.dart';
import 'package:sae_mobile/UI/inscription.dart';

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

    // revient au home après la connexion
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Empêche retour via bouton Android
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Connexion"),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Connectez-vous pour accéder à Rest'O",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Inscription()),
                      );
                    },
                    child: const Text("Pas de compte ? S'inscrire"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
