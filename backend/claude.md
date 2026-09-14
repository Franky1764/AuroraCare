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

## Privacidad — Ley 21.719
- UUID anónimo generado localmente al activar Modo 2 o 3
- Identidad (email/UID) y métricas cognitivas NUNCA en el mismo documento Firestore
- OpenAI NUNCA recibe nombre, email, UUID ni datos identificables
- Flujo ARCO completo obligatorio antes de publicar en Play Store

## Estructura de carpetas
lib/
  core/
    constants/    → colores, strings, rutas
    theme/        → tema visual AuroraCare
    utils/        → helpers, formatters
    errors/       → manejo centralizado de errores
    router/       → GoRouter navegación declarativa
  data/
    models/       → UserModel, SessionModel, AlertModel
    repositories/ → implementación concreta de repos
    sources/      → firebase_source.dart, api_source.dart
  domain/
    entities/     → entidades de negocio puras
    repositories/ → interfaces abstractas
    usecases/     → StartSession, LinkCaregiver, GenerateReport
  presentation/
    auth/         → login, registro, consentimiento, selección de modo
    games/        → memorice, secuencias, trazado guiado
    caregiver/    → dashboard cuidador, vínculo QR
    reports/      → reporte exportable para médico
    shared/       → widgets reutilizables accesibles
  main.dart

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

## Sprint actual
Sprint 2 — Arquitectura y Auth (14 sep – 4 oct 2026)
Tarea en curso: ver Jira proyecto AuroraCare

## Documentos de referencia
- ARCHITECTURE.md — arquitectura completa
- SCORING.md — sistema de scoring cognitivo local
- USER_FLOWS.md — flujos F1 a F11