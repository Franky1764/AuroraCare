# AuroraCare — SCORING.md — Sistema de Scoring Cognitivo Local

v1.0 · Agosto 2026 · Lógica central auditada, sin dependencia de IA externa

> **Principio rector de este documento**
> El scoring cognitivo de AuroraCare es 100% local, determinístico y auditable. No depende de OpenAI ni de ninguna IA externa. OpenAI solo recibe el resultado del scoring para redactar el texto del reporte en lenguaje natural. Este documento define todas las reglas de cálculo.

---

## 1. Principios del sistema de scoring

| Principio | Detalle |
| --- | --- |
| **Local y auditable** | Todas las reglas están definidas en este documento y en el código de FastAPI. Cualquier evaluador puede verificar el cálculo paso a paso. |
| **Sin diagnóstico** | El sistema produce señales de tendencia, no diagnósticos. Nunca dice "deterioro detectado". Dice "tendencia descendente en los últimos 14 días". |
| **Progresivo por niveles** | La dificultad avanza por niveles fijos predefinidos. No adaptativa en tiempo real: más simple, más honesto, más auditable. |
| **Comparación interna** | El usuario se compara consigo mismo en el tiempo, no con promedios poblacionales. Cada persona tiene su propia línea base. |
| **Mínimo 5 sesiones** | El sistema no emite señales hasta tener al menos 5 sesiones registradas por dominio. Con menos datos, la señal sería ruido estadístico. |
| **Ventana de 28 días** | El análisis de tendencia usa las últimas 4 semanas. Sesiones anteriores se archivan pero no afectan la señal activa. |

---

## 2. Métricas capturadas por juego

### 2.1 Memorice — Dominio: Memoria

El adulto mayor ve un tablero con cartas boca abajo y debe encontrar los pares. Duración de sesión: 2 a 4 minutos.

| Métrica | Descripción | Unidad | Peso en scoring |
| --- | --- | --- | --- |
| Tiempo total de sesión | Tiempo desde primera carta volteada hasta último par encontrado | Segundos | 30% |
| Número de errores | Pares seleccionados incorrectamente | Cantidad | 35% |
| Intentos hasta completar | Total de selecciones realizadas (pares correctos + errores) | Cantidad | 20% |
| Tasa de acierto | Pares correctos / Total de intentos x 100 | Porcentaje | 15% |

#### Niveles de dificultad — Memorice

| Nivel | Pares | Tiempo máximo | Criterio de avance |
| --- | --- | --- | --- |
| Nivel 1 — Básico | 6 pares (12 cartas) | 4 minutos | Tasa de acierto ≥ 70% en 3 sesiones consecutivas |
| Nivel 2 — Intermedio | 8 pares (16 cartas) | 5 minutos | Tasa de acierto ≥ 70% en 3 sesiones consecutivas |
| Nivel 3 — Avanzado | 10 pares (20 cartas) | 6 minutos | Nivel máximo en MVP — sin avance adicional |

### 2.2 Secuencias — Dominio: Atención

El adulto mayor ve una secuencia de estímulos visuales que aparecen en pantalla y debe replicarla tocando en el mismo orden. Duración: 2 a 3 minutos.

| Métrica | Descripción | Unidad | Peso en scoring |
| --- | --- | --- | --- |
| Tiempo de respuesta promedio | Tiempo entre aparición del estímulo y toque del usuario | Milisegundos | 35% |
| Tasa de error | Toques incorrectos / Total de toques x 100 | Porcentaje | 40% |
| Longitud máxima alcanzada | Longitud de secuencia más larga completada correctamente | Cantidad | 25% |

#### Niveles de dificultad — Secuencias

| Nivel | Longitud inicial | Velocidad del estímulo | Criterio de avance |
| --- | --- | --- | --- |
| Nivel 1 — Básico | 3 elementos | Lenta: 1.5 segundos por estímulo | Completar 3 secuencias sin error en la misma sesión |
| Nivel 2 — Intermedio | 5 elementos | Media: 1.0 segundo por estímulo | Completar 3 secuencias sin error en la misma sesión |
| Nivel 3 — Avanzado | 7 elementos | Rápida: 0.7 segundos por estímulo | Nivel máximo en MVP |

### 2.3 Trazado guiado — Dominio: Praxias

El adulto mayor ve una figura simple dibujada en pantalla y debe trazarla con el dedo por encima siguiendo el contorno. Duración: 2 a 3 minutos.

| Métrica | Descripción | Unidad | Peso en scoring |
| --- | --- | --- | --- |
| Precisión del trazo | Porcentaje del trazo dentro del margen de tolerancia definido por nivel | Porcentaje | 45% |
| Tiempo de completitud | Tiempo desde inicio hasta levantar el dedo por última vez | Segundos | 25% |
| Número de correcciones | Veces que el usuario levanta el dedo y retoma el trazo | Cantidad | 30% |

