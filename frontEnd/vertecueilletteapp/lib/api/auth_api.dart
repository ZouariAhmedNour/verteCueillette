import 'package:vertecueilletteapp/api/api_client.dart';
import 'package:vertecueilletteapp/api/session_manager.dart';
import 'package:vertecueilletteapp/models/auth_response_model.dart';

class AuthApi {
  /// POST /auth/authenticate
  /// 200 : connexion réussie, token JWT renvoyé
  /// 400 : payload invalide
  /// 401 : email ou mot de passe incorrect
  /// 403 : accès refusé / compte bloqué
  /// 500 : erreur serveur
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.post(
      '/auth/authenticate',
      data: {
        'email': email.trim(),
        'password': password,
      },
    );

    final auth = AuthResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );

    if (auth.token.isNotEmpty) {
      SessionManager.setToken(auth.token);
    }

    return auth;
  }

  /// POST /auth/register
  /// 200 ou 201 : inscription réussie
  /// 400 : données invalides
  /// 409 : email déjà utilisé
  /// 422 : erreur métier / validation
  /// 500 : erreur serveur
  Future<AuthResponseModel> register({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String ville,
  }) async {
    final response = await ApiClient.post(
      '/auth/register',
      data: {
        'nom': nom.trim(),
        'prenom': prenom.trim(),
        'email': email.trim(),
        'password': password,
        'ville': ville.trim(),
      },
    );

    final auth = AuthResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );

    if (auth.token.isNotEmpty) {
      SessionManager.setToken(auth.token);
    }

    return auth;
  }

  void logout() {
    SessionManager.clear();
  }
}