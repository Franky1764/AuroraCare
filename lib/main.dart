import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'presentation/onboarding/welcome_screen.dart';
import 'presentation/onboarding/role_selection_screen.dart';
import 'presentation/auth/elder/register_screen.dart';
import 'presentation/auth/elder/login_screen.dart';
import 'presentation/auth/elder/forgot_password_screen.dart';
import 'presentation/onboarding/medical_disclaimer_screen.dart';
import 'presentation/onboarding/mode_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: AuroraCareApp()));
}

class AuroraCareApp extends StatelessWidget {
  const AuroraCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      title: 'AuroraCare',
      // Navegación temporal con Navigator.push — reemplazar por GoRouter
      // cuando esté implementado en core/router/.
      home: Builder(
        builder: (context) => WelcomeScreen(
          onContinue: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RoleSelectionScreen(
                onSelectElder: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(
                        onRegisterSuccess: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicalDisclaimerScreen(
                                onAccept: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ModeSelectionScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        onGoToLogin: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                onLoginSuccess: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MedicalDisclaimerScreen(
                                            onAccept: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const ModeSelectionScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                    ),
                                  );
                                },
                                onGoToRegister: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  );
                                },
                                onForgotPassword: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