#### Niveles de dificultad — Trazado guiado

| Nivel | Figuras | Tolerancia del trazo | Criterio de avance |
| --- | --- | --- | --- |
| Nivel 1 — Básico | Línea recta y línea curva | ±15px (amplia) | Precisión ≥ 65% en 3 sesiones consecutivas |
| Nivel 2 — Intermedio | Círculo y cuadrado | ±10px (normal) | Precisión ≥ 65% en 3 sesiones consecutivas |
| Nivel 3 — Avanzado | Espiral y figura compuesta | ±7px (ajustada) | Nivel máximo en MVP |

### 2.4 Respiración guiada — Sin scoring

> **Sin métricas evaluativas**
> El módulo de respiración guiada no genera métricas cognitivas. Es un módulo de bienestar disponible en todos los modos. Se registra solo el evento de uso en Firebase Analytics sin identificación. No contribuye al scoring ni al reporte exportable.

---

## 3. Cálculo del score por sesión

Cada sesión genera un score normalizado de 0 a 100 por dominio. El cálculo es el mismo para todos los dominios. El score 100 representa el mejor rendimiento posible en ese nivel.

### 3.1 Fórmula general

```
score_sesion = Σ (valor_metrica_normalizado x peso_metrica)
```

Donde `valor_metrica_normalizado` se calcula así:

```
valor_norm = (mejor_posible - observado) / (mejor_posible - peor_posible) x 100
```

**Ejemplo — Memorice Nivel 1**

Mejor posible: 0 errores, 12 intentos, 60 segundos, 100% acierto.
Observado: 4 errores, 20 intentos, 180 segundos, 60% acierto.

```
Score tiempo:    (60-180) / (60-240) x 100 = 66.7  x 0.30 = 20.0 puntos
Score errores:   (0-4)   / (0-15)   x 100 = 73.3  x 0.35 = 25.7 puntos
Score intentos:  (12-20) / (12-30)  x 100 = 55.6  x 0.20 = 11.1 puntos
Score acierto:   60 (directo)              x 0.15 =  9.0 puntos

SCORE TOTAL SESIÓN: 65.8 / 100
```

### 3.2 Línea base personal

Las primeras 5 sesiones de cada usuario en cada dominio establecen su línea base personal. El sistema no emite señales durante este periodo de calibración: solo acumula datos.

```
linea_base = promedio(score_sesiones_1_a_5)
desviacion_base = desviacion_estandar(score_sesiones_1_a_5)
```

A partir de la sesión 6, cada nuevo score se compara contra la línea base personal. El usuario se compara consigo mismo en el tiempo, nunca contra promedios de otras personas.

---

## 4. Análisis de tendencia — ventana de 28 días

El sistema analiza la tendencia del score en los últimos 28 días usando regresión lineal simple. La pendiente de la recta de regresión determina la señal que ve el cuidador.

### 4.1 Cálculo de tendencia — código FastAPI

```python
# scoring.py - FastAPI
import numpy as np

def calcular_tendencia(scores: list[float]) -> dict:
    if len(scores) < 5:
        return {"senal": "insuficiente", "pendiente": None}

    x = np.arange(len(scores))
    pendiente, _ = np.polyfit(x, scores, 1)
    variacion_pct = (pendiente / np.mean(scores)) * 100

    return {
        "senal": clasificar_senal(variacion_pct),
        "pendiente": round(pendiente, 3),
        "variacion_pct": round(variacion_pct, 1)
    }
```

### 4.2 Clasificación de señales

| Señal | Criterio de variación | Color en UI | Mensaje para el cuidador |
| --- | --- | --- | --- |
| **VERDE — Estable** | Variación entre -5% y +5% | Verde | Sus sesiones muestran un rendimiento consistente en los últimos 28 días. |
| **AZUL — Mejora** | Variación mayor a +5% | Azul | Sus sesiones muestran una tendencia de mejora en los últimos 28 días. |
| **AMARILLO — Atención** | Variación entre -5% y -15% | Amarillo | Sus sesiones muestran una leve tendencia descendente. Se recomienda observar. |
| **ROJO — Revisar** | Variación menor a -15% | Rojo | Sus sesiones muestran una tendencia descendente sostenida. Se recomienda consultar a un profesional. |
| **GRIS — Sin datos** | Menos de 5 sesiones | Gris | Aún no hay suficientes sesiones para mostrar una tendencia confiable. |

> **Advertencia — Regla crítica de lenguaje**
> Las señales NUNCA usan estas palabras: deterioro, demencia, Alzheimer, diagnóstico, problema, anormal, patológico, enfermedad. Siempre describen tendencias observadas en las sesiones, nunca estados de salud. El disclaimer del reporte recuerda al cuidador que debe consultar a un profesional de la salud para interpretación clínica.

---

## 5. Estructura del payload — FastAPI

