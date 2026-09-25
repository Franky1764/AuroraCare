// domain/repositories/auth_repository.dart
import '../entities/user.dart';

abstract class AuthRepository {
  /// Crea la cuenta del adulto mayor y su perfil inicial. Lanza [AuthException] si falla.
  Future<User> registerElder({
    required String displayName,
    required String email,
    required String password,
  });

  Future<User> loginElder({
    required String email,
    required String password,
  });

  Future<void> sendPasswordReset({required String email});

  Future<void> logout();
}