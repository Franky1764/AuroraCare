// lib/presentation/auth/elder/register_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Pantalla de registro del adulto mayor (F1 — auth/elder, SCRUM-93).
/// Pantalla 100% visual: solo valida formato de formulario en esta capa,
/// sin ninguna llamada a backend/base de datos.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    this.onRegisterSuccess,
    this.onGoToLogin,
  });

  final VoidCallback? onRegisterSuccess;
  final VoidCallback? onGoToLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Cuéntanos cómo te llamamos';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.onRegisterSuccess != null) {
      widget.onRegisterSuccess!();
    } else {
      // TODO: conectar con GoRouter cuando esté implementado el router en core/router/
      // TODO: conectar con backend/Firebase cuando Daniela implemente data/domain (AuthRepository)
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
                Text('Crear mi cuenta', style: AppTextStyles.heading),
                const SizedBox(height: 24),
                Text(
                  '¿Cómo quiere que lo llamemos?',
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: AppTextStyles.body,
                  decoration: _decoration('Rosa'),
                  validator: _validateName,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                Text('Contraseña', style: AppTextStyles.cardTitle),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  style: AppTextStyles.body,
                  obscureText: _obscurePassword,
                  decoration: _decoration('••••••').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _handleRegister,
                  child: const Text('Crear mi cuenta'),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: widget.onGoToLogin,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    child: Text(
                      'Ya tengo cuenta',
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
