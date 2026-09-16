// domain/entities/cognitive_profile.dart
class CognitiveProfile {
  final String uuid;
  final String deviceId;
  final DateTime createdAt;
  final int activeMode; // 1, 2 o 3

  const CognitiveProfile({
    required this.uuid,
    required this.deviceId,
    required this.createdAt,
    required this.activeMode,
  });
}