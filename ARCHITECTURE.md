# AuroraCare — ARCHITECTURE.md — Documento Maestro de Arquitectura v2.1

Agosto 2026 · Uso interno del equipo y Claude Code

**Plataforma:** Android · Google Play MVP diciembre 2026
**Stack:** Flutter · Firebase · FastAPI · OpenAI
**Equipo:** Daniela Castillo (líder) · Benjamín Valle · Eduardo Villanueva
**Marco legal:** Ley 21.719 Chile · Privacy by Design

> ⚠️ **Instrucción para Claude Code**
> Este documento es el contexto de arquitectura de AuroraCare. Pégalo al inicio de cada sesión de desarrollo. Toda decisión técnica debe respetar: (1) separación de identidad y datos comportamentales, (2) arquitectura de capas, (3) Riverpod como gestor de estado, (4) tres modos de uso del adulto mayor, (5) cumplimiento Ley 21.719. Ningún cambio a capas `data/` o `domain/` sin revisión de Daniela.

---

## 1. Visión y propuesta de valor

AuroraCare es una aplicación móvil Android de estimulación cognitiva para personas mayores. El adulto mayor decide cómo usarla: desde estimulación libre sin registro, hasta seguimiento personal de tendencias, hasta vinculación con un cuidador. No emite diagnósticos médicos y no vincula la identidad del usuario a sus datos de comportamiento.

| | |
| --- | --- |
| **Problema** | El deterioro cognitivo en adultos mayores se detecta tarde. Las familias no tienen herramientas accesibles de seguimiento preventivo. Y los adultos mayores no tienen herramientas de estimulación cognitiva diseñadas para su contexto. |
| **Solución** | Estimulación cognitiva en dominios clave (memoria, atención, praxias) + seguimiento opcional de tendencias + reporte exportable para el médico + dashboard opcional para cuidador. |
| **No es** | Un dispositivo médico. No diagnostica. No reemplaza al médico ni al psicólogo. Es una herramienta de bienestar, estimulación y acompañamiento cognitivo. |
| **Usuario 1** | Adulto mayor — Android gama media-baja. Puede usarla solo o asistido en talleres y clubes. |
| **Usuario 2** | Cuidador — accede solo si el adulto mayor lo vincula. Ve señales interpretadas, no datos crudos. |
| **Entrega** | Google Play Store — MVP funcional y publicado, diciembre 2026. |
| **Destino** | Transferencia tecnológica a la Municipalidad de Huechuraba (DIDECO), con proyección de expansión a otras municipalidades. |

---

## 2. Modos de uso — decisión del adulto mayor

El adulto mayor elige su modo de uso al registrarse y puede cambiarlo en cualquier momento. El consentimiento es granular — cada modo activa solo los datos que requiere.

| Modo | Descripción | Datos que se generan |
| --- | --- | --- |
| **Modo 1 — Estimulación libre** | Accede a todos los juegos y actividades sin registro de métricas. Sin cuidador vinculado. Uso anónimo completo. | Firebase Analytics (agregado, sin identificación). Cero Firestore. |
| **Modo 2 — Seguimiento personal** | Activa registro de métricas para ver su propio progreso. Ve sus tendencias en el tiempo. Sin cuidador. | UUID anónimo + métricas de sesión en Firestore. Requiere consentimiento explícito. |
| **Modo 3 — Con cuidador** | Todo lo del Modo 2 más vinculación QR con un cuidador que recibe señales de tendencia. | UUID + métricas + alertas en Firestore. Consentimiento granular en dos pasos. |

> 🔑 **Regla de oro de los modos**
> Solo el adulto mayor puede iniciar el cambio de modo y el vínculo con el cuidador. El cuidador nunca puede solicitar acceso. El adulto mayor puede desvincularse en cualquier momento desde la app.

---

## 3. Stack tecnológico

