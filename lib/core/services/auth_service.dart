import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _authKey = 'auth_key';

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authKey);
    return token != null && token.isNotEmpty;
  }

  Future<void> saveAuthKey(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authKey, token);
  }

  Future<void> clearAuthKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
  }
}
