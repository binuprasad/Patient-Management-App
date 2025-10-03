import 'package:flutter/foundation.dart';
import 'package:patientmanagementapp/core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? auth}) : _auth = auth ?? AuthService();

  final AuthService _auth;

  bool _loading = false;
  String? _error;
  String? _token;

  bool get loading => _loading;
  String? get error => _error;
  String? get token => _token;
  bool get isLoggedIn => (_token != null && _token!.isNotEmpty);

  Future<bool> login({required String username, required String password}) async {
    _error = null;
    _loading = true;
    notifyListeners();
    try {
      final t = await _auth.login(username: username, password: password);
      _token = t;
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.clearAuthKey();
    _token = null;
    notifyListeners();
  }
}
