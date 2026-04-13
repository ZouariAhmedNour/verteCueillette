class CartLineModel {
  final int idProduit;
  final String nomProduit;
  final int quantite;
  final double prixUnitaire;
  final double sousTotal;
  final String imageUrl;

  CartLineModel({
    required this.idProduit,
    required this.nomProduit,
    required this.quantite,
    required this.prixUnitaire,
    required this.sousTotal,
    required this.imageUrl,
  });

  factory CartLineModel.fromJson(Map<String, dynamic> json) {
    return CartLineModel(
      idProduit: json['idProduit'] ?? 0,
      nomProduit: json['nomProduit'] ?? '',
      quantite: json['quantite'] ?? 0,
      prixUnitaire: (json['prixUnitaire'] ?? 0).toDouble(),
      sousTotal: (json['sousTotal'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class CartModel {
  final int idPanier;
  final int idUser;
  final double totalPanier;
  final List<CartLineModel> lignes;

  CartModel({
    required this.idPanier,
    required this.idUser,
    required this.totalPanier,
    required this.lignes,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final lignesJson = (json['lignes'] as List?) ?? [];

    return CartModel(
      idPanier: json['idPanier'] ?? 0,
      idUser: json['idUser'] ?? 0,
      totalPanier: (json['totalPanier'] ?? 0).toDouble(),
      lignes: lignesJson
          .map((e) => CartLineModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}