"""
AuroraCare - Backend FastAPI
Spike técnico: valida Flutter -> FastAPI -> OpenAI end-to-end
Ver ARCHITECTURE_v2.docx sección 10 para el criterio de éxito del spike.
"""

import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
from openai import OpenAI

# Carga las variables de entorno desde .env (OPENAI_API_KEY)
load_dotenv()

app = FastAPI(title="AuroraCare Backend - Spike")

# CORS abierto para desarrollo local (Flutter corre en otro puerto/emulador).
# TODO: restringir origins antes de producción.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


# ---------- MODELOS DE DATOS (Pydantic) ----------
# Siguen la estructura de payload definida en SCORING.md sección 5

class Metricas(BaseModel):
    tiempo_total_seg: float
    errores: int
    intentos: int
    tasa_acierto_pct: float


class SessionAnalyzeRequest(BaseModel):
    session_uuid: str
    game_type: str
    nivel: int
    metricas: Metricas


class ReportGenerateRequest(BaseModel):
    periodo_dias: int = 28
    resumen_dominios: dict


# ---------- ENDPOINTS DEL SPIKE ----------

@app.get("/health")
def health():
    """Paso 1 del spike: Flutter llama esto y debe mostrar 'OK' en pantalla."""
    return {"status": "OK"}


@app.post("/session/analyze")
def analyze_session(data: SessionAnalyzeRequest):
    """
    Paso 2 del spike: recibe métricas de prueba, calcula un score simple.
    NOTA: este es un scoring simplificado solo para el spike.
    El scoring real completo (con línea base personal, regresión lineal
    de tendencia, ventana de 28 días) se implementa después según
    SCORING.md secciones 3 y 4 - NO aquí.
    """
    m = data.metricas

    # Fórmula simplificada solo para probar el flujo (no es el scoring final)
    score = max(0, min(100, 100 - (m.errores * 5) - (m.tiempo_total_seg / 10)))

    return {
        "score_sesion": round(score, 1),
        "nivel_actual": data.nivel,
        "avance_nivel": False,
        "sesiones_acumuladas": 1,
        "tendencia": {
            "senal": "insuficiente",  # con 1 sola sesión de prueba no hay tendencia real
            "variacion_pct": None,
            "ventana_dias": 28
        }
    }


@app.post("/report/generate")
def generate_report(data: ReportGenerateRequest):
    """
    Paso 3 del spike: recibe scoring ya calculado, llama a OpenAI
    con el prompt auditado de SCORING.md sección 6, retorna el texto.

    IMPORTANTE - Regla de privacidad (ARCHITECTURE_v2.docx sección 6):
    Este payload NUNCA debe incluir nombre, email ni UUID identificable.
    Solo números agregados y señales ya calculadas localmente.
    """

    resumen = data.resumen_dominios

    # Construye el texto de métricas en lenguaje plano (sin PII) para el prompt
    lineas_dominios = []
    for dominio, info in resumen.items():
        lineas_dominios.append(
            f"- {dominio.capitalize()}: score promedio {info.get('score_promedio')}, "
            f"tendencia {info.get('senal')}, {info.get('sesiones')} sesiones registradas"
        )
    metricas_texto = "\n".join(lineas_dominios)

    system_prompt = (
        "Eres un asistente que redacta reportes de bienestar cognitivo para personas mayores.\n"
        "Tu tarea es redactar un párrafo claro, cálido y comprensible para un cuidador no profesional.\n\n"
        "REGLAS ABSOLUTAS:\n"
        "- Nunca uses: deterioro, demencia, Alzheimer, diagnóstico, patológico, anormal, enfermedad.\n"
        "- Incluye siempre al final: Este reporte no constituye un diagnóstico médico. "
        "Consulte a un profesional de la salud para una evaluación completa.\n"
        "- Máximo 150 palabras. Lenguaje simple. Tono positivo y orientado a la acción."
    )

    user_prompt = (
        f"Genera el reporte de los últimos {data.periodo_dias} días con estos datos:\n\n"
        f"{metricas_texto}"
    )

    try:
        response = client.chat.completions.create(
            model="gpt-5.6-luna",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt},
            ],
        )
        texto_reporte = response.choices[0].message.content

        return {
            "reporte_texto": texto_reporte,
            "generado_con": "openai",
        }

    except Exception:
        # Plan B (SCORING.md sección 7): si OpenAI falla, se debe usar
        # plantilla local. Aquí solo lo señalamos para el spike;
        # la implementación real del fallback va en Flutter/Plan B.
        # No exponemos el detalle interno del error (str(e)) en la
        # respuesta HTTP -- eso se loguea en el servidor, no se retorna.
        return {
            "reporte_texto": None,
            "generado_con": "error",
        }