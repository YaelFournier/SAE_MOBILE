class Avis {
  final int idR;
  final String mailU;
  final int note;
  final String? description;
  final DateTime dateA;

  Avis({
    required this.idR,
    required this.mailU,
    required this.note,
    this.description,
    required this.dateA,
  });

  Map<String, dynamic> toJson() {
    return {
      'idR': idR,
      'mailU': mailU,
      'note': note,
      'description': description,
      'dateA': dateA.toIso8601String(),
    };
  }

  static Avis fromJson(Map<String, dynamic> json) {
    return Avis(
      idR: json['idR'],
      mailU: json['mailU'],
      note: json['note'],
      description: json['description'],
      dateA: DateTime.parse(json['dateA']),
    );
  }

  String get formattedDate {
    return '${dateA.day}/${dateA.month}/${dateA.year} à ${dateA.hour}h${dateA.minute.toString().padLeft(2, '0')}';
  }

  // Calcul du temps écoulé (version améliorée)
  String timeSinceCreation() {
    final dateA = this.dateA;
    final now = DateTime.now();
    final difference = now.difference(dateA);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years an${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months mois';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }
}