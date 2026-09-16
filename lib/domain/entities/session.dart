// domain/entities/session.dart
import 'cognitive_metrics.dart';

class Session {
  final String sessionId;
  final String uuid;
  final String domain; // 'memoria', 'atencion' o 'praxias'
  final String gameType; // el juego específico, ej: 'memorice_clasico'
  final DateTime startTime;
  final DateTime endTime;
  final CognitiveMetrics metrics;

  const Session({
    required this.sessionId,
    required this.uuid,
    required this.domain,
    required this.gameType,
    required this.startTime,
    required this.endTime,
    required this.metrics,
  });
}