### 5.1 Request — POST /session/analyze

```json
{
  "session_uuid": "anon-uuid-generado-local",
  "game_type": "memorice" | "secuencias" | "trazado",
  "nivel": 1,
  "timestamp": "2026-08-22T10:30:00Z",
  "metricas": {
    "tiempo_total_seg": 142,
    "errores": 3,
    "intentos": 18,
    "tasa_acierto_pct": 66.7
  }
}
```

### 5.2 Response — POST /session/analyze

```json
{
  "score_sesion": 71.4,
  "nivel_actual": 1,
  "avance_nivel": false,
  "sesiones_acumuladas": 7,
  "tendencia": {
    "senal": "estable",
    "variacion_pct": -2.3,
    "ventana_dias": 28
  }
}
```

### 5.3 Request — POST /report/generate

```json
{
  "session_uuid": "anon-uuid-generado-local",
  "periodo_dias": 28,
  "resumen_dominios": {
    "memoria":  { "score_promedio": 68.2, "senal": "estable",  "sesiones": 8 },
    "atencion": { "score_promedio": 74.5, "senal": "mejora",   "sesiones": 7 },
    "praxias":  { "score_promedio": 61.0, "senal": "atencion", "sesiones": 6 }
  }
}
```

> **Nota de implementación (spike técnico, sept. 2026):** en la implementación real del spike, `/report/generate` terminó **sin** `session_uuid` en el payload — ver ARCHITECTURE.md sección 6, regla de privacidad: OpenAI no debe recibir ningún identificador, ni siquiera uno de sesión. El identificador de sesión se usa solo internamente en FastAPI antes de construir el prompt.

---

## 6. Prompt a OpenAI — plantilla auditada

Este es el único punto de contacto con OpenAI. El prompt está fijo y auditado. No contiene datos identificables: solo métricas numéricas y señales ya calculadas localmente.

```
SYSTEM: Eres un asistente que redacta reportes de bienestar cognitivo para personas mayores.
Tu tarea es redactar un párrafo claro, cálido y comprensible para un cuidador no profesional.

REGLAS ABSOLUTAS:
- Nunca uses: deterioro, demencia, Alzheimer, diagnóstico, patológico, anormal, enfermedad.
- Incluye siempre al final: "Este reporte no constituye un diagnóstico médico.
  Consulte a un profesional de la salud para una evaluación completa."
- Máximo 150 palabras. Lenguaje simple. Tono positivo y orientado a la acción.

USER: Genera el reporte de las últimas 4 semanas con estos datos:
- Memoria: score promedio 68.2, tendencia estable, 8 sesiones registradas
- Atención: score promedio 74.5, tendencia de mejora, 7 sesiones registradas
- Praxias: score promedio 61.0, tendencia de atención, 6 sesiones registradas
```

> **Lo que nunca llega a OpenAI**
> Nombre del usuario · Email · UUID cognitivo · Historial de sesiones individuales · Fecha de nacimiento · Cualquier dato que permita identificar a la persona. OpenAI solo recibe números agregados y señales ya calculadas localmente por FastAPI.

**Validado en la práctica:** el spike técnico (ver ARCHITECTURE.md sección 10.1) confirmó que el modelo `gpt-5.6-luna` respeta estas reglas — el texto generado no usó ninguna palabra prohibida, incluyó el disclaimer obligatorio, y se mantuvo bajo 150 palabras.

---

## 7. Plan B — plantillas locales sin OpenAI

Si OpenAI no está disponible o falla, el reporte se genera con plantillas locales en Flutter. El scoring no cambia. Solo cambia el texto del reporte: de texto generado por IA a texto de plantilla fija.

| Señal recibida | Texto de plantilla local |
| --- | --- |
| **VERDE — Estable** | Sus sesiones en los últimos 28 días muestran un rendimiento consistente. Continúe con la rutina actual de estimulación. |
| **AZUL — Mejora** | Sus sesiones muestran una tendencia positiva en los últimos 28 días. El esfuerzo y la constancia están dando resultados. |
| **AMARILLO — Atención** | Sus sesiones muestran una leve variación en los últimos 28 días. Se recomienda mantener la frecuencia de uso y observar la evolución. |
| **ROJO — Revisar** | Sus sesiones muestran una variación sostenida en los últimos 28 días. Se recomienda comentar estas tendencias con un profesional de la salud. |

Todas las plantillas incluyen al final:

> *Este reporte no constituye un diagnóstico médico. Consulte a un profesional de la salud para una evaluación completa.*

> **Estado (sept. 2026):** el spike técnico validó que la integración con OpenAI funciona correctamente de punta a punta — no fue necesario activar este Plan B. Se mantiene documentado como respaldo en caso de fallas futuras de la API.

---

AuroraCare · SCORING.md v1.0 · Agosto 2026 · Daniela Castillo · Duoc UC
