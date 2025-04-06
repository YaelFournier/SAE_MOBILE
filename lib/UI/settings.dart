import 'package:flutter/cupertino.dart';
import 'package:sae_mobile/models/user.dart';
import 'package:sae_mobile/services/user_service.dart';
import 'package:sae_mobile/viewmodels/connexion_view_model.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';

class EcranSettings extends StatefulWidget {
  const EcranSettings({super.key});

  @override
  State<EcranSettings> createState() => _EcranSettingsState();
}

class _EcranSettingsState extends State<EcranSettings> {
  bool _dark = false;

  @override
  void initState(){
    super.initState();
  }

  Future<String> getUsername() async{
    int user_id = context.read<ConnexionViewModel>().getUserId;
    final connectedUser = await UserService().getUserById(user_id);
    if (connectedUser != null){
      String nom = connectedUser.nomU;
      return nom;
    }
    return "user non trouvé";
  }

  @override
  Widget build(BuildContext context) {
    final connectedUser = getUsername();

    return SettingsList(
        sections: [
          SettingsSection(

              title: Text("Thème de ${connectedUser}"),
              tiles:[
                SettingsTile.switchTile(
                  initialValue: _dark,
                  title: Text('DarkMode'),
                  onToggle: (bool value)=>{
                    setState(() {
                      false;
                    })
                  },
                ),
                //SettingsTile(title: Text('Police')),
              ]
          ),
        ]
    );
  }
}
