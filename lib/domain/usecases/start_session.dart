// domain/usecases/start_session.dart
import '../entities/session.dart';
import '../repositories/session_repository.dart';
import 'usecase.dart';

class StartSession implements UseCase<void, StartSessionParams> {
  final SessionRepository repository;

  const StartSession(this.repository);

  @override
  Future<void> call(StartSessionParams params) {
    return repository.saveSession(params.session);
  }
}

/// Agrupa los datos que necesita este caso de uso para ejecutarse.
class StartSessionParams {
  final Session session;

  const StartSessionParams(this.session);
}