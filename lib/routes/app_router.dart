import 'package:flutter/material.dart';
import 'package:patientmanagementapp/features/splash/splash_screen.dart';
import 'package:patientmanagementapp/features/auth/screens/login_screen.dart';
import 'package:patientmanagementapp/features/home/screens/home_screen.dart';
import 'package:patientmanagementapp/features/patient/screens/register_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
}

class AppRouter {
  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
      };
}
