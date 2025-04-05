import 'package:flutter/material.dart';
import 'package:sae_mobile/config/utils.dart';

class Horaire {
  final int idR;
  final String jour;
  final TimeOfDay heureOuverture;
  final TimeOfDay heureFermeture;

  Horaire({
    required this.idR,
    required this.jour,
    required this.heureOuverture,
    required this.heureFermeture,
  });

  Map<String, dynamic> toJson() {
    return {
      'idR': idR,
      'jour': jour,
      'heure_ouverture': '${heureOuverture.hour}:${heureOuverture.minute}',
      'heure_fermeture': '${heureFermeture.hour}:${heureFermeture.minute}',
    };
  }

  static Horaire fromJson(Map<String, dynamic> json) {
    return Horaire(
      idR: json['idR'],
      jour: json['jour'],
      heureOuverture: parseTime(json['heure_ouverture']),
      heureFermeture: parseTime(json['heure_fermeture']),
    );
  }
}