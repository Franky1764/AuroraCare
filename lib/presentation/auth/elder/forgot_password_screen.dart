// lib/presentation/auth/elder/forgot_password_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Pantalla de recuperación de contraseña del adulto mayor
/// (F2 — auth/elder, SCRUM-95).
/// Pantalla 100% visual: solo valida formato de formulario en esta capa,
/// sin ninguna llamada a backend/base de datos. El envío real de
/// instrucciones lo implementará Daniela en data/domain con
/// FirebaseAuth.sendPasswordResetEmail.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.onBackToLogin});

  final VoidCallback? onBackToLogin;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool _instructionsSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  void _handleSendInstructions() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _instructionsSent = true);
  }

  void _handleBackToLogin() {
    if (widget.onBackToLogin != null) {
      widget.onBackToLogin!();
    } else {
      // TODO: conectar con GoRouter cuando esté implementado el router en core/router/
    }
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodySecondary,
      errorStyle: AppTextStyles.fieldError,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Olvidé mi contraseña', style: AppTextStyles.heading),
          const SizedBox(height: 12),
          Text(
            'Te enviaremos instrucciones a tu correo para recuperar el '
            'acceso.',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 32),
          Text('Correo', style: AppTextStyles.cardTitle),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            style: AppTextStyles.body,
            decoration: _decoration('rosa@correo.cl'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            validator: _validateEmail,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _handleSendInstructions,
            child: const Text('Enviar instrucciones'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.mark_email_read,
          color: AppColors.primary,
          size: 80,
        ),
        const SizedBox(height: 24),
        Text(
          'Revisa tu correo',
          textAlign: TextAlign.center,
          style: AppTextStyles.heading,
        ),
        const SizedBox(height: 12),
        Text(
          'Te enviamos instrucciones para recuperar tu contraseña. Revisa '
          'tu bandeja de entrada.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _handleBackToLogin,
          child: const Text('Volver a iniciar sesión'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _instructionsSent ? _buildConfirmation() : _buildForm(),
        ),
      ),
    );
  }
}
