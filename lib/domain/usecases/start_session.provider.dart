// domain/usecases/start_session.provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/session_repository_impl.provider.dart';
import 'start_session.dart';

/// El caso de uso, ya armado con su repositorio inyectado.
final startSessionProvider = Provider<StartSession>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return StartSession(repository);
});