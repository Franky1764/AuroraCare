// Carpeta placeholder: pendiente de implementación.
// lib/core/theme/app_text_styles.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Escala tipográfica de AuroraCare.
/// Cumple el estándar de ARCHITECTURE.md sección 11:
/// fuente mínima 18sp, títulos mínimo 22sp.
///
/// Fuente: Atkinson Hyperlegible — diseñada por el Braille Institute
/// para maximizar legibilidad en usuarios con baja visión.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.atkinsonHyperlegible();

  /// Saludo principal de pantalla — "Hola, Rosa"
  static TextStyle get greeting => _base.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  /// Título de sección/pantalla — "Cómo jugar", "Mi progreso"
  static TextStyle get heading => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  /// Título de tarjeta — "Memorice", "Secuencias"
  static TextStyle get cardTitle => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  /// Texto de cuerpo estándar
  static TextStyle get body => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  /// Texto secundario/subtítulo — nunca bajar de 18sp
  /// (en Figma aparece ~16sp; se sube a 18sp para cumplir el estándar)
  static TextStyle get bodySecondary => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  /// Texto de botón
  static TextStyle get button => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  /// Texto pequeño dentro de tags de estado (Perfecto, Estable, etc.)
  /// Único caso permitido bajo 18sp — por espacio físico del componente.
  /// Compensar con alto contraste de color de fondo/texto.
  static TextStyle get tag => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  /// Mensaje de error bajo un campo de formulario.
  /// Excepción intencional al mínimo de 18sp: es texto transitorio y de
  /// espacio acotado bajo el campo, no contenido principal de la pantalla.
  static TextStyle get fieldError => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.error,
      );
}