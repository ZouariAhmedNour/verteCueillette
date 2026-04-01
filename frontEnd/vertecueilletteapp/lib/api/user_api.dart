import 'package:vertecueilletteapp/api/api_client.dart';
import 'package:vertecueilletteapp/models/user_model.dart';

class UserApi {
  /// GET /users/{id}
  /// 200 : utilisateur trouvé
  /// 401 : non authentifié
  /// 403 : interdit
  /// 404 : utilisateur introuvable
  /// 500 : erreur serveur
  Future<UserModel> getUserById(int id) async {
    final response = await ApiClient.get('/users/$id');

    return UserModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  /// PUT /users/{id}
  /// 200 : utilisateur mis à jour et renvoyé
  /// 204 : mise à jour OK sans contenu
  /// 400 : données invalides
  /// 401 : non authentifié
  /// 403 : interdit
  /// 404 : utilisateur introuvable
  /// 422 : validation métier
  /// 500 : erreur serveur
  Future<UserModel?> updateUser({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final response = await ApiClient.put('/users/$id', data: data);

    if (response.statusCode == 204 || response.data == null || response.data == '') {
      return null;
    }

    return UserModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}