// data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class UserModel {
  final String uid;
  final String displayName;
  final Timestamp createdAt;
  final bool consentGiven;
  final Timestamp? consentDate;
  final int currentMode;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.createdAt,
    required this.consentGiven,
    this.consentDate,
    required this.currentMode,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid, // en Firestore el uid es el nombre del documento, no un campo interno
      displayName: map['displayName'] as String,
      createdAt: map['createdAt'] as Timestamp,
      consentGiven: map['consentGiven'] as bool,
      consentDate: map['consentDate'] as Timestamp?,
      currentMode: map['currentMode'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'createdAt': createdAt,
      'consentGiven': consentGiven,
      'consentDate': consentDate,
      'currentMode': currentMode,
    };
  }

  User toEntity() {
    return User(
      uid: uid,
      displayName: displayName,
      createdAt: createdAt.toDate(),
      consentGiven: consentGiven,
      consentDate: consentDate?.toDate(),
      currentMode: currentMode,
    );
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      uid: entity.uid,
      displayName: entity.displayName,
      createdAt: Timestamp.fromDate(entity.createdAt),
      consentGiven: entity.consentGiven,
      consentDate: entity.consentDate != null
          ? Timestamp.fromDate(entity.consentDate!)
          : null,
      currentMode: entity.currentMode,
    );
  }
}