// lib/presentation/auth/elder/login_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Pantalla de login del adulto mayor (F2 — auth/elder, SCRUM-94).
/// Pantalla 100% visual: solo valida formato de formulario en esta capa,
/// sin ninguna llamada a backend/base de datos.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onLoginSuccess,
    this.onForgotPassword,
    this.onGoToRegister,
  });

  final VoidCallback? onLoginSuccess;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onGoToRegister;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu contraseña';
    }
    return null;
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.onLoginSuccess != null) {
      widget.onLoginSuccess!();
    } else {
      // TODO: conectar con backend/Firebase cuando Daniela implemente data/domain (AuthRepository)
    }
  }

  void _handleForgotPassword() {
    if (widget.onForgotPassword != null) {
      widget.onForgotPassword!();
    } else {
      // TODO: conectar con backend/Firebase cuando Daniela implemente data/domain (AuthRepository)
    }
  }

  void _handleGoToRegister() {
    if (widget.onGoToRegister != null) {
      widget.onGoToRegister!();
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola de nuevo', style: AppTextStyles.heading),
                const SizedBox(height: 32),
                Text('Correo electrónico', style: AppTextStyles.cardTitle),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  style: AppTextStyles.body,
                  decoration: _decoration('carla@email.com'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                Text('Contraseña', style: AppTextStyles.cardTitle),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  style: AppTextStyles.body,
                  obscureText: true,
                  decoration: _decoration('••••••'),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Olvidé mi contraseña',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: _handleGoToRegister,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    child: Text(
                      'Crear cuenta',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
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
