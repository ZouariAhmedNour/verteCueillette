class SessionManager {
  static String? _token;

  static String? get token => _token;

  static void setToken(String? value) {
    _token = value;
  }

  static void clear() {
    _token = null;
  }
}