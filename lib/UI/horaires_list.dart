import 'package:flutter/material.dart';
import 'package:sae_mobile/models/horaire.dart';
import 'package:sae_mobile/services/horaire_service.dart';

class HorairesList extends StatefulWidget {
  final int restaurantId;

  const HorairesList({super.key, required this.restaurantId});

  @override
  State<HorairesList> createState() => _HorairesListState();
}

class _HorairesListState extends State<HorairesList> {
  late Future<List<Horaire>> _horairesFuture;

  @override
  void initState() {
    super.initState();
    _horairesFuture = HoraireService().getHorairesByRestaurant(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Horaire>>(
      future: _horairesFuture,
      builder: (context, snapshot) {
        // Debug visible
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 20,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (snapshot.hasError) {
          debugPrint('Erreur horaires: ${snapshot.error}');
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.red.withOpacity(0.1),
            child: Text('Erreur: ${snapshot.error}'),
          );
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.withOpacity(0.5)),),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 12),),
                    onPressed: () => _showHorairesDialog(context, snapshot.data!),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule, size: 20),
                        SizedBox(width: 8),
                        Text('VOIR LES HORAIRES'),
                      ],
                    ),
                  ),
                );
                }

                // Debug visible si pas de données
                return Container(
                padding: const EdgeInsets.all(8),
            color: Colors.grey.withOpacity(0.1),
            child: const Text('Aucun horaire disponible',
                style: TextStyle(color: Colors.grey)),
          );
        },
    );
  }

  void _showHorairesDialog(BuildContext context, List<Horaire> horaires) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Horaires d\'ouverture'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: horaires.length,
            itemBuilder: (context, index) {
              final horaire = horaires[index];
              return ListTile(
                title: Text(
                  horaire.jour,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '${horaire.heureOuverture.format(context)} - ${horaire.heureFermeture.format(context)}',
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}