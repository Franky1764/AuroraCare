// data/models/caregiver_link_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/caregiver_link.dart';

class CaregiverLinkModel {
  final String linkId;
  final String adultUuid;
  final String caregiverUid;
  final Timestamp linkedAt;
  final String status; // se guarda como texto en Firestore: 'active' o 'revoked'

  const CaregiverLinkModel({
    required this.linkId,
    required this.adultUuid,
    required this.caregiverUid,
    required this.linkedAt,
    required this.status,
  });

  factory CaregiverLinkModel.fromMap(String linkId, Map<String, dynamic> map) {
    return CaregiverLinkModel(
      linkId: linkId,
      adultUuid: map['adultUUID'] as String,
      caregiverUid: map['caregiverUID'] as String,
      linkedAt: map['linkedAt'] as Timestamp,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adultUUID': adultUuid,
      'caregiverUID': caregiverUid,
      'linkedAt': linkedAt,
      'status': status,
    };
  }

  CaregiverLink toEntity() {
    return CaregiverLink(
      linkId: linkId,
      adultUuid: adultUuid,
      caregiverUid: caregiverUid,
      linkedAt: linkedAt.toDate(),
      status: status == 'active' ? LinkStatus.active : LinkStatus.revoked,
    );
  }

  factory CaregiverLinkModel.fromEntity(CaregiverLink entity) {
    return CaregiverLinkModel(
      linkId: entity.linkId,
      adultUuid: entity.adultUuid,
      caregiverUid: entity.caregiverUid,
      linkedAt: Timestamp.fromDate(entity.linkedAt),
      status: entity.status == LinkStatus.active ? 'active' : 'revoked',
    );
  }
}