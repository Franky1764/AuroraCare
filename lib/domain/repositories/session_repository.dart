// domain/repositories/session_repository.dart
import '../entities/session.dart';

abstract class SessionRepository {
  /// Guarda una sesión de juego recién terminada.
  Future<void> saveSession(Session session);

  /// Trae las últimas [limit] sesiones de un usuario, para calcular tendencia.
  Future<List<Session>> getRecentSessions(String uuid, {int limit = 5});

  /// Trae las sesiones de un usuario en los últimos [days] días,
  /// para la ventana de 28 días que usa el scoring.
  Future<List<Session>> getSessionsInWindow(String uuid, {int days = 28});
}