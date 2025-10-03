import 'package:flutter/material.dart';
import 'package:patientmanagementapp/core/services/auth_service.dart';
import 'package:patientmanagementapp/routes/app_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _mockLogin(BuildContext context) async {
    final nav = Navigator.of(context);
    await AuthService().saveAuthKey('example-token');
    nav.pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: const Text('Login')));
  }
}
