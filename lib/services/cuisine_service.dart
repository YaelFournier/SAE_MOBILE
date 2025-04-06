import 'package:sae_mobile/models/cuisine.dart';
import 'package:sae_mobile/services/supabase_services.dart';

class CuisineService {
  final supabaseService = SupabaseServices();
  final String _tableName = 'CUISINE';

  Future<List<Cuisine>> getCuisines() async{
    final response = await supabaseService.supabase
        .from(_tableName)
        .select('idC, nameC')
        .order('nameC');

    return response.map((c) => Cuisine.fromJson(c)).toList();
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


  Future<List<Cuisine>> getCuisinesForRestaurant(int idR) async {
    final response = await supabaseService.supabase
        .from('CUISINER')
        .select('''
          CUISINE (idC, nameC)
        ''')
        .eq('idR', idR);

    return response.map((c) => Cuisine.fromJson(c['CUISINE'])).toList();
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