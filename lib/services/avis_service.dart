import 'package:sae_mobile/models/avis.dart';
import 'package:sae_mobile/services/supabase_services.dart';

class AvisService {
  final supabaseService = SupabaseServices();
  final String _tableName = 'AVIS';

  Future<void> addAvis(Avis avis) async {
    await supabaseService.supabase.from(_tableName).insert(avis.toJson());
  }

  Future<List<Avis>> getAvisByRestaurant(int idR) async {
    final response = await supabaseService.supabase
        .from(_tableName)
        .select()
        .eq('idR', idR)
        .order('dateA', ascending: false);

    return response.map((data) => Avis.fromJson(data)).toList();
  }

  Future<List<Avis>> getAvisByUser(String mailU) async {
    final response = await supabaseService.supabase
        .from(_tableName)
        .select()
        .eq('mailU', mailU)
        .order('dateA', ascending: false);

    return response.map((data) => Avis.fromJson(data)).toList();
  }

  Future<double> getAverageRating(int idR) async {
    final response = await supabaseService.supabase
        .from(_tableName)
        .select('note')
        .eq('idR', idR);

    if (response.isEmpty) return 0.0;

    final total = response.map((r) => r['note'] as int).reduce((a, b) => a + b);
    return total / response.length;
  }

  Future<void> updateAvis(Avis avis) async {
    await supabaseService.supabase
        .from(_tableName)
        .update({
      'note': avis.note,
      'description': avis.description,
    })
        .match({
      'idR': avis.idR,
      'mailU': avis.mailU,
      'dateA': avis.dateA.toIso8601String(),
    });
  }

  Future<void> deleteAvis(int idR, String mailU, DateTime dateA) async {
    await supabaseService.supabase
        .from(_tableName)
        .delete()
        .match({
      'idR': idR,
      'mailU': mailU,
      'dateA': dateA.toIso8601String(),
    });
  }
}