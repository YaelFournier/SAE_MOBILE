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
  });

  Map<String, dynamic> toJson(){
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
    };
  }

  static Resto fromJson(Map<String, dynamic> json) {
    return Resto(
      id: json['idR'],
      type: json['type'],
      name: json['name'],
      brand: json['brand'],
      wheelchair: json['wheelchair'],
      siret: json['siret'],
      phone: json['phone'],
      website: json['website'],
      region: json['region'],
      departement: json['departement'],
      commune: json['commune'],
      codeCommune: json['codeCommune'],
    );
  }
}