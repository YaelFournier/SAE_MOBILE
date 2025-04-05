import 'package:flutter/material.dart';
import 'package:sae_mobile/models/avis.dart';
import 'package:sae_mobile/models/user.dart';
import 'package:sae_mobile/services/avis_service.dart';
import 'package:sae_mobile/services/user_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sae_mobile/UI/avis_detail_screen.dart';

class AvisList extends StatefulWidget {
  final int restaurantId;

  const AvisList({super.key, required this.restaurantId});

  @override
  State<AvisList> createState() => _AvisListState();
}

class _AvisListState extends State<AvisList> {
  late Future<List<Avis>> _avisFuture;

  @override
  void initState() {
    super.initState();
    _refreshAvis();
  }

  Future<void> _refreshAvis() async {
    setState(() {
      _avisFuture = AvisService().getAvisByRestaurant(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshAvis,
      child: FutureBuilder<List<Avis>>(
        future: _avisFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun avis pour ce restaurant'));
          }

          final avis = snapshot.data!.take(3).toList();

          return Column(
            children: [
              ...avis.map((a) => _buildReviewItem(a, context)).toList(),
              if (snapshot.data!.length > 3)
                TextButton(
                  onPressed: () => _navigateToAllAvis(context, snapshot.data!),
                  child: const Text('Voir tous les avis'),
                ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToAllAvis(BuildContext context, List<Avis> allAvis) async {
    final shouldRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Tous les avis')),
          body: ListView.builder(
            itemCount: allAvis.length,
            itemBuilder: (context, index) {
              return _buildReviewItem(allAvis[index], context);
            },
          ),
        ),
      ),
    );

    if (shouldRefresh == true) {
      _refreshAvis();
    }
  }

  Widget _buildReviewItem(Avis avis, BuildContext context) {
    return FutureBuilder<UserSupa?>(
      future: UserService().getUserByEmail(avis.mailU),
      builder: (context, userSnapshot) {
        final userName = userSnapshot.hasData
            ? '${userSnapshot.data!.prenomU} ${userSnapshot.data!.nomU}'
            : avis.mailU.split('@').first;

        return GestureDetector(
          onTap: () async {
            final shouldRefresh = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => AvisDetailScreen(avis: avis),
              ),
            );

            if (shouldRefresh == true) {
              _refreshAvis();
            }
          },
          child: Card(
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
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: avis.note.toDouble(),
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
                  if (avis.description != null && avis.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        avis.description!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      Avis.timeSinceCreation(avis.dateA),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}