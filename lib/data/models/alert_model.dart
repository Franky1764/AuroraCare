// data/models/alert_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/alert.dart';

class AlertModel {
  final String alertId;
  final String uuid;
  final String type;
  final String level;
  final Timestamp generatedAt;
  final String message;

  const AlertModel({
    required this.alertId,
    required this.uuid,
    required this.type,
    required this.level,
    required this.generatedAt,
    required this.message,
  });

  factory AlertModel.fromMap(String alertId, Map<String, dynamic> map) {
    return AlertModel(
      alertId: alertId,
      uuid: map['uuid'] as String,
      type: map['type'] as String,
      level: map['level'] as String,
      generatedAt: map['generatedAt'] as Timestamp,
      message: map['message'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'type': type,
      'level': level,
      'generatedAt': generatedAt,
      'message': message,
    };
  }

  Alert toEntity() {
    return Alert(
      alertId: alertId,
      uuid: uuid,
      type: type,
      level: level,
      generatedAt: generatedAt.toDate(),
      message: message,
    );
  }

  factory AlertModel.fromEntity(Alert entity) {
    return AlertModel(
      alertId: entity.alertId,
      uuid: entity.uuid,
      type: entity.type,
      level: entity.level,
      generatedAt: Timestamp.fromDate(entity.generatedAt),
      message: entity.message,
    );
  }
}