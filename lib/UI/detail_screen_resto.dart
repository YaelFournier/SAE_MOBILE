import 'package:flutter/material.dart';
import 'package:sae_mobile/models/resto.dart';
import 'package:sae_mobile/models/avis.dart';
import 'package:sae_mobile/services/avis_service.dart';
import 'package:sae_mobile/UI/photo_picker.dart';
import 'package:sae_mobile/UI/horaires_list.dart';
import 'package:sae_mobile/UI/avis_list.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sae_mobile/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/viewmodels/connexion_view_model.dart';


class DetailScreenResto extends StatelessWidget {
  const DetailScreenResto({super.key, required this.resto});

  final Resto resto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(resto.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCuisineSection(),
            _buildRestaurantInfoSection(),
            const SizedBox(height: 24),
            PhotoPicker(resto: resto),
            const SizedBox(height: 24),
            AvisList(restaurantId: resto.id),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReviewDialog(context);
        },
        tooltip: 'Ajouter un avis',
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildCuisineSection() {
    if (resto.cuisines == null || resto.cuisines!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Types de cuisine:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: resto.cuisines!.map((cuisine) => Chip(
              label: Text(cuisine.nameC),
              backgroundColor: Colors.orange[100],
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (resto.brand != null)
          Text(
            'Chaîne: ${resto.brand}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.phone, resto.phone ?? 'Non renseigné'),
        _buildInfoRow(Icons.public, resto.website ?? 'Non renseigné'),
        _buildInfoRow(Icons.accessible, resto.wheelchair ?? 'Accessibilité non renseignée'),

        const SizedBox(height: 16),
        const Text('Horaires:', style: TextStyle(fontWeight: FontWeight.bold)),
        HorairesList(restaurantId: resto.id),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) async {
    int user_id = context.read<ConnexionViewModel>().getUserId;
    int note = 1;
    final descriptionController = TextEditingController();

    final connectedUser = await UserService().getUserById(user_id);
    if (connectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilisateur par défaut introuvable')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un avis'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  note = rating.toInt();
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Votre avis (optionnel)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(

              onPressed: () async {
                final avis = Avis(
                  idR: resto.id,
                  mailU: connectedUser.mailU,
                  note: note,
                  description: descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : null,
                  dateA: DateTime.now(),
                );

                await AvisService().addAvis(avis);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Avis ajouté avec succès')),
                );
              },
              child: const Text('Publier'),
            ),
          ],
        );
      },
    );
  }
}