// domain/entities/alert.dart
class Alert {
  final String alertId;
  final String uuid;
  final String type; // ej: 'memoria', 'atencion', 'praxias'
  final String level; // 'verde', 'azul', 'amarillo', 'rojo', 'gris'
  final DateTime generatedAt;
  final String message;

  const Alert({
    required this.alertId,
    required this.uuid,
    required this.type,
    required this.level,
    required this.generatedAt,
    required this.message,
  });
}