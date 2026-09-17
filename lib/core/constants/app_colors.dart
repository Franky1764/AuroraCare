// Carpeta placeholder: pendiente de implementación.
// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

/// Paleta de colores de AuroraCare.
/// Extraída de los mockups de Figma (agosto-septiembre 2026).
/// ⚠️ Valores estimados desde capturas PNG — verificar hex exacto
/// contra el panel Inspect de Figma antes de dar por definitivos.
class AppColors {
  AppColors._();

  // Primario — morado de marca
  static const Color primary = Color(0xFF5B4BB5);
  static const Color primaryDark = Color(0xFF3B2F72);
  static const Color primaryLight = Color(0xFFEDEAFA);

  // Acento — dorado (usado en logros/trofeos)
  static const Color accent = Color(0xFFE8B33C);

  // Fondo y superficies
  static const Color background = Color(0xFFFBFAFE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4E1F0);

  // Texto
  static const Color textPrimary = Color(0xFF3B2F72);
  static const Color textSecondary = Color(0xFF6E6B85);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Estados semánticos (tags de progreso, evaluaciones)
  static const Color success = Color(0xFF2E9E5B);
  static const Color successBackground = Color(0xFFE7F7EC);

  static const Color warning = Color(0xFFE8B33C);
  static const Color warningBackground = Color(0xFFFFF6DF);

  static const Color error = Color(0xFFD64545);
  static const Color errorBackground = Color(0xFFFDEAEA);
}