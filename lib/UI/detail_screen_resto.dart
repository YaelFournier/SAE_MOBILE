import 'package:flutter/material.dart';
import 'package:sae_mobile/models/resto.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sae_mobile/UI/photo_picker.dart';

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
            _buildRestaurantInfoSection(),
            const SizedBox(height: 24),

            PhotoPicker(resto: resto),
            const SizedBox(height: 24),

            _buildReviewsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReviewDialog(context);
        },
        child: const Icon(Icons.add_comment),
        tooltip: 'Ajouter un avis',
      ),
    );
  }

  Widget _buildRestaurantInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        if (resto.brand != null) Text('Chaîne: ${resto.brand}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),),

        const SizedBox(height: 12),

        _buildInfoRow(Icons.phone, resto.phone ?? 'Non renseigné'),
        _buildInfoRow(Icons.public, resto.website ?? 'Non renseigné'),
        //_buildInfoRow(Icons.access_time, resto.openingHours ?? 'Horaires non renseignés'),
        _buildInfoRow(Icons.accessible, resto.wheelchair ?? 'Accessibilité non renseignée'),

        const SizedBox(height: 12),

        //if (resto.cuisine != null && resto.cuisine!.isNotEmpty) Wrap(spacing: 8, children: resto.cuisine!.map((cuisine) => Chip(label: Text(cuisine),backgroundColor: Colors.orange[100],)).toList(),),
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


  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avis',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildReviewItem('Username', 3, 'Avis'),
        TextButton(
          onPressed: () {
            // Voir tous les avis
          },
          child: const Text('Voir tous les avis'),
        ),
      ],
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                RatingBar.builder(
                  initialRating: rating.toDouble(),
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 20,
                  ignoreGestures: true,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
            Text(comment),
            const Text(
              'Il y a x temps.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un avis'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Votre avis',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Sauvegarder l'avis
                Navigator.pop(context);
              },
              child: const Text('Publier'),
            ),
          ],
        );
      },
    );
  }
}