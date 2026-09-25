// domain/usecases/register_user.dart
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class RegisterUser implements UseCase<User, RegisterUserParams> {
  final AuthRepository repository;

  const RegisterUser(this.repository);

  @override
  Future<User> call(RegisterUserParams params) {
    return repository.registerElder(
      displayName: params.displayName,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterUserParams {
  final String displayName;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.displayName,
    required this.email,
    required this.password,
  });
}