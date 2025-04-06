import 'package:flutter/material.dart';

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

  factory Horaire.fromJson(Map<String, dynamic> json) {
    return Horaire(
      idR: json['idR'] as int,
      jour: json['jour'] as String,
      heureOuverture: _parsePostgresTime(json['heureOuverture']),
      heureFermeture: _parsePostgresTime(json['heureFermeture']),
    );
  }

  static TimeOfDay _parsePostgresTime(dynamic timeData) {
    try {
      // Le format TIME de PostgreSQL arrive comme "HH:MM:SS" (peut inclure les millisecondes)
      final timeStr = timeData.toString();
      final timeParts = timeStr.split(':');

      // Extraction des heures et minutes (ignore les secondes)
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Validation des valeurs
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        throw FormatException('Heure invalide: $timeStr');
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      debugPrint('Erreur de conversion du temps: $e - Valeur reçue: $timeData');
      return const TimeOfDay(hour: 0, minute: 0); // Valeur par défaut sécurisée
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'idR': idR,
      'jour': jour,
      'heureOuverture': _formatTimeForSupabase(heureOuverture),
      'heureFermeture': _formatTimeForSupabase(heureFermeture),
    };
  }

  static String _formatTimeForSupabase(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }
}