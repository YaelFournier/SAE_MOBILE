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

  factory Horaire.fromJson(Map<String, dynamic> json) {
    return Horaire(
      idR: json['idR'] as int? ?? 0, // Fallback si null
      jour: json['jour'] as String? ?? 'Inconnu', // Fallback si null
      heureOuverture: parseTime(json['heure_ouverture']?.toString() ?? '00:00'), // Fallback
      heureFermeture: parseTime(json['heure_fermeture']?.toString() ?? '00:00'), // Fallback
    );
  }
}