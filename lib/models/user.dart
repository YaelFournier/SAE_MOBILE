class UserSupa {
  final int? idU;
  final String nomU;
  final String prenomU;
  final String mailU;
  final String mdp;

  UserSupa({
    this.idU,
    required this.nomU,
    required this.prenomU,
    required this.mailU,
    required this.mdp,
  });

  Map<String, dynamic> toJson() {
    return {
      'idU': idU,
      'nomU': nomU,
      'prenomU': prenomU,
      'mailU': mailU,
      'mdp': mdp,
    };
  }

  static UserSupa fromJson(Map<String, dynamic> json) {
    return UserSupa(
      idU: json['idU'],
      nomU: json['nomU'],
      prenomU: json['prenomU'],
      mailU: json['mailU'],
      mdp: json['mdp'],
    );
  }
}
