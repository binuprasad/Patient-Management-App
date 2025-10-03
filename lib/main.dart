import 'package:flutter/material.dart';
import 'package:patientmanagementapp/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:patientmanagementapp/features/auth/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: AppRoutes.splash,
        routes: AppRouter.routes,
      ),
    );
  }
}
