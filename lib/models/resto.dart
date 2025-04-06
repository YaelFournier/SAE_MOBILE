import 'package:sae_mobile/models/cuisine.dart';

class Resto {
  final int id;
  final String? type;
  final String name;
  final String? brand;
  final String? wheelchair;
  final String? siret;
  final String? phone;
  final String? website;
  final String? region;
  final String? departement;
  final String? commune;
  final String? codeCommune;
  final List<Cuisine>? cuisines;

  Resto({
    required this.id,
    required this.type,
    required this.name,
    this.brand,
    this.wheelchair,
    required this.siret,
    this.phone,
    this.website,
    required this.region,
    required this.departement,
    required this.commune,
    required this.codeCommune,
    this.cuisines,
  });

  Map<String, dynamic> toJson() {
    return {
      'idR': id,
      'type': type,
      'name': name,
      'brand': brand,
      'wheelchair': wheelchair,
      'siret': siret,
      'phone': phone,
      'website': website,
      'region': region,
      'departement': departement,
      'commune': commune,
      'codeCommune': codeCommune,
      'cuisines': cuisines?.map((c) => c.toJson()).toList(),
    };
  }

  factory Resto.fromJson(Map<String, dynamic> json) {
    return Resto(
      id: json['idR'] as int,
      type: json['type'] as String?,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      wheelchair: json['wheelchair'] as String?,
      siret: json['siret'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      region: json['region'] as String?,
      departement: json['departement'] as String?,
      commune: json['commune'] as String?,
      codeCommune: json['codeCommune'] as String?,
      cuisines: json['cuisines'] != null
          ? (json['cuisines'] as List).map((c) => Cuisine.fromJson(c)).toList()
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Resto &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}