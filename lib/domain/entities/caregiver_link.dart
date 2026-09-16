// domain/entities/caregiver_link.dart
enum LinkStatus { active, revoked } 

class CaregiverLink {
  final String linkId;
  final String adultUuid;
  final String caregiverUid;
  final DateTime linkedAt;
  final LinkStatus status;

  const CaregiverLink({
    required this.linkId,
    required this.adultUuid,
    required this.caregiverUid,
    required this.linkedAt,
    required this.status,
  });
}