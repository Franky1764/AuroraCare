// lib/presentation/onboarding/medical_disclaimer_screen.dart

import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

/// Pantalla de disclaimer médico (F1 — onboarding, SCRUM-96).
/// Alcance de esta subtarea: solo maquetado visual. El bloqueo estricto
/// (impedir retroceso/gestos de salida) y la persistencia del
/// consentimiento se implementan en SCRUM-97.
// NOTA TEMPORAL: onRegisterSuccess y onLoginSuccess navegan aquí directo,
// saltándose verificación de email y lógica real de consentimiento.
// Esto es solo para demostrar el flujo visual completo.
// Será reemplazado cuando Daniela conecte el backend real (data/domain).
class MedicalDisclaimerScreen extends StatelessWidget {
  const MedicalDisclaimerScreen({super.key, this.onAccept});

  final VoidCallback? onAccept;

  // Color específico del mockup, no está en AppColors — confirmar con
  // Daniela si se agrega a la paleta.
  static const Color _disclaimerBackground = Color(0xFFF3EEDF);

  @override
  Widget build(BuildContext context) {
    // Bloqueo obligatorio segun ARCHITECTURE.md seccion 5.3:
    // "Sin aceptacion explicita no hay acceso a la app".
    // Este bloqueo cubre solo esta pantalla (nivel presentation/).
    // El bloqueo a nivel de toda la app (persistencia + redireccion desde
    // el router) pendiente de implementar por Daniela en data/domain + core/router/.
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text('Antes de empezar', style: AppTextStyles.heading),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: _disclaimerBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppTextStyles.body (color textPrimary) fue verificado
                      // con buen contraste sobre este fondo beige claro.
                      Text.rich(
                        TextSpan(
                          style: AppTextStyles.body,
                          children: const [
                            TextSpan(text: 'AuroraCare '),
                            TextSpan(
                              text: 'no diagnostica',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' ninguna enfermedad.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Es una herramienta de bienestar para ejercitar la '
                        'mente.',
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Ante cualquier duda de salud, hable con su médico.',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed:
                      onAccept ??
                      () {
                        // TODO: SCRUM-97 - conectar lógica de bloqueo y persistencia de consentimiento
                      },
                  child: const Text('Entendido, continuar'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
