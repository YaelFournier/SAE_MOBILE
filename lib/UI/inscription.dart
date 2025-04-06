import 'package:flutter/material.dart';
import 'package:sae_mobile/UI/connexion.dart';
import 'package:sae_mobile/UI/home.dart';
import 'package:sae_mobile/models/user.dart';
import 'package:sae_mobile/services/user_service.dart';
import 'package:sae_mobile/viewmodels/connexion_view_model.dart';
import 'package:provider/provider.dart';

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  final UserService _userService = UserService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _inscrire() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();
    final mdp = _mdpController.text;
    final maxId = await _userService.getMaxId();

    if (nom.isEmpty || prenom.isEmpty || email.isEmpty || mdp.isEmpty) {
      setState(() {
        _errorMessage = "Tous les champs sont obligatoires";
      });
      return;
    }

    if (!RegExp(r'^.+@.+$').hasMatch(email)) {
      setState(() {
        _errorMessage = "Format d'email invalide";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = UserSupa(
        idU: maxId + 1,
        nomU: nom,
        prenomU: prenom,
        mailU: email,
        mdp: mdp,
      );

      final userId = await _userService.addUser(user);

      if (userId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription réussie !')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
            create: (context) => ConnexionViewModel(),
            child: Connexion(),
          ))
        );
      } else {
        setState(() {
          _errorMessage = "Erreur lors de l'inscription";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur: ${e.toString()}";
        if (e.toString().contains('duplicate key')) {
          _errorMessage = "Cet email est déjà utilisé";
        } else if (e.toString().contains('row-level security')) {
          _errorMessage = "Problème de permissions. Contactez l'admin.";
        }
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
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Inscription"),
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
                    "Créez un compte pour rejoindre Rest'O",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

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
                      helperText: 'Utilisation de mdp fort conseillé',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _inscrire,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.orange,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : const Text("S'inscrire"),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Connexion()),
                      );
                    },
                    child: const Text("Déjà un compte ? Connexion"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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
