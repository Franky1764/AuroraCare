// lib/presentation/onboarding/medical_disclaimer_screen.dart

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Pantalla de disclaimer médico (F1 — onboarding, SCRUM-96).
/// Alcance de esta subtarea: solo maquetado visual. La persistencia del
/// consentimiento se implementa en SCRUM-97.
// NOTA TEMPORAL: onRegisterSuccess y onLoginSuccess navegan aquí directo,
// saltándose verificación de email y lógica real de consentimiento.
// Esto es solo para demostrar el flujo visual completo.
// Será reemplazado cuando Daniela conecte el backend real (data/domain).
class MedicalDisclaimerScreen extends StatefulWidget {
  const MedicalDisclaimerScreen({super.key, this.onAccept});

  final VoidCallback? onAccept;

  @override
  State<MedicalDisclaimerScreen> createState() =>
      _MedicalDisclaimerScreenState();
}

class _MedicalDisclaimerScreenState extends State<MedicalDisclaimerScreen> {
  // Color específico del mockup, no está en AppColors — confirmar con
  // Daniela si se agrega a la paleta.
  static const Color _disclaimerBackground = Color(0xFFF3EEDF);

  bool _hasAcknowledged = false;

  void _toggleAcknowledged([bool? value]) {
    setState(() => _hasAcknowledged = value ?? !_hasAcknowledged);
  }

  @override
  Widget build(BuildContext context) {
    // Según ARCHITECTURE.md sección 5.3: "Sin aceptación explícita no hay acceso a la app".
    // El acceso HACIA ADELANTE está bloqueado por el checkbox (el botón no se habilita
    // sin marcarlo). Se permite volver atrás por si el usuario seleccionó el rol
    // equivocado - esto no viola la regla, ya que no otorga acceso, solo permite salir.
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _hasAcknowledged,
                          activeColor: AppColors.primary,
                          onChanged: _toggleAcknowledged,
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _toggleAcknowledged,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Entiendo y acepto lo anterior',
                                style: AppTextStyles.body,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // Deshabilitado sigue legible: colores de la paleta
                        // en vez del gris translúcido por defecto de Material.
                        disabledBackgroundColor: AppColors.border,
                        disabledForegroundColor: AppColors.textSecondary,
                      ),
                      onPressed: _hasAcknowledged
                          ? (widget.onAccept ??
                                () {
                                  // TODO: SCRUM-97 - conectar lógica de bloqueo y persistencia de consentimiento
                                })
                          : null,
                      child: const Text('Entendido, continuar'),
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
