// data/models/cognitive_profile_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cognitive_profile.dart';

class CognitiveProfileModel {
  final String uuid;
  final String deviceId;
  final Timestamp createdAt;
  final int activeMode;

  const CognitiveProfileModel({
    required this.uuid,
    required this.deviceId,
    required this.createdAt,
    required this.activeMode,
  });

  // Firestore -> Model
  factory CognitiveProfileModel.fromMap(Map<String, dynamic> map) {
    return CognitiveProfileModel(
      uuid: map['uuid'] as String,
      deviceId: map['deviceId'] as String,
      createdAt: map['createdAt'] as Timestamp,
      activeMode: map['activeMode'] as int,
    );
  }

  // Model -> Firestore
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'deviceId': deviceId,
      'createdAt': createdAt,
      'activeMode': activeMode,
    };
  }

  // Model -> Entity (esto es "el mapeo entre capas")
  CognitiveProfile toEntity() {
    return CognitiveProfile(
      uuid: uuid,
      deviceId: deviceId,
      createdAt: createdAt.toDate(),
      activeMode: activeMode,
    );
  }

  // Entity -> Model (para cuando domain/usecases necesita guardar algo)
  factory CognitiveProfileModel.fromEntity(CognitiveProfile entity) {
    return CognitiveProfileModel(
      uuid: entity.uuid,
      deviceId: entity.deviceId,
      createdAt: Timestamp.fromDate(entity.createdAt),
      activeMode: entity.activeMode,
    );
  }
}