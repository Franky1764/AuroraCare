// lib/presentation/onboarding/mode_selection_screen.dart

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Pantalla de selección de modo de uso (F3 — onboarding, SCRUM-119).
/// 100% visual: la selección solo vive en estado local, sin persistencia.
class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({super.key, this.initialMode, this.onModeSelected});

  /// Modo (1, 2 o 3) que se muestra resaltado al abrir la pantalla.
  final int? initialMode;
  final Future<void> Function(int mode)? onModeSelected;

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  int? _selectedMode;
  bool _isSaving = false;
  String? _errorMessage;
  int? _pendingMode;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.initialMode;
  }

  Future<void> _handleModeTap(int mode) async {
    // Evita doble toque o cambiar de modo mientras se guarda el anterior.
    if (_isSaving) return;

    setState(() {
      _selectedMode = mode;
      _pendingMode = mode;
      _isSaving = true;
      _errorMessage = null;
    });
    try {
      if (widget.onModeSelected != null) {
        await widget.onModeSelected!(mode);
      } else {
        // Simulación de guardado para demo visual mientras no hay backend real conectado (SCRUM-123 pendiente)
        await Future.delayed(const Duration(milliseconds: 600));
      }
      if (!mounted) return;
      setState(() => _isSaving = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _errorMessage = 'No se pudo guardar tu modo. Intenta de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        // Desplazable para que el banner de error no desborde en pantallas bajas.
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      '¿Cómo quiere usar la app?',
                      style: AppTextStyles.heading,
                    ),
                    const SizedBox(height: 24),
                    if (_errorMessage != null) ...[
                      _ErrorBanner(
                        message: _errorMessage!,
                        onRetry: () => _handleModeTap(_pendingMode!),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _ModeCard(
                      key: const ValueKey('mode_card_1'),
                      isSelected: _selectedMode == 1,
                      isLoading: _isSaving && _pendingMode == 1,
                      icon: Icons.play_arrow,
                      iconBackgroundColor: AppColors.primaryLight,
                      iconColor: AppColors.primary,
                      title: 'Solo jugar',
                      subtitle: 'No se guarda nada',
                      onTap: () => _handleModeTap(1),
                    ),
                    const SizedBox(height: 16),
                    _ModeCard(
                      key: const ValueKey('mode_card_2'),
                      isSelected: _selectedMode == 2,
                      isLoading: _isSaving && _pendingMode == 2,
                      icon: Icons.pie_chart,
                      iconBackgroundColor: AppColors.primaryLight,
                      iconColor: AppColors.primary,
                      title: 'Jugar y ver mi progreso',
                      subtitle: 'Solo usted lo ve',
                      onTap: () => _handleModeTap(2),
                    ),
                    const SizedBox(height: 16),
                    _ModeCard(
                      key: const ValueKey('mode_card_3'),
                      isSelected: _selectedMode == 3,
                      isLoading: _isSaving && _pendingMode == 3,
                      icon: Icons.favorite,
                      iconBackgroundColor: AppColors.primary,
                      iconColor: AppColors.textOnPrimary,
                      title:
                          'Jugar, ver mi progreso y conectar con un cuidador',
                      subtitle: 'Su cuidador ve un resumen',
                      onTap: () => _handleModeTap(3),
                    ),
                    const Spacer(),
                    Text(
                      'Puede cambiar esto cuando quiera.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: AppTextStyles.fieldError)),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              minimumSize: const Size(48, 48),
            ),
            child: Text(
              'Reintentar',
              style: AppTextStyles.body.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    super.key,
    required this.isSelected,
    required this.isLoading,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool isSelected;
  final bool isLoading;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final themeShape =
        Theme.of(context).cardTheme.shape as RoundedRectangleBorder?;
    final borderRadius =
        (themeShape?.borderRadius as BorderRadius?) ??
        BorderRadius.circular(18);

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: isSelected ? AppColors.primaryLight : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 3 : 1,
        ),
      ),
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
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: iconColor,
                          ),
                        ),
                      )
                    : Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.bodySecondary),
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
