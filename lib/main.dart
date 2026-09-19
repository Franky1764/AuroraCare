import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'presentation/onboarding/welcome_screen.dart';
import 'presentation/onboarding/role_selection_screen.dart';

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
            MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
          ),
        ),
      ),
    );
  }
}
