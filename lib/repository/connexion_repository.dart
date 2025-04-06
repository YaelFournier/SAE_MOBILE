import 'package:shared_preferences/shared_preferences.dart';

class ConnexionRepository{
  void saveConnexion(int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("connected_user", value);
  }

  Future<int> getConnexion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("connected_user") ?? 0;
  }

  void Disconnect() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("connected_user");
  }
}