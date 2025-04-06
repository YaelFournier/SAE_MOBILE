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

  static String timeSinceCreation(DateTime dateA) {
    final now = DateTime.now().toUtc(); // Utilisation du temps UTC
    final dateAUtc = dateA.toUtc(); // Conversion de la date en UTC
    final difference = now.difference(dateAUtc);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Il y a $years an${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Il y a $months mois';
    } else if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }

  Avis copyWith({
    int? idR,
    String? mailU,
    int? note,
    String? description,
    DateTime? dateA,
  }) {
    return Avis(
      idR: idR ?? this.idR,
      mailU: mailU ?? this.mailU,
      note: note ?? this.note,
      description: description ?? this.description,
      dateA: dateA ?? this.dateA,
    );
  }
}