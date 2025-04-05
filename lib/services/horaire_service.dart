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
    final response = await supabaseService.supabase
        .from(_tableName)
        .select()
        .eq('idR', idR);

    return response.map((data) => Horaire.fromJson(data)).toList();
  }

  Future<void> updateHoraire(Horaire horaire) async {
    await supabaseService.supabase
        .from(_tableName)
        .update(horaire.toJson())
        .match({
      'idR': horaire.idR,
      'jour': horaire.jour,
      'heure_ouverture': '${horaire.heureOuverture.hour}:${horaire.heureOuverture.minute}'
    });
  }

  Future<void> deleteHoraire(int idR, String jour, TimeOfDay heureOuverture) async {
    await supabaseService.supabase
        .from(_tableName)
        .delete()
        .match({
      'idR': idR,
      'jour': jour,
      'heure_ouverture': '${heureOuverture.hour}:${heureOuverture.minute}'
    });
  }
}