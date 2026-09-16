// data/models/session_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/session.dart';
import '../../domain/entities/cognitive_metrics.dart';

class SessionModel {
  final String sessionId;
  final String uuid;
  final String domain;
  final String gameType;
  final Timestamp startTime;
  final Timestamp endTime;
  final Map<String, dynamic> metrics; // en Firestore, las métricas SÍ se guardan como mapa

  const SessionModel({
    required this.sessionId,
    required this.uuid,
    required this.domain,
    required this.gameType,
    required this.startTime,
    required this.endTime,
    required this.metrics,
  });

  factory SessionModel.fromMap(String sessionId, Map<String, dynamic> map) {
    return SessionModel(
      sessionId: sessionId,
      uuid: map['uuid'] as String,
      domain: map['domain'] as String,
      gameType: map['gameType'] as String,
      startTime: map['startTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp,
      metrics: Map<String, dynamic>.from(map['metrics'] as Map),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'domain': domain,
      'gameType': gameType,
      'startTime': startTime,
      'endTime': endTime,
      'metrics': metrics,
    };
  }

  // Aquí ocurre la traducción clave: de mapa genérico a ficha específica según el dominio
  Session toEntity() {
    return Session(
      sessionId: sessionId,
      uuid: uuid,
      domain: domain,
      gameType: gameType,
      startTime: startTime.toDate(),
      endTime: endTime.toDate(),
      metrics: _parseMetrics(domain, metrics),
    );
  }

  static CognitiveMetrics _parseMetrics(String domain, Map<String, dynamic> map) {
    switch (domain) {
      case 'memoria':
        return MemoriaMetrics(
          errores: map['errores'] as int,
          intentos: map['intentos'] as int,
          tiempoSegundos: map['tiempoSegundos'] as int,
        );
      case 'atencion':
        return AtencionMetrics(
          tiempoRespuestaMs: map['tiempoRespuestaMs'] as int,
          tasaErrorPct: (map['tasaErrorPct'] as num).toDouble(),
          longitudAlcanzada: map['longitudAlcanzada'] as int,
        );
      case 'praxias':
        return PraxiasMetrics(
          precisionPct: (map['precisionPct'] as num).toDouble(),
          correcciones: map['correcciones'] as int,
          tiempoSegundos: map['tiempoSegundos'] as int,
        );
      default:
        throw ArgumentError('Dominio desconocido: $domain');
    }
  }

  factory SessionModel.fromEntity(Session entity) {
    return SessionModel(
      sessionId: entity.sessionId,
      uuid: entity.uuid,
      domain: entity.domain,
      gameType: entity.gameType,
      startTime: Timestamp.fromDate(entity.startTime),
      endTime: Timestamp.fromDate(entity.endTime),
      metrics: _metricsToMap(entity.metrics),
    );
  }

  static Map<String, dynamic> _metricsToMap(CognitiveMetrics metrics) {
    if (metrics is MemoriaMetrics) {
      return {
        'errores': metrics.errores,
        'intentos': metrics.intentos,
        'tiempoSegundos': metrics.tiempoSegundos,
      };
    } else if (metrics is AtencionMetrics) {
      return {
        'tiempoRespuestaMs': metrics.tiempoRespuestaMs,
        'tasaErrorPct': metrics.tasaErrorPct,
        'longitudAlcanzada': metrics.longitudAlcanzada,
      };
    } else if (metrics is PraxiasMetrics) {
      return {
        'precisionPct': metrics.precisionPct,
        'correcciones': metrics.correcciones,
        'tiempoSegundos': metrics.tiempoSegundos,
      };
    }
    throw ArgumentError('Tipo de métrica desconocido');
  }
}