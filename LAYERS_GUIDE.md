# AuroraCare — LAYERS_GUIDE.md — Guía breve de estructura de capas y normas de uso

Septiembre 2026 · Uso interno del equipo y Claude Code · SCRUM-84

**Relacionado:** ARCHITECTURE.md v2.2 (secciones 3 y 4) · STATE_MANAGEMENT.md

> ⚠️ **Instrucción para Claude Code**
> Lee este documento junto con ARCHITECTURE.md al inicio de cualquier sesión de desarrollo. Es la versión resumida — para el detalle completo de cada decisión, ver ARCHITECTURE.md.

---

## 1. Para qué sirve cada capa

| Capa | En una frase |
| --- | --- |
| **presentation/** | Lo que el usuario ve y toca. Pantallas, widgets, Notifiers de Riverpod. No sabe que existe Firestore. |
| **domain/** | Las reglas del negocio, puras. Entidades, contratos de repositorio, casos de uso. No sabe que existe Flutter ni Firestore. |
| **data/** | La conexión con el mundo real. Modelos que saben serializar, implementaciones de repositorio que hablan con Firestore/FastAPI. |
| **core/** | Lo transversal que cualquier capa puede necesitar. Constantes, tema visual, router, providers que no pertenecen a ninguna capa específica (ej: Firestore). |

## 2. Reglas de dependencia — quién puede importar a quién

```
presentation/  ──depende de──►  domain/
data/          ──depende de──►  domain/
domain/        ──no depende de nadie──
core/          ──lo puede importar cualquiera──
```

> 🔒 **Regla absoluta**
> `domain/` nunca importa nada de `data/` ni de `presentation/`. Es la capa más protegida — no conoce Firebase, no conoce Flutter, no conoce Riverpod. Si un archivo dentro de `domain/` necesita un `import` de Firebase o de `flutter/material.dart`, algo está mal ubicado.

`presentation/` y `data/` nunca se hablan directamente entre sí — solo se conectan a través de `domain/` (contratos de repositorio y casos de uso) y de los providers de inyección de dependencias (ver sección 4).

## 3. El flujo completo, de punta a punta

Ejemplo real ya construido en el repo — iniciar una sesión de juego:

```
Pantalla (presentation/games/)
   │ usa
   ▼
SessionResultNotifier (presentation/games/session_result_notifier.dart)
   │ llama a
   ▼
StartSession (domain/usecases/start_session.dart)          ← caso de uso
   │ llama a
   ▼
SessionRepository (domain/repositories/session_repository.dart)   ← contrato, sin implementación
   │ implementado por
   ▼
SessionRepositoryImpl (data/repositories/session_repository_impl.dart)  ← habla con Firestore de verdad
   │ traduce con
   ▼
SessionModel ↔ Session (data/models/session_model.dart ↔ domain/entities/session.dart)
```

La pantalla nunca ve `SessionRepositoryImpl` ni `SessionModel` directamente — solo conoce `Session` (la entidad) y `StartSession` (el caso de uso).

## 4. Convenciones de nombres ya establecidas

| Qué es | Convención | Ejemplo |
| --- | --- | --- |
| Entidad de dominio | Sin sufijo, vive en `domain/entities/` | `Session`, `User` |
| Modelo de datos | Sufijo `Model`, vive en `data/models/` | `SessionModel`, `UserModel` |
| Contrato de repositorio | Sufijo `Repository`, abstracto, vive en `domain/repositories/` | `SessionRepository` |
| Implementación de repositorio | Sufijo `RepositoryImpl`, vive en `data/repositories/` | `SessionRepositoryImpl` |
| Caso de uso | Verbo + sustantivo, implementa `UseCase<ReturnType, Params>`, vive en `domain/usecases/` | `StartSession` |
| Parámetros de un caso de uso | Sufijo `Params` | `StartSessionParams` |
| Provider de inyección de dependencias | Sufijo `.provider.dart` (con punto), junto a la pieza que arma | `start_session.provider.dart` |
| Provider de estado de UI | Sufijo `_provider.dart` (con guión bajo), en `presentation/` | `selected_game_provider.dart` |
| Notifier de estado asíncrono | Sufijo `Notifier`, extiende `AsyncNotifier`, en `presentation/` | `SessionResultNotifier` |

Ver STATE_MANAGEMENT.md para el detalle completo de cuándo usar cada patrón de estado.

## 5. Checklist antes de abrir un Pull Request

- [ ] ¿Algún archivo en `domain/` importa algo de `data/`, `presentation/` o de un paquete de Firebase? → Muévelo o revísalo con Daniela.
- [ ] ¿Una pantalla llama directo a Firebase/Firestore/FastAPI en vez de pasar por un caso de uso? → No debería — ver sección 3.
- [ ] ¿Un nuevo repositorio, modelo o caso de uso sigue la nomenclatura de la sección 4?
- [ ] ¿El PR toca `data/` o `domain/`? → Requiere revisión obligatoria de Daniela (Flujo_Trabajo_Git_AuroraCare.md, sección 5).
- [ ] ¿Hay texto visible bajo 18sp sin que sea una excepción ya documentada (como `fieldError`)? → Revisar contra ARCHITECTURE.md sección 11.

---

AuroraCare · LAYERS_GUIDE.md v1.0 · Septiembre 2026 · Daniela Castillo, Benjamín Valle, Eduardo Villanueva · Duoc UC / Dictuc S.A.
