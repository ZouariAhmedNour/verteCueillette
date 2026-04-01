import 'package:vertecueilletteapp/api/api_client.dart';
import 'package:vertecueilletteapp/models/product_model.dart';

class ProductApi {
  /// GET /produits
  /// 200 : liste paginée récupérée
  /// 401 : non authentifié
  /// 403 : interdit
  /// 500 : erreur serveur
  Future<List<ProductModel>> getProducts() async {
    final response = await ApiClient.get('/produits');

    final data = response.data;
    final content = data is Map<String, dynamic> ? data['content'] : data;

    if (content is! List) {
      throw Exception('Format invalide pour la liste des produits.');
    }

    return content
        .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// GET /produits/search?keyword=...
  /// 200 : résultats récupérés
  /// 400 : mot-clé invalide
  /// 401 : non authentifié
  /// 403 : interdit
  /// 404 : route absente
  /// 500 : erreur serveur
  Future<List<ProductModel>> searchProducts(String keyword) async {
    final response = await ApiClient.get(
      '/produits/search',
      queryParameters: {'keyword': keyword.trim()},
    );

    final data = response.data;
    final content = data is Map<String, dynamic> ? data['content'] : data;

    if (content is! List) {
      throw Exception('Format invalide pour la recherche des produits.');
    }

    return content
        .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}