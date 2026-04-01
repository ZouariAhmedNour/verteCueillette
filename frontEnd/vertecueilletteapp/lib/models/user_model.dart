class UserModel {
  final int idUser;
  final String nom;
  final String prenom;
  final String email;
  final String? numTel;
  final String? avatarUrl;

  UserModel({
    required this.idUser,
    required this.nom,
    required this.prenom,
    required this.email,
    this.numTel,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['idUser'] ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      numTel: json['numTel'],
      avatarUrl: json['avatarUrl'],
    );
  }
}