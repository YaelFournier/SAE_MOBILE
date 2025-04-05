import 'package:sae_mobile/models/user.dart';
import 'package:sae_mobile/services/supabase_services.dart';

class UserService {
  final supabaseService = SupabaseServices();
  final String _tableName = 'USER';

  Future<int?> addUser(UserSupa user) async {
    final response = await supabaseService.supabase
        .from(_tableName)
        .insert(user.toJson())
        .select('idU')
        .single();

    return response['idU'];
  }

  Future<List<UserSupa>> getUsers() async{
    final response = await supabaseService.supabase
        .from(_tableName)
        .select();

    return response.map((data) => UserSupa.fromJson(data)).toList();
  }

  Future<UserSupa?> getUserById(int id) async {
    final response = await supabaseService.supabase
        .from(_tableName)
        .select()
        .eq('idU', id)
        .maybeSingle();

    if (response!= null) {
      return UserSupa.fromJson(response);
    }
    return null;
  }

  Future<void> updateUser(UserSupa user) async {
    await supabaseService.supabase
        .from(_tableName)
        .update(user.toJson())
        .eq('idU', user.idU);
  }

  Future<void> deleteUser(int id) async{
    await supabaseService.supabase.from('AIMER').delete().eq('idU', id);
    await supabaseService.supabase.from('AVIS').delete().eq('idU', id);
    await supabaseService.supabase.from(_tableName).delete().eq('idU', id);
  }
}