| | |
| --- | --- |
| **Flutter 3.x** | Framework principal. Compila a Android nativo. Un solo codebase para el equipo. |
| **Riverpod 2.x** | Gestión de estado. Inmutable, testeable, explícito. Estándar del equipo — no usar Provider ni Bloc. |
| **Firebase Auth** | Autenticación. Solo almacena email/UID. Nunca vinculado a métricas cognitivas. |
| **Cloud Firestore** | Base de datos. Colecciones separadas para identidad y métricas. Solo activo en Modo 2 y 3. |
| **Firebase Analytics** | Analítica de uso anonimizada. Activa en todos los modos. Sin datos identificables ni métricas de sesión. |
| **Firebase Storage** | Assets de los juegos. Sin datos personales. |
| **Python 3.11 + FastAPI** | Backend de análisis. Recibe métricas anonimizadas, aplica scoring local, genera reporte con OpenAI. |
| **OpenAI API** | Solo genera texto interpretable del reporte. NO analiza cognición. La lógica de scoring es 100% local. |
| **GitHub** | Control de versiones. Repositorio privado (`AuroraCare` — código; `APT-AuroraCare` — documentación académica, nunca mezclados). Ramas por feature, PR obligatorio para merge a main. |

> 🔒 **Regla crítica — OpenAI**
> OpenAI recibe solo texto plano generado por el scoring local (ej: "Memoria: score promedio 68.2, tendencia estable, 8 sesiones registradas"). NUNCA recibe nombre, RUT, UUID ni historial personal. El prompt debe auditarse antes de cada envío.

---

## 4. Arquitectura de capas — Flutter

AuroraCare usa arquitectura en capas estricta. Cada integrante del equipo tiene responsabilidad sobre capas específicas. Mezclar responsabilidades entre capas está prohibido sin revisión de Daniela.

