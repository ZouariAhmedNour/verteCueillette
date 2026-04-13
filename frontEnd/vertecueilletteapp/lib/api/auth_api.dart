import 'package:vertecueilletteapp/api/api_client.dart';
import 'package:vertecueilletteapp/api/session_manager.dart';
import 'package:vertecueilletteapp/models/auth_response_model.dart';

class AuthApi {
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
      SessionManager.setSession(auth);
    }

    return auth;
  }

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
      SessionManager.setSession(auth);
    }

    return auth;
  }

  void logout() {
    SessionManager.clear();
  }
}