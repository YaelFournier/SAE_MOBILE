import 'package:flutter/material.dart';
import 'package:sae_mobile/models/resto.dart';
import 'package:sae_mobile/UI/detail_screen_resto.dart';
import 'package:sae_mobile/config/utils.dart';
import 'package:sae_mobile/services/resto_service.dart';

class RestoView extends StatelessWidget{
  RestoView({super.key});

  final RestoService _restoService = RestoService();
  String tel = 'No data';

  Widget _resto2widget(Resto restos, context){
    return Card(
      elevation: 6,
      color: type2color(restos.type),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreenResto(resto: restos),
            ),
          );
        },
        title: Text(restos.name),
        subtitle: Text('${restos.type} - Tel : ${restos.phone ?? tel}'),
        trailing: Text("Ville : ${restos.commune}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Resto>>(
      future: _restoService.getRestos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucun restaurant trouvé'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) =>
              _resto2widget(snapshot.data![index], context),
        );
      },
    );
  }
}