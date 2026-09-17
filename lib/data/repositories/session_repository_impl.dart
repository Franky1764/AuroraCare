// data/repositories/session_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../models/session_model.dart';

class SessionRepositoryImpl implements SessionRepository {
  final FirebaseFirestore firestore;

  const SessionRepositoryImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _sessionsCollection =>
      firestore.collection('sessions');

  @override
  Future<void> saveSession(Session session) async {
    final model = SessionModel.fromEntity(session);
    await _sessionsCollection.doc(session.sessionId).set(model.toMap());
  }

  @override
  Future<List<Session>> getRecentSessions(String uuid, {int limit = 5}) async {
    final snapshot = await _sessionsCollection
        .where('uuid', isEqualTo: uuid)
        .orderBy('startTime', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => SessionModel.fromMap(doc.id, doc.data()).toEntity())
        .toList();
  }

  @override
  Future<List<Session>> getSessionsInWindow(String uuid, {int days = 28}) async {
    final since = DateTime.now().subtract(Duration(days: days));

    final snapshot = await _sessionsCollection
        .where('uuid', isEqualTo: uuid)
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(since))
        .orderBy('startTime', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => SessionModel.fromMap(doc.id, doc.data()).toEntity())
        .toList();
  }
}