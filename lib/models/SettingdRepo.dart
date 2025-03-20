import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepo {
  static const THEME_KEY = 'dark';
  saveSettings(bool isDark) async {
    SharedPreferences prefs = await 
    SharedPreferences.getInstance();
    prefs.setBool(THEME_KEY, isDark);
  }

  Future<bool> getSettings() async {
    SharedPreferences prefs = await 
    SharedPreferences.getInstance();
    return prefs.getBool(THEME_KEY) ?? false;
  }
}