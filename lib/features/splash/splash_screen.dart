import 'package:flutter/material.dart';
import 'package:patientmanagementapp/core/services/auth_service.dart';
import 'package:patientmanagementapp/routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _decideNavigation();
  }

  Future<void> _decideNavigation() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    final ok = await _auth.isAuthenticated();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      ok ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_page.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
