import 'package:sae_mobile/models/resto.dart';
import 'package:sae_mobile/services/supabase_services.dart';

class RestoService {
  final supabaseService = SupabaseServices();
  final String _tableName = 'RESTAURANT';

  Future<int?> addResto(Resto resto) async{
    final response = await supabaseService.supabase
        .from(_tableName)
        .insert(resto.toJson())
        .select('idR')
        .single();

    return response['idR'];
  }

  Future<List<Resto>> getRestos() async{
    final response = await supabaseService.supabase
        .from(_tableName)
        .select();

    return response.map((data) => Resto.fromJson(data)).toList();
  }

  Future<Resto?> getRestoById(int id) async{
    final response = await supabaseService.supabase
        .from(_tableName)
        .select()
        .eq('idR', id)
        .maybeSingle();

    if (response != null){
      return Resto.fromJson(response);
    }
    return null;
  }

  Future<void> updateResto(Resto resto) async {
    await supabaseService.supabase
        .from(_tableName)
        .update(resto.toJson())
        .eq('idR', resto.id);
  }

  Future<void> deleteResto(int id) async{
    await supabaseService.supabase.from('AVIS').delete().eq('idR', id);
    await supabaseService.supabase.from('HORAIRES').delete().eq('idR', id);
    await supabaseService.supabase.from('CUISINER').delete().eq('idR', id);
    await supabaseService.supabase.from(_tableName).delete().eq('idR', id);
  }
}