// lib/presentation/onboarding/role_selection_screen.dart

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Pantalla de selección de rol de AuroraCare (F1 — onboarding).
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({
    super.key,
    this.onSelectElder,
    this.onSelectCaregiver,
  });

  final VoidCallback? onSelectElder;
  final VoidCallback? onSelectCaregiver;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Bienvenido a AuroraCare',
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 8),
              Text(
                'Por favor seleccione su rol para comenzar:',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 32),
              _RoleCard(
                iconBackgroundColor: AppColors.primary,
                icon: Icons.sentiment_satisfied_alt,
                iconColor: AppColors.textOnPrimary,
                title: 'Soy adulto mayor',
                description:
                    'Quiero ejercitar mi memoria y divertirme con juegos sencillos.',
                onTap: onSelectElder ??
                    () {
                      // TODO: conectar con GoRouter cuando esté implementado el router en core/router/
                    },
              ),
              const SizedBox(height: 16),
              _RoleCard(
                iconBackgroundColor: AppColors.primaryLight,
                icon: Icons.favorite,
                iconColor: AppColors.primary,
                title: 'Soy cuidador o familiar',
                description:
                    'Quiero monitorear el progreso de mi ser querido y configurar alertas.',
                onTap: onSelectCaregiver ??
                    () {
                      // TODO: conectar con GoRouter cuando esté implementado el router en core/router/
                    },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.iconBackgroundColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final Color iconBackgroundColor;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardShape = Theme.of(context).cardTheme.shape as RoundedRectangleBorder?;
    final borderRadius =
        (cardShape?.borderRadius as BorderRadius?) ?? BorderRadius.circular(18);

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 4),
                    Text(description, style: AppTextStyles.bodySecondary),
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
