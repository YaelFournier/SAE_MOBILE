import 'package:flutter/material.dart';
import 'package:sae_mobile/models/api_resto.dart';
import 'package:sae_mobile/models/resto.dart';
import 'package:sae_mobile/UI/detail_screen_resto.dart';
import 'package:sae_mobile/config/utils.dart';

class RestoView extends StatelessWidget{
  RestoView({super.key});

  final Future<List<Resto>> _resto = APIResto().getRestos();
  String tel = 'No data';

  Widget _resto2widget(Resto resto, context){
    return Card(
      elevation: 6,
      color: type2color(resto.type),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreenResto(resto: resto),
            ),
          );
        },
        title: Text(resto.name),
        subtitle: Text('${resto.type} - Tel : ${resto.phone ?? tel}'),
        trailing: Text("Ville : ${resto.commune}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
        future: _resto,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data?.length??0,
              itemBuilder: (context, index)=> _resto2widget(snapshot.data![index], context));
        }
    );
  }
}