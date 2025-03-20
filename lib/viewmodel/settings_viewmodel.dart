import 'package:flutter/material.dart';
import 'package:sae_mobile/models/SettingdRepo.dart';

class SettingsViewModel extends ChangeNotifier {

  late bool _isDarkMode;
  late SettingsRepo _settingsRepo;
  bool get isDarkMode => _isDarkMode;

  SettingsViewModel() {
    _settingsRepo = SettingsRepo();
    _isDarkMode = false;
    getSettings();
  }

  getSettings() async {
    _isDarkMode = await _settingsRepo.getSettings();
    notifyListeners();
  }

  set isDarkMode(bool value){
    _isDarkMode = value;
    _settingsRepo.saveSettings(value);
    notifyListeners();
  }

}