import 'package:sae_mobile/models/cuisine.dart';
import 'package:sae_mobile/services/supabase_services.dart';

class CuisineService {
  final supabaseService = SupabaseServices();
  final String _tableName = 'CUISINE';

  Future<int?> addCuisine(Cuisine cuisine) async{
    final response = await supabaseService.supabase
        .from(_tableName)
        .insert(cuisine.toJson())
        .select('idC')
        .single();

    return response['idC'];
  }

  Future<List<Cuisine>> getCuisines() async{
    final response = await supabaseService.supabase
        .from(_tableName)
        .select();

    return response.map((data) => Cuisine.fromJson(data)).toList();
  }

  Future<Cuisine?> getCuisineById(int id) async{
    final response = await supabaseService.supabase
        .from(_tableName)
        .select()
        .eq('idC', id)
        .maybeSingle();

    if (response != null){
      return Cuisine.fromJson(response);
    }
    return null;
  }

  Future<void> updateCuisine(Cuisine cuisine) async {
    await supabaseService.supabase
        .from(_tableName)
        .update(cuisine.toJson())
        .eq('idC', cuisine.idC);
  }

  Future<void> deleteCuisine(int id) async{
    await supabaseService.supabase.from('CUISINER').delete().eq('idC', id);
    await supabaseService.supabase.from(_tableName).delete().eq('idC', id);
  }
}