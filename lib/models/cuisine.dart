class Cuisine {
  final int idC;
  final String nameC;

  Cuisine({
    required this.idC,
    required this.nameC,
  });

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      idC: json['idC'] as int,
      nameC: json['nameC'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idC': idC,
      'nameC': nameC,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Cuisine &&
              runtimeType == other.runtimeType &&
              idC == other.idC;

  @override
  int get hashCode => idC.hashCode;
}