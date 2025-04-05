import 'package:flutter/material.dart';
import 'package:sae_mobile/models/avis.dart';
import 'package:sae_mobile/services/avis_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AvisDetailScreen extends StatefulWidget {
  final Avis avis;

  const AvisDetailScreen({super.key, required this.avis});

  @override
  State<AvisDetailScreen> createState() => _AvisDetailScreenState();
}

class _AvisDetailScreenState extends State<AvisDetailScreen> {
  late int _currentNote;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.avis.note;
    _descriptionController = TextEditingController(text: widget.avis.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'avis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteAvis,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RatingBar.builder(
              initialRating: _currentNote.toDouble(),
              minRating: 1,
              itemCount: 5,
              allowHalfRating: false,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _currentNote = rating.toInt();
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateAvis,
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateAvis() async {
    final updatedAvis = widget.avis.copyWith(
      note: _currentNote,
      description: _descriptionController.text,
    );

    await AvisService().updateAvis(updatedAvis);
    Navigator.pop(context, true); // Retour avec indication de modification
  }

  Future<void> _deleteAvis() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cet avis ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AvisService().deleteAvis(
          widget.avis.idR,
          widget.avis.mailU,
          widget.avis.dateA
      );
      Navigator.pop(context, true); // Retour avec indication de suppression
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}