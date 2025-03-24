class Resto {
  double? lon;
  double? lat;
  String? osmId;
  String? type;
  String name;
  String? operator;
  String? brand;
  String? openingHours;
  String? wheelchair;
  List<String>? cuisine;
  String? vegetarian;
  String? vegan;
  String? delivery;
  String? takeaway;
  String? stars;
  String? capacity;
  String? driveThrough;
  String? wikidata;
  String? brandWikidata;
  String? siret;
  String? phone;
  String? website;
  String? facebook;
  String? smoking;
  String? comInsee;
  String? comNom;
  String? region;
  String? codeRegion;
  String? departement;
  String? codeDepartement;
  String? commune;
  String? codeCommune;
  String? osmEdit;

  Resto({
    required this.lon,
    required this.lat,
    required this.osmId,
    required this.type,
    required this.name,
    this.operator,
    this.brand,
    this.openingHours,
    this.wheelchair,
    this.cuisine,
    this.vegetarian,
    this.vegan,
    this.delivery,
    this.takeaway,
    this.stars,
    this.capacity,
    this.driveThrough,
    this.wikidata,
    this.brandWikidata,
    required this.siret,
    this.phone,
    this.website,
    this.facebook,
    this.smoking,
    required this.comInsee,
    required this.comNom,
    required this.region,
    required this.codeRegion,
    required this.departement,
    required this.codeDepartement,
    required this.commune,
    required this.codeCommune,
    required this.osmEdit,
  });

  factory Resto.fromJson(Map<String, dynamic> json) {
    final cuisine = <String>[];
    if(json['cuisine']!=null){
      json['cuisine'].forEach((element){
        cuisine.add(element);
      });
    }

    return Resto(
      lon: json['geo_point_2d']['lon'],
      lat: json['geo_point_2d']['lat'],
      osmId: json['osm_id'],
      type: json['type'],
      name: json['name'],
      operator: json['operator'],
      brand: json['brand'],
      openingHours: json['opening_hours'],
      wheelchair: json['wheelchair'],
      cuisine: cuisine,
      vegetarian: json['vegetarian'],
      vegan: json['vegan'],
      delivery: json['delivery'],
      takeaway: json['takeaway'],
      stars: json['stars'],
      capacity: json['capacity'],
      driveThrough: json['drive_through'],
      wikidata: json['wikidata'],
      brandWikidata: json['brand_wikidata'],
      siret: json['siret'],
      phone: json['phone'],
      website: json['website'],
      facebook: json['facebook'],
      smoking: json['smoking'],
      comInsee: json['com_insee'],
      comNom: json['com_nom'],
      region: json['region'],
      codeRegion: json['code_region'],
      departement: json['departement'],
      codeDepartement: json['code_departement'],
      commune: json['commune'],
      codeCommune: json['code_commune'],
      osmEdit: json['osm_edit'],
    );
  }
}