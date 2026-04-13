class AuthResponseModel {
  final String token;
  final int idUser;
  final String nom;
  final String prenom;
  final String email;
  final String role;

  AuthResponseModel({
    required this.token,
    required this.idUser,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      idUser: json['idUser'] ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'CLIENT',
    );
  }
}