| Capa | Responsabilidad | Responsable |
| --- | --- | --- |
| **presentation/** | Pantallas, widgets, controladores Riverpod. Todo lo visual e interactivo. | Benjamín (módulo adulto mayor) · Eduardo (módulo cuidador) |
| **domain/** | Entidades, casos de uso, interfaces de repositorio. Lógica de negocio pura, sin dependencias externas. | Daniela — revisión obligatoria en todo PR |
| **data/** | Implementación de repositorios, modelos Firestore, llamadas a FastAPI. | Daniela — revisión obligatoria en todo PR |
| **core/** | Constantes, tema visual, router, utilidades, manejo de errores centralizado. | Daniela |

### 4.1 Estructura de carpetas

```
lib/
  core/
    constants/        → colores, strings, rutas de navegación
    theme/             → tema visual AuroraCare (tipografía, colores, botones)
    utils/             → helpers, formatters, extensiones
    errors/            → manejo centralizado de errores y excepciones
    router/            → GoRouter — navegación declarativa

  data/
    models/            → UserModel, SessionModel, AlertModel...
    repositories/      → implementación concreta (FirebaseAuthRepo, FirestoreRepo...)
    sources/           → firebase_source.dart, api_source.dart

  domain/
    entities/          → entidades de negocio puras (User, Session, CognitiveScore...)
    repositories/      → interfaces abstractas (contratos)
    usecases/          → StartSession, LinkCaregiver, GenerateReport, ExportReport...

  presentation/
    onboarding/        → welcome, disclaimer médico (F1), selección de modo (F3)
    auth/
      elder/           → login (F2), registro (F1) del adulto mayor
      caregiver/       → registro (F7) y espera del cuidador
    games/             → memorice, secuencias, trazado guiado (F4)
    breathing/         → respiración guiada — sin score (F5)
    progress/          → progreso personal del adulto mayor (F6)
    caregiver_dashboard/
                       → dashboard (F9), vínculo QR (F8)
    reports/           → reporte exportable para médico
    privacy/           → ARCO (F10), desvinculación (F11)
    profile/
    shared/            → widgets reutilizables, componentes accesibles

  main.dart
```

---

## 5. Módulos del MVP

### 5.1 Actividades cognitivas — núcleo del MVP

| Dominio | Actividad | Métricas capturadas (Modo 2 y 3) |
| --- | --- | --- |
| **Memoria** | Memorice — pares de imágenes que el usuario debe encontrar | Tiempo total, errores, intentos, duración de sesión |
| **Atención** | Secuencias — el usuario replica secuencias de estímulos visuales | Tiempo de respuesta, tasa de error, longitud de secuencia alcanzada |
| **Praxias** | Trazado guiado — el usuario traza figuras simples con el dedo en pantalla táctil | Precisión del trazo, tiempo, número de correcciones |
| **Respiración** | Respiración guiada — animación de expansión/contracción con instrucciones | Sin métricas evaluativas. Solo uso en Modo 1 y 2 como bienestar. |

### 5.2 Sistema de reporte para médico (reemplaza MoCA)

AuroraCare no implementa el MoCA ni ningún instrumento diagnóstico licenciado. En cambio, genera un reporte de tendencias cognitivas exportable que el adulto mayor puede compartir con su médico o psicólogo.

- **Contenido del reporte** — tendencias por dominio (memoria, atención, praxias) en las últimas 4 semanas
- **Formato** — PDF generado localmente en el dispositivo — no se almacena en la nube
- **Texto interpretable** — generado por OpenAI a partir del scoring local — en lenguaje claro, sin tecnicismos
- **Disclaimer obligatorio** — el reporte no constituye diagnóstico. Debe ser interpretado por un profesional de la salud
- **Activación** — disponible solo en Modo 2 y Modo 3

### 5.3 Módulos completos del MVP

| | |
| --- | --- |
| **Auth + modos** | Registro, login, consentimiento granular por modo, selección y cambio de modo en cualquier momento. |
| **Juegos cognitivos** | Memorice (memoria), Secuencias (atención), Trazado guiado (praxias). Con captura de métricas en Modo 2 y 3. |
| **Respiración guiada** | Módulo de bienestar. Sin métricas evaluativas. Disponible en todos los modos. |
| **Progreso personal** | Visualización de tendencias propias del adulto mayor. Solo Modo 2 y 3. |
| **Reporte exportable** | PDF local con tendencias interpretadas. Para compartir con médico. Solo Modo 2 y 3. |
| **Dashboard cuidador** | Señales de tendencia interpretadas. Sin datos crudos. Solo Modo 3. |
| **Vínculo QR** | Iniciado exclusivamente por el adulto mayor. El cuidador no puede solicitar acceso. |
| **ARCO completo** | Acceso, Rectificación, Cancelación y Oposición. Eliminar cuenta borra UUID y métricas asociadas. |
| **Disclaimer médico** | Pantalla obligatoria en onboarding. Sin aceptación explícita no hay acceso a la app. |

> ⛔ **Fuera del MVP — v1.1 o posterior**
> Lenguaje cognitivo · Múltiples cuidadores simultáneos · Panel web del cuidador · Gamificación y logros · Integración con sistema de salud · Citas médicas · MoCA u otros instrumentos diagnósticos licenciados · Versión iOS.

---

## 6. Privacidad por diseño — reglas absolutas

> 🔒 **Ley 21.719 — Vigente desde diciembre 2026**
> AuroraCare cumple la Ley 21.719 desde el primer commit. Estas reglas no son opcionales ni negociables. Ningún cambio a la arquitectura de privacidad sin revisión y aprobación de Daniela.

| | |
| --- | --- |
| **Identidad separada** | Firebase Auth maneja identidad (email, UID). Firestore maneja comportamiento (métricas). NUNCA en el mismo documento ni colección. |
| **UUID anónimo** | Al activar Modo 2 o 3, se genera un UUID local en el dispositivo. Es el único vínculo entre sesiones. No se almacena nombre ni email en Firestore. |
| **Firebase Analytics** | Activo en todos los modos. Solo registra eventos agregados (módulo abierto, sesión iniciada). Sin UUID, sin métricas de sesión, sin identificación posible. |
| **Consentimiento granular** | Modo 1: sin consentimiento requerido. Modo 2: consentimiento de métricas. Modo 3: consentimiento de métricas + consentimiento de vínculo con cuidador. Dos pasos independientes. |
| **Cifrado en tránsito** | Toda comunicación Flutter ↔ Firebase y Flutter ↔ FastAPI usa HTTPS/TLS. Sin excepciones. |
| **Reporte local** | Los reportes PDF se generan en el dispositivo. No se almacenan en la nube ni se envían a servidores. |
| **Derechos ARCO** | Flujo completo en la app. Cancelación elimina UUID y todas las métricas asociadas en Firestore. El email en Firebase Auth se elimina por separado. |
| **OpenAI sin PII** | Ningún dato personal ni UUID llega a OpenAI. Solo métricas agregadas en texto plano. Confirmado en la práctica en el spike técnico (ver sección 10.1) — el payload de `/report/generate` no incluye `session_uuid` ni ningún otro identificador. |

---

## 7. Estructura de datos — Firestore

Firestore solo se activa en Modo 2 y Modo 3. En Modo 1 no se escribe ningún documento.

| | |
| --- | --- |
| **users/{uid}** | Perfil básico: displayName, createdAt, consentGiven, consentDate, currentMode. Sin métricas. Sin UUID cognitivo. |
| **cognitive_profiles/{uuid}** | Perfil cognitivo anónimo: uuid (generado local), deviceId, createdAt, activeMode. Sin nombre ni email. |
| **sessions/{sessionId}** | Métricas por sesión: uuid (ref cognitiva), gameType, startTime, endTime, metrics{}. Sin identidad. |
| **caregiver_links/{linkId}** | Vínculo: adultUUID, caregiverUID, linkedAt, status. Iniciado solo por adulto mayor. |
| **alerts/{alertId}** | Señales para cuidador: uuid, type, level, generatedAt, message. Sin datos crudos de sesión. |

> **Nota (sept. 2026):** `caregiver_links` y una futura colección `caregiver_invites` quedan con reglas de seguridad bloqueadas (`allow read, write: if false`) hasta resolver el diseño completo de F8 en Sprint 3. Ver `firestore.rules` en el repo y la discusión de diseño guardada aparte (identity_links, tokens de invitación aleatorios, aceptación mediada por backend).

### 7.1 Reglas de seguridad Firestore base

```
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    match /sessions/{sessionId} {
      allow read: if resource.data.uuid == request.auth.token.uuid;
      allow write: if request.auth != null;
    }
    match /alerts/{alertId} {
      allow read: if request.auth.uid == resource.data.caregiverUID;
    }
    match /cognitive_profiles/{uuid} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 8. Backend — FastAPI

### 8.1 Endpoints MVP

| | |
| --- | --- |
| **POST /session/analyze** | Recibe métricas de sesión anonimizadas, aplica scoring local, retorna señal + nivel de tendencia. |
| **POST /report/generate** | Recibe scoring calculado, llama a OpenAI, retorna texto interpretable del reporte para PDF. |
| **GET /health** | Health check. Flutter verifica conexión antes de cada análisis. |

### 8.2 Flujo de análisis

1. Flutter captura métricas de sesión — tiempo de respuesta, tasa de error, precisión — según el juego
2. FastAPI recibe métricas anonimizadas — solo UUID de sesión, nunca nombre ni email
3. Scoring local calcula señal — algoritmo definido en SCORING.md — sin IA externa
4. Si se solicita reporte (Modo 2 o 3) — FastAPI llama a OpenAI con métricas agregadas en texto plano
5. OpenAI retorna texto interpretable — FastAPI lo devuelve a Flutter para generar el PDF local

> 📌 **Decisión de arquitectura aprobada — no revertir**
> OpenAI es una herramienta de redacción, no el cerebro analítico. El scoring cognitivo es 100% local y auditable en SCORING.md. Esta decisión fue revisada y aprobada formalmente, y validada en la práctica mediante el spike técnico (sección 10.1). Cambiarla requiere justificación documentada y aprobación de Daniela.

---

## 9. Equipo y división de trabajo

| | |
| --- | --- |
| **Daniela Castillo (Líder técnica)** | Arquitectura completa · Capas core, data y domain · Backend FastAPI · Firebase rules · Privacy by Design · Revisión de PRs en capas críticas · Decisiones de privacidad · Coordinación con Municipalidad de Huechuraba (DIDECO) |
| **Benjamín Valle** | Presentación — módulo adulto mayor: onboarding, selección de modo, juegos cognitivos, respiración guiada, pantallas de progreso personal, widgets accesibles |
| **Eduardo Villanueva** | Presentación — módulo cuidador: dashboard de señales, vínculo QR, alertas, reporte exportable, flujo ARCO |

> 📋 **Reglas de trabajo en equipo**
> 1. Nunca hacer push directo a main — siempre rama + PR.
> 2. Cada PR requiere revisión de al menos una compañera.
> 3. Cambios en capas data/ o domain/ requieren revisión de Daniela.
> 4. Cambios en reglas de Firestore o en arquitectura de privacidad requieren aprobación de Daniela.
> 5. Documentar cada decisión importante en este archivo — versionar con fecha.

Ver también `Flujo_Trabajo_Git_AuroraCare.md` para el detalle paso a paso del flujo de ramas y Pull Requests.

---

## 10. Spike técnico — Semana 1 (22 agosto)

Antes de construir cualquier pantalla, validar que la integración completa funciona. Criterio de éxito: una pantalla Flutter muestra texto generado por OpenAI a través de FastAPI, usando métricas de prueba anonimizadas.

- **Paso 1** — Flutter: botón que llama a GET /health y muestra 'OK' en pantalla
- **Paso 2** — FastAPI POST /session/analyze: recibe JSON de prueba, retorna scoring calculado
- **Paso 3** — FastAPI POST /report/generate: recibe scoring, llama a OpenAI, retorna texto
- **Paso 4** — Flutter muestra el texto retornado en pantalla — fin del spike

> 🚨 **Plan B — si el spike falla en semana 1**
> Si FastAPI + OpenAI no funciona en 5 días: eliminar OpenAI del MVP y generar el texto del reporte con plantillas locales en Flutter. El scoring cognitivo no cambia — solo el formato del reporte cambia de texto generado por IA a texto de plantilla fija. Esta decisión debe tomarse antes del domingo 27 de agosto, no después.

### 10.1 Resultado del spike — Validado ✅

**Fecha de validación:** 4 de septiembre de 2026

El spike técnico se ejecutó y validó exitosamente, cumpliendo el criterio de éxito definido arriba: una pantalla Flutter mostró texto generado por OpenAI a través de FastAPI, usando métricas de prueba anonimizadas.

**No fue necesario activar el Plan B** (plantillas locales) — la integración Flutter → FastAPI → OpenAI funcionó de punta a punta.

| Paso | Resultado |
| --- | --- |
| 1. `GET /health` | OK — FastAPI responde correctamente |
| 2. `POST /session/analyze` | OK — scoring simplificado de prueba calculado y devuelto |
| 3. `POST /report/generate` | OK — modelo `gpt-5.6-luna` generó texto de reporte respetando todas las reglas de lenguaje (sin palabras prohibidas, con disclaimer médico, bajo 150 palabras) |
| 4. Flutter muestra el texto en pantalla | OK — confirmado visualmente en emulador Android (Medium_Phone_API_36.1) |

**Nota de arquitectura confirmada en la práctica:** el emulador Android no resuelve `localhost`/`127.0.0.1` hacia la máquina host — requiere la dirección especial `10.0.2.2`. Esto queda documentado en el código (`lib/main.dart`, constante `baseUrl` en la versión del spike) para que el equipo no repita el mismo diagnóstico. Si en el futuro se prueba en un dispositivo físico (USB o WiFi), esta dirección debe cambiar a la IP real de la máquina host en la red local.

**Nota de proceso (sept. 2026):** tras validar el spike, la pantalla de prueba (`SpikeScreen`) fue reemplazada por la estructura real de capas (ver sección 4.1). El código del spike queda disponible en el historial de git de la rama `main`/`develop` si se necesita consultar, pero no se mantiene como pantalla activa — su propósito (validar la integración) ya se cumplió y quedó documentado aquí.

**Próximo paso:** con el spike validado, el desarrollo continúa con la estructura de carpetas por capas (sección 4) y la integración de Firebase para los flujos F1-F2 (registro y login del adulto mayor).

---

## 11. Estándares de código y accesibilidad

| | |
| --- | --- |
| **Lenguaje** | Dart (Flutter) + Python (FastAPI). Comentarios de lógica de negocio en español, código en inglés. |
| **Nombrado** | camelCase para variables/funciones · PascalCase para clases · snake_case para archivos. |
| **Estado** | Riverpod exclusivamente. No usar setState() fuera de widgets simples sin lógica de negocio. |
| **Commits** | Convención: feat: / fix: / docs: / refactor: / test:  Ejemplo: feat: agregar juego memorice |
| **Ramas** | main (producción) · develop (integración) · feature/nombre-feature (desarrollo) |
| **Fuente mínima** | 18sp en todo texto visible. Títulos 22sp mínimo. |
| **Contraste** | Mínimo 4.5:1 para texto normal. 3:1 para texto grande. Verificar con herramienta antes de PR. |
| **Botones** | Área táctil mínima 48x48dp. Texto de botón descriptivo — nunca solo un ícono sin label. |
| **Lenguaje UX** | Sin tecnicismos. Sin anglicismos. Texto en español claro, frases cortas, verbos en infinitivo. |
| **Rendimiento** | Optimizar assets para gama media-baja. Probar en dispositivo físico real, no solo emulador. |

---

AuroraCare · ARCHITECTURE.md v2.1 · Septiembre 2026 · Daniela Castillo, Benjamín Valle, Eduardo Villanueva · Duoc UC
