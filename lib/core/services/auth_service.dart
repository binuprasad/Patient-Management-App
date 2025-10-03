import 'package:shared_preferences/shared_preferences.dart';
import 'package:patientmanagementapp/core/services/api_client.dart';

class AuthService {
  static const String _authKey = 'auth_key';
  final ApiClient _api = ApiClient();

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

  /// Calls Login API and saves the token if success.
  /// Returns the token string.
  Future<String> login({required String username, required String password}) async {
    final resp = await _api.postFormData(
      'Login',
      fields: <String, dynamic>{
        'username': username,
        'password': password,
      },
    );

    final data = resp.data is Map<String, dynamic> ? resp.data as Map<String, dynamic> : <String, dynamic>{'raw': resp.data};

    // Adjust these keys to match exact server response if different.
    if (resp.statusCode != null && resp.statusCode! >= 200 && resp.statusCode! < 300) {
      final token = (data['token'] ?? data['data']?['token'] ?? data['access_token'] ?? '').toString();
      if (token.isEmpty) {
        throw Exception('Login succeeded but no token found in response');
      }
      await saveAuthKey(token);
      return token;
    }

    final message = (data['message'] ?? data['error'] ?? 'Login failed').toString();
    throw Exception(message);
  }
}
