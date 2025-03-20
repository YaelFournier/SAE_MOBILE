import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/viewmodel/settings_viewmodel.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider( providers: [
      ChangeNotifierProvider(
        create: (_){
          SettingsViewModel settingsViewModel = SettingsViewModel();
          return settingsViewModel;
        }
      )
    ],
      child: Consumer<SettingsViewModel>(
        builder: (context, SettingsViewModel notifier, child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Sae Mobile",
            theme: notifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home : Home()
          )
        },
      ),
    );
  }
}