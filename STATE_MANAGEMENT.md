# AuroraCare — STATE_MANAGEMENT.md — Convención de gestión de estado en presentation/

Septiembre 2026 · Uso interno del equipo y Claude Code · SCRUM-82

**Relacionado:** ARCHITECTURE.md v2.2 (sección 3 — Stack tecnológico, sección 4 — Arquitectura de capas)

> ⚠️ **Instrucción para Claude Code**
> Este documento define cómo se maneja el estado en la capa `presentation/`. Aplica junto con ARCHITECTURE.md. Ningún cambio a esta convención sin revisión de Daniela.

---

## 1. Por qué este documento existe

ARCHITECTURE.md ya establece que el equipo usa **Riverpod exclusivamente** — no Provider, no Bloc (sección 3). Pero Riverpod ofrece varias formas de manejar estado, y sin una convención explícita, cada integrante del equipo puede terminar usando un estilo distinto para el mismo tipo de problema. Este documento cierra esa decisión.

## 2. Regla general

| Situación | Herramienta de Riverpod |
| --- | --- |
| La pantalla depende de un caso de uso (`domain/usecases/`) — hay una llamada asíncrona a un repositorio, a Firestore o a FastAPI | `AsyncNotifierProvider` |
| Estado de interfaz puro, sin red ni asincronía — qué opción está seleccionada, si un panel está abierto, un contador de pasos en un formulario | `Provider` o `StateProvider` |

> 🔑 **Regla de oro**
> Si la acción del usuario dispara un caso de uso (`domain/usecases/`), usa `AsyncNotifierProvider`. Si solo cambia algo visual en pantalla sin tocar datos externos, usa `Provider`/`StateProvider`. No se usa `StateNotifierProvider` (estilo Riverpod 1.x) en código nuevo — está en camino a quedar obsoleto en el ecosistema Riverpod.

## 3. Patrón — AsyncNotifierProvider para casos de uso

Todo Notifier que dispare un caso de uso sigue esta misma forma. El caso de uso se obtiene desde su propio provider (definido en `domain/usecases/*.provider.dart`, ver convención de inyección de dependencias de SCRUM-81), nunca instanciado a mano dentro del Notifier.

```dart
// presentation/<módulo>/<algo>_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/<entidad>.dart';
import '../../domain/usecases/<caso_de_uso>.provider.dart';
import '../../domain/usecases/<caso_de_uso>.dart';

class AlgoNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Estado inicial — normalmente vacío, nada cargado todavía.
  }

  Future<void> ejecutarAccion(ParametrosDeEntrada datos) async {
    state = const AsyncLoading();
    final casoDeUso = ref.read(casoDeUsoProvider);
    state = await AsyncValue.guard(
      () => casoDeUso(ParamsDelCasoDeUso(datos)),
    );
  }
}

final algoProvider = AsyncNotifierProvider<AlgoNotifier, void>(
  AlgoNotifier.new,
);
```

**En la pantalla**, el consumo siempre usa `.when()` sobre los tres estados que Riverpod maneja automáticamente — cargando, error, y con datos. Ninguna pantalla mantiene banderas manuales de `isLoading` o `hasError`:

```dart
ref.watch(algoProvider).when(
  loading: () => const CircularProgressIndicator(),
  error: (e, _) => const Text('Algo salió mal. Intenta de nuevo.'),
  data: (_) => const Text('Listo.'),
);
```

### 3.1 Ejemplo real — envío de una sesión de juego (F4)

```dart
// presentation/games/session_result_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/start_session.provider.dart';
import '../../domain/usecases/start_session.dart';

class SessionResultNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

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
```

## 4. Patrón — Provider / StateProvider para estado de UI simple

Para estado que no involucra una llamada asíncrona ni un caso de uso, no se justifica el aparataje de `AsyncNotifier`. Se usa `StateProvider` directo:

```dart
// presentation/games/selected_game_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Qué juego está seleccionado actualmente en el menú (F4, pantalla 1).
final selectedGameProvider = StateProvider<String?>((ref) => null);
```

```dart
// En la pantalla:
ref.watch(selectedGameProvider);              // leer
ref.read(selectedGameProvider.notifier).state = 'memorice_clasico'; // actualizar
```

## 5. Nomenclatura de archivos

| Tipo de archivo | Convención de nombre | Ubicación |
| --- | --- | --- |
| Notifier asíncrono ligado a un caso de uso | `<algo>_notifier.dart` | `presentation/<módulo>/` |
| Provider de estado de UI simple | `<algo>_provider.dart` | `presentation/<módulo>/` |
| Provider de inyección de dependencias (repositorio, caso de uso) | `<algo>.provider.dart` (con punto, no guión bajo) | Junto a la pieza que representa — ver convención de SCRUM-81 |

> 📌 Nota de nomenclatura
> Los providers de `presentation/` usan guión bajo antes de `provider` (`selected_game_provider.dart`). Los providers de inyección de dependencias de `data/` y `domain/` usan punto antes de `provider` (`session_repository_impl.provider.dart`). Esta diferencia es intencional: distingue a simple vista un provider de estado de UI de un provider de "armado" de objetos.

## 6. Qué NO hacer

- No usar `StateNotifierProvider` en código nuevo.
- No instanciar un caso de uso a mano dentro de un widget o un Notifier (`StartSession(SessionRepositoryImpl(FirebaseFirestore.instance))`) — siempre a través de su provider correspondiente (SCRUM-81).
- No mantener banderas manuales de `bool isLoading` junto a un `AsyncNotifier` — el propio `AsyncValue` ya expone loading/error/data.
- No mezclar lógica de negocio dentro del Notifier — el Notifier solo orquesta el llamado al caso de uso y expone el resultado; la lógica en sí vive en `domain/`.

---

AuroraCare · STATE_MANAGEMENT.md v1.0 · Septiembre 2026 · Daniela Castillo, Benjamín Valle, Eduardo Villanueva · Duoc UC / Dictuc S.A.
