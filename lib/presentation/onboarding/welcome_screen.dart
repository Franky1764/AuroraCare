// lib/presentation/onboarding/welcome_screen.dart

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Pantalla de bienvenida de AuroraCare (F1 — onboarding).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, this.onContinue});

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 48,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'AuroraCare',
                textAlign: TextAlign.center,
                style: AppTextStyles.greeting,
              ),
              const SizedBox(height: 12),
              Text(
                'Ejercicios simples para mantener la mente activa.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onContinue ??
                    () {
                      // TODO: conectar con GoRouter cuando esté implementado el router en core/router/
                    },
                child: const Text('Comenzar'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
