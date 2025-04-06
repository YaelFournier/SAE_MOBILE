import 'package:flutter/material.dart';
import 'package:sae_mobile/UI/inscription.dart';
import 'package:sae_mobile/services/user_service.dart';
import 'package:sae_mobile/models/user.dart';

class Connexion extends StatefulWidget {
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  final UserService _userService = UserService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _connecter() async {
    final email = _emailController.text.trim();
    final mdp = _mdpController.text;

    // Vérification que l'email et le mot de passe ne sont pas vides
    if (email.isEmpty || mdp.isEmpty) {
      setState(() {
        _errorMessage = "Email et mot de passe sont obligatoires.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Cherche l'utilisateur par son email
      final user = await _userService.getUserByEmail(email);

      if (user != null && user.mdp == mdp) {
        // Si l'utilisateur existe et le mot de passe est correct
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion réussie !')),
        );

        // Reviens au Home après une connexion réussie
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pop(context); // Ferme la page de connexion et retourne à la page précédente
        });
      } else {
        setState(() {
          _errorMessage = "Email ou mot de passe incorrect.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur lors de la connexion: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

                  // Affichage du message d'erreur
                  if (_errorMessage != null) ...[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

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
                    onPressed: _isLoading ? null : _connecter,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.orange,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Se connecter"),
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
