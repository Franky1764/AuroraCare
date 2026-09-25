// presentation/games/session_result_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/start_session.provider.dart';
import '../../domain/usecases/start_session.dart';

class SessionResultNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Estado inicial: nada cargado todavía.
  }

  Future<void> submitSession(Session session) async {
    state = const AsyncLoading();
    final startSession = ref.read(startSessionProvider);
    state = await AsyncValue.guard(
      () => startSession(StartSessionParams(session)),
    );
  }
}

final sessionResultProvider =
    AsyncNotifierProvider<SessionResultNotifier, void>(
  SessionResultNotifier.new,
);