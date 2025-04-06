import 'package:sae_mobile/models/horaire.dart';
import 'package:sae_mobile/services/supabase_services.dart';
import 'package:flutter/material.dart';

class HoraireService {
  final supabaseService = SupabaseServices();
  final String _tableName = 'HORAIRES';

  Future<void> addHoraire(Horaire horaire) async {
    await supabaseService.supabase
        .from(_tableName)
        .insert(horaire.toJson());
  }

  Future<List<Horaire>> getHorairesByRestaurant(int idR) async {
    try {
      final response = await supabaseService.supabase
          .from(_tableName)
          .select('idR, jour, heureOuverture, heureFermeture')
          .eq('idR', idR)
          .order('jour');

      // Debug des données brutes
      debugPrint('Données horaires brutes:');
      for (final item in response) {
        debugPrint('''
        Jour: ${item['jour']} 
        Ouverture: ${item['heureOuverture']} (${item['heureOuverture'].runtimeType})
        Fermeture: ${item['heureFermeture']} (${item['heureFermeture'].runtimeType})
      ''');
      }

      return response.map(Horaire.fromJson).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des horaires: $e');
      return [];
    }
  }

  Future<void> updateHoraire(Horaire horaire) async {
    await supabaseService.supabase
        .from(_tableName)
        .update(horaire.toJson())
        .match({
      'idR': horaire.idR,
      'jour': horaire.jour,
      'heureOuverture': '${horaire.heureOuverture.hour}:${horaire.heureOuverture.minute}'
    });
  }

  Future<void> deleteHoraire(int idR, String jour, TimeOfDay heureOuverture) async {
    await supabaseService.supabase
        .from(_tableName)
        .delete()
        .match({
      'idR': idR,
      'jour': jour,
      'heureOuverture': '${heureOuverture.hour}:${heureOuverture.minute}'
    });
  }
}