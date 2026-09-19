// lib/presentation/auth/elder/register_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Pantalla de registro del adulto mayor (F1 — auth/elder, SCRUM-93).
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
  bool _isLoading = false;

  /// Error proveniente de FirebaseAuth (o de un fallo genérico) que se
  /// muestra bajo el campo Correo hasta que el usuario vuelva a intentar.
  String? _emailServerError;

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
    if (_emailServerError != null) {
      return _emailServerError;
    }
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

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este correo ya tiene una cuenta. ¿Quieres iniciar sesión?';
      case 'invalid-email':
        return 'Ingresa un correo válido';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      default:
        return 'Algo salió mal. Intenta de nuevo.';
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (widget.onRegisterSuccess != null) {
        widget.onRegisterSuccess!();
      } else {
        // TODO: conectar con GoRouter cuando esté implementado el router en core/router/
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _emailServerError = _mapFirebaseAuthError(e.code);
      });
      _formKey.currentState!.validate();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _emailServerError = 'Algo salió mal. Intenta de nuevo.';
      });
      _formKey.currentState!.validate();
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
                  onChanged: (_) {
                    if (_emailServerError != null) {
                      setState(() => _emailServerError = null);
                    }
                  },
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
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.textOnPrimary,
                          ),
                        )
                      : const Text('Crear mi cuenta'),
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
