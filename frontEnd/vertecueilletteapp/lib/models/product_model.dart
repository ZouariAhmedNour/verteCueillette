class ProductModel {
  final int idProduit;
  final String nomProduit;
  final String description;
  final String imageUrl;
  final double prix;
  final int quantite;
  final bool disponibilite;
  final int idCategorie;

  ProductModel({
    required this.idProduit,
    required this.nomProduit,
    required this.description,
    required this.imageUrl,
    required this.prix,
    required this.quantite,
    required this.disponibilite,
    required this.idCategorie,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      idProduit: json['idProduit'] ?? 0,
      nomProduit: json['nomProduit'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      prix: (json['prix'] ?? 0).toDouble(),
      quantite: json['quantite'] ?? 0,
      disponibilite: json['disponibilite'] ?? false,
      idCategorie: json['idCategorie'] ?? 0,
    );
  }
}