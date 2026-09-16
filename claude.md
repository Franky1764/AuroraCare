# AuroraCare — Contexto para Claude Code

## Qué es este proyecto
App móvil Android de estimulación cognitiva para adultos mayores.
Cliente: Municipalidad de Huechuraba — DIDECO.
Proyecto de Título — Ingeniería en Informática, Duoc UC Plaza Norte.

## Stack
- Flutter 3.x + Dart
- Riverpod 2.x (único gestor de estado permitido)
- Firebase Auth + Cloud Firestore + Firebase Analytics
- Python 3.11 + FastAPI (backend)
- OpenAI API (solo para texto del reporte, nunca para scoring)

## Equipo
- Daniela Castillo — líder técnica, arquitectura, backend, privacidad
- Benjamín Valle — frontend módulo adulto mayor
- Eduardo Villanueva — frontend módulo cuidador + QA

## Reglas absolutas de arquitectura
- Capas estrictas: core/ data/ domain/ presentation/
- NUNCA mezclar Firebase Auth (identidad) con Firestore cognitivo (métricas)
- NUNCA usar Provider, Bloc ni setState() fuera de widgets simples
- NUNCA hacer push directo a main — siempre rama feature/ + PR a develop
- Cada PR requiere revisión de al menos un compañero
- Cambios en data/ o domain/ requieren revisión de Daniela
- NUNCA modificar la estructura de carpetas de presentation/ sin comparar
  primero contra ARCHITECTURE.md sección 4.1 — este archivo es un resumen,
  ARCHITECTURE.md es la fuente de verdad si hay alguna discrepancia

## Privacidad — Ley 21.719
- UUID anónimo generado localmente al activar Modo 2 o 3
- Identidad (email/UID) y métricas cognitivas NUNCA en el mismo documento Firestore
- OpenAI NUNCA recibe nombre, email, UUID ni datos identificables
- Flujo ARCO completo obligatorio antes de publicar en Play Store

## Estructura de carpetas
lib/
  core/
    constants/            → colores, strings, rutas de navegación
    theme/                → tema visual AuroraCare
    utils/                → helpers, formatters, extensiones
    errors/               → manejo centralizado de errores
    router/               → GoRouter — navegación declarativa
  data/
    models/               → UserModel, SessionModel, AlertModel...
    repositories/         → implementación concreta (FirebaseAuthRepo, FirestoreRepo...)
    sources/              → firebase_source.dart, api_source.dart
  domain/
    entities/             → entidades de negocio puras (User, Session, CognitiveScore...)
    repositories/         → interfaces abstractas (contratos)
    usecases/             → StartSession, LinkCaregiver, GenerateReport, ExportReport...
  presentation/
    onboarding/           → welcome, disclaimer médico (F1), selección de modo (F3)
    auth/
      elder/              → login (F2), registro (F1) del adulto mayor
      caregiver/          → registro (F7) y espera del cuidador
    games/                → memorice, secuencias, trazado guiado (F4)
    breathing/            → respiración guiada — sin score (F5)
    progress/             → progreso personal del adulto mayor (F6)
    caregiver_dashboard/  → dashboard (F9), vínculo QR (F8)
    reports/              → reporte exportable para médico
    privacy/              → ARCO (F10), desvinculación (F11)
    profile/
    shared/               → widgets reutilizables, componentes accesibles
  main.dart

⚠️ Esta es la estructura completa según ARCHITECTURE.md sección 4.1.
Antes de crear o mover carpetas dentro de presentation/, compara contra
esa sección — no improvises nombres nuevos (ej. nunca "caregiver/" solo,
siempre "caregiver_dashboard/"; nunca "auth/" plano, siempre dividido en
"auth/elder/" y "auth/caregiver/").

## Modos de uso del adulto mayor
- Modo 1: estimulación libre — sin métricas, sin Firestore, solo Analytics
- Modo 2: seguimiento personal — UUID + métricas en Firestore
- Modo 3: con cuidador — todo lo del Modo 2 + vínculo QR + alertas

## Estándares de código
- Comentarios de lógica de negocio en español
- Código en inglés
- Commits: feat: / fix: / docs: / refactor: / test:
- Fuente mínima 18sp, botones mínimo 48x48dp
- Probar siempre en dispositivo Android gama media-baja

## Estado del proyecto
- Spike técnico Flutter → FastAPI → OpenAI ya validado (ver ARCHITECTURE.md
  sección 10.1) — no es necesario repetirlo ni recrear esa pantalla.
- Sprint actual: ver Jira proyecto AuroraCare para la tarea exacta en curso
  (el número y fechas de sprint pueden cambiar — no asumir un sprint fijo
  en este archivo, siempre confirmar en Jira o preguntar).

## Documentos de referencia
- AuroraCare_ARCHITECTURE_v2.md — arquitectura completa (fuente de verdad para estructura)
- SCORING.md — sistema de scoring cognitivo local
- USER_FLOWS.md — flujos F1 a F11
- Flujo_Trabajo_Git_AuroraCare.md — convención de ramas y Pull Requests
