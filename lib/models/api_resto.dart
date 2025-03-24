import 'dart:convert';
import 'package:sae_mobile/models/resto.dart';
import 'package:flutter/services.dart';


class APIResto{
  Future<List<Resto>> getRestos() async{
    await Future.delayed(Duration(seconds: 3));
    final dataString = await _loadAsset('data/restos.json');

    final Map<String, dynamic> json = jsonDecode(dataString);
    if (json['restos']!=null) {
      final restos = <Resto>[];
      json['restos'].forEach((element){
        restos.add(Resto.fromJson(element));
    });
      return restos;
    }else {
      return [];
    }
  }
  Future<String> _loadAsset(String path) async{
    return rootBundle.loadString(path);
  }
}