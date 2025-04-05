import 'package:flutter/material.dart';
import 'package:sae_mobile/UI/connexion.dart';
import 'package:sae_mobile/UI/home.dart';  // Assurez-vous que Home est bien importé

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();

  void _inscrire() {
    final nom = _nomController.text;
    final prenom = _prenomController.text;
    final email = _emailController.text;
    final mdp = _mdpController.text;

    print("Nom: $nom");
    print("Prénom: $prenom");
    print("Email: $email");
    print("Mot de passe: $mdp");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inscription réussie !')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Empêche le retour avec le bouton Android
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Enlève la flèche retour
          title: const Text("Inscription"),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350), // Champs + étroits
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Créez un compte pour rejoindre Rest'O",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _prenomController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                    onPressed: _inscrire,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.orange,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("S'inscrire"),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Connexion()),
                      );
                    },
                    child: const Text("Déjà un compte ? Connexion"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Faire un pop pour revenir au Home
                      Navigator.pop(context); // Reviens à la page précédente (Home)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Choisis la couleur que tu veux
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("Retour au Home"),
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
