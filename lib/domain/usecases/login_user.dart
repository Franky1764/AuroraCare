// domain/usecases/login_user.dart
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class LoginUser implements UseCase<User, LoginUserParams> {
  final AuthRepository repository;

  const LoginUser(this.repository);

  @override
  Future<User> call(LoginUserParams params) {
    return repository.loginElder(email: params.email, password: params.password);
  }
}

class LoginUserParams {
  final String email;
  final String password;

  const LoginUserParams({required this.email, required this.password});
}