import 'package:flutter/material.dart';
import 'package:patientmanagementapp/features/auth/widgets/labeled_field.dart';
import 'package:patientmanagementapp/features/auth/widgets/password_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 240,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/login_header.png',
                      fit: BoxFit.cover,
                    ),

                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login Or Register To Book\nYour Appointments',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 20),

                    LabeledField(
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),

                    const PasswordField(),
                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(
                      child: Text.rich(
                        TextSpan(
                          text:
                              'By creating or logging into an account you are agreeing\nwith our ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                          children: const [
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                color: Color(0xFF1B5E20),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Color(0xFF1B5E20),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
