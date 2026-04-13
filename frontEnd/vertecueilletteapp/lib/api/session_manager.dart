import 'package:vertecueilletteapp/models/auth_response_model.dart';

class SessionManager {
  static String? _token;
  static int? _userId;
  static String? _email;
  static String? _role;
  static String? _nom;
  static String? _prenom;

  static String? get token => _token;
  static int? get userId => _userId;
  static String? get email => _email;
  static String? get role => _role;
  static String? get nom => _nom;
  static String? get prenom => _prenom;

  static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  static void setSession(AuthResponseModel auth) {
    _token = auth.token;
    _userId = auth.idUser;
    _email = auth.email;
    _role = auth.role;
    _nom = auth.nom;
    _prenom = auth.prenom;
  }

  static void clear() {
    _token = null;
    _userId = null;
    _email = null;
    _role = null;
    _nom = null;
    _prenom = null;
  }
}