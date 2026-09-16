// domain/entities/cognitive_metrics.dart

abstract class CognitiveMetrics {
  const CognitiveMetrics();
}

class MemoriaMetrics extends CognitiveMetrics {
  final int errores;
  final int intentos;
  final int tiempoSegundos;

  const MemoriaMetrics({
    required this.errores,
    required this.intentos,
    required this.tiempoSegundos,
  });
}

class AtencionMetrics extends CognitiveMetrics {
  final int tiempoRespuestaMs;
  final double tasaErrorPct;
  final int longitudAlcanzada;

  const AtencionMetrics({
    required this.tiempoRespuestaMs,
    required this.tasaErrorPct,
    required this.longitudAlcanzada,
  });
}

class PraxiasMetrics extends CognitiveMetrics {
  final double precisionPct;
  final int correcciones;
  final int tiempoSegundos;

  const PraxiasMetrics({
    required this.precisionPct,
    required this.correcciones,
    required this.tiempoSegundos,
  });
}