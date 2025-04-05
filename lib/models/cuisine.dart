class Cuisine {
  final int idC;
  final String nameC;

  Cuisine({
    required this.idC,
    required this.nameC,
  });

  Map<String, dynamic> toJson() {
    return {
      'idU': idC,
      'nomU': nameC,
    };
  }

  static Cuisine fromJson(Map<String, dynamic> json) {
    return Cuisine(
      idC: json['idC'],
      nameC: json['nameC'],
    );
  }
}