import 'package:vertecueilletteapp/api/api_client.dart';
import 'package:vertecueilletteapp/models/category_model.dart';

class CategoryApi {
  /// GET /categories
  /// 200 : liste récupérée
  /// 401 : non authentifié
  /// 403 : interdit
  /// 500 : erreur serveur
  Future<List<CategoryModel>> getCategories() async {
    final response = await ApiClient.get('/categories');

    final data = response.data;
    if (data is! List) {
      throw Exception('Format invalide pour la liste des catégories.');
    }

    return data
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}