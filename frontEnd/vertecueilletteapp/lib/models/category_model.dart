class CategoryModel {
  final int idCategorie;
  final String nomCategorie;

  CategoryModel({
    required this.idCategorie,
    required this.nomCategorie,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      idCategorie: json['idCategorie'] ?? 0,
      nomCategorie: json['nomCategorie'] ?? '',
    );
  }
}