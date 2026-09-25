// data/repositories/auth_repository_impl.provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/firebase_providers.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  return AuthRepositoryImpl(firebaseAuth, firestore);
});