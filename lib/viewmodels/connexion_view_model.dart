import 'package:flutter/cupertino.dart';
import 'package:sae_mobile/repository/connexion_repository.dart';

class ConnexionViewModel extends ChangeNotifier{
  late int _user_id;
  late ConnexionRepository _connexionRepository;

  ConnexionViewModel(){
    _user_id = 0;
    _connexionRepository = ConnexionRepository();
    getConnexion();
  }

  getConnexion() async {
    _user_id = await _connexionRepository.getConnexion();
    notifyListeners();
  }

  int get getUserId => _user_id;

  void set isDark(int value){
    _user_id = value;
    _connexionRepository.saveConnexion(value);
    notifyListeners();
  }
}