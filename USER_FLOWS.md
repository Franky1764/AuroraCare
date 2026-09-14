# AuroraCare — USER_FLOWS.md — Flujos de usuario del MVP

v1.0 · Agosto 2026 · Referencia de diseño para Figma y desarrollo

> **Instrucción para el equipo**
> Este documento define el comportamiento de cada flujo ANTES de diseñar pantallas en Figma. Benjamín: flujos del adulto mayor (F1 a F6). Eduardo: flujos del cuidador (F7 a F9). Daniela: flujos de privacidad y ARCO (F10 a F11). Ningún flujo puede modificarse sin revisión del equipo completo.

---

## 0. Mapa general de flujos

| Flujo | Descripción |
| --- | --- |
| **F1** — Registro adulto mayor | Crear cuenta con email y contraseña. Consentimiento. Selección de modo inicial. |
| **F2** — Login adulto mayor | Entrar a la app con cuenta existente. |
| **F3** — Selección y cambio de modo | El adulto mayor elige o cambia entre Modo 1, 2 o 3 en cualquier momento. |
| **F4** — Sesión de juego | Seleccionar dominio, jugar, ver resultado. Con o sin captura de métricas según modo. |
| **F5** — Respiración guiada | Acceder y completar una sesión de respiración. Sin métricas. |
| **F6** — Ver progreso personal | El adulto mayor revisa sus tendencias propias. Solo Modo 2 y 3. |
| **F7** — Registro cuidador | El cuidador crea su cuenta en AuroraCare. |
| **F8** — Vínculo QR | El adulto mayor genera el QR. El cuidador lo escanea. Solo el adulto mayor inicia. |
| **F9** — Dashboard cuidador | El cuidador ve las señales del adulto mayor vinculado y el reporte exportable. |
| **F10** — Ejercicio ARCO | El usuario ejerce sus derechos: acceso, rectificación, cancelación, oposición. |
| **F11** — Desvinculación | El adulto mayor desvincula al cuidador. El cuidador pierde acceso inmediatamente. |

---

## F1 — Registro del adulto mayor

> **Responsable: Benjamín Valle**
> Este flujo es el primero que el adulto mayor ve. Debe ser el más simple y claro de toda la app. Cada pantalla tiene UNA sola acción posible.

| # | Pantalla | Detalle |
| --- | --- | --- |
| 1 | Bienvenida | Pantalla de presentación de AuroraCare. Logo, nombre, frase breve. Un botón: Comenzar. Sin texto largo. |
| 2 | Crear cuenta | Campos: Nombre (como quiere que lo llamen), Email, Contraseña. Botón: Crear mi cuenta. Enlace: Ya tengo cuenta. |
| 3 | Verificación email | Mensaje: Te enviamos un correo para confirmar tu cuenta. Botón: Ya confirmé, continuar. Botón: Reenviar correo. |
| 4 | Disclaimer médico | Texto claro: AuroraCare no es un dispositivo médico ni reemplaza la opinión de un profesional de la salud. Es una herramienta de estimulación y bienestar cognitivo. Botón: Entendido, continuar. Sin este paso no hay acceso. |
| 5 | Selección de modo | Tres opciones visuales explicadas en lenguaje simple. Ver F3 para el detalle de cada modo. El usuario elige uno. Puede cambiarlo después. |
| 6 | Pantalla principal | Acceso al menú principal de la app según el modo elegido. |

> **Regla de diseño — F1**
> El nombre del adulto mayor NO es su nombre legal: es como quiere que lo llame la app (puede ser un apodo). Esto reduce la sensación de formulario oficial y hace el registro más amigable para este segmento.

---

## F2 — Login del adulto mayor

| # | Pantalla | Detalle |
| --- | --- | --- |
| 1 | Pantalla de login | Campos: Email y Contraseña. Botón: Entrar. Enlace: Olvidé mi contraseña. Enlace: Crear cuenta nueva. |
| 2 | Recuperación de contraseña | Si selecciona olvidé contraseña: campo email, botón Enviar instrucciones. Mensaje de confirmación claro. |
| 3 | Pantalla principal | Si las credenciales son correctas, acceso directo al menú principal. |

> **Consideración de UX**
> Los adultos mayores olvidan contraseñas con frecuencia. El flujo de recuperación debe ser muy visible, con texto grande y pasos mínimos. No usar captcha ni preguntas de seguridad complejas.

---

## F3 — Selección y cambio de modo

> **Responsable: Benjamín Valle**
> Este flujo ocurre en el registro (F1 paso 5) y también desde el menú de configuración en cualquier momento posterior.

Los tres modos se presentan como opciones visuales simples, sin lenguaje técnico:

| Modo | Descripción para el usuario | Ícono |
| --- | --- | --- |
| **Modo 1 — Solo jugar** | Me gusta jugar y estimular mi mente. No quiero que se guarden mis datos. | Dado o juego |
| **Modo 2 — Jugar y ver mi progreso** | Quiero ver cómo mejoro con el tiempo. Solo yo veo mi progreso. | Gráfico ascendente |
| **Modo 3 — Jugar, ver mi progreso y conectar con un cuidador** | Quiero que alguien de confianza pueda ver cómo estoy. Yo decido quién. | Dos personas |

**Si el usuario cambia de Modo 3 a Modo 1 o 2:**

> **Aviso crítico al cambiar de modo**
> Si el adulto mayor baja de Modo 3 a Modo 2 o 1: el cuidador pierde acceso inmediatamente. La app debe mostrar un aviso claro: "Si cambias de modo, [nombre del cuidador] ya no podrá ver tu información." Confirmar el cambio requiere un toque adicional de confirmación.

---

## F4 — Sesión de juego cognitivo

> **Responsable: Benjamín Valle**
> Flujo idéntico para Memorice, Secuencias y Trazado guiado. La diferencia es solo el contenido del juego, no el flujo.

| # | Pantalla | Detalle |
| --- | --- | --- |
| 1 | Menú de juegos | Tres tarjetas visuales: Memorice (Memoria), Secuencias (Atención), Trazado (Praxias). Descripción breve de cada uno. El usuario toca el que quiere jugar. |
| 2 | Pantalla previa al juego | Nombre del juego, nivel actual, instrucción muy breve (una sola oración). Botón grande: Comenzar. |
| 3 | Sesión de juego | Interfaz del juego activo. Temporizador visible. Botón de salir siempre visible (con confirmación). Sin distracciones visuales. |
| 4 | Resultado de sesión | Pantalla de fin: mensaje positivo siempre (aunque el resultado sea bajo). En Modo 1: solo el mensaje, sin score. En Modo 2 y 3: score de sesión y comparación con sesión anterior. |
| 5 | Avance de nivel (si aplica) | Si el usuario cumple el criterio de avance: mensaje celebratorio. Nivel nuevo desbloqueado. Botón: Continuar. |
| 6 | Vuelta al menú | Botón: Jugar de nuevo. Botón: Volver al inicio. |

> **Regla de diseño — F4**
> El resultado SIEMPRE tiene un mensaje positivo, independiente del score. Nunca mostrar mensajes como "Mal resultado" o "Intenta mejorar". En cambio: "Gracias por jugar" o "Cada sesión cuenta". El tono de la app es siempre de acompañamiento, nunca de evaluación.

---

## F5 — Respiración guiada

> **Responsable: Benjamín Valle**
> Disponible en todos los modos. Sin métricas. Sin score. Es un módulo de bienestar puro.

| # | Pantalla | Detalle |
| --- | --- | --- |
| 1 | Acceso | Desde el menú principal: tarjeta de Respiración guiada. Descripción: "Unos minutos de calma para tu mente y cuerpo." |
| 2 | Selección de duración | Opciones simples: 2 minutos, 5 minutos, 10 minutos. Botón: Comenzar. |
| 3 | Sesión de respiración | Animación simple de expansión y contracción (círculo o figura). Instrucciones de texto: Inhala... Exhala... Sostiene... Texto grande, sin distracciones. |
| 4 | Fin de sesión | Mensaje de cierre positivo. Botón: Volver al inicio. Sin score, sin estadísticas. |

---

## F6 — Ver progreso personal

> **Responsable: Benjamín Valle — Solo Modo 2 y Modo 3**
> El adulto mayor ve sus propias tendencias. En Modo 1 esta pantalla no existe.

| # | Pantalla | Detalle |
| --- | --- | --- |
| 1 | Pantalla de progreso | Tres secciones: Memoria, Atención, Praxias. Cada una muestra la señal actual (Verde/Azul/Amarillo/Rojo/Gris) con texto explicativo simple. Sin gráficos complejos en MVP. |
| 2 | Detalle por dominio | Al tocar una sección: últimas 5 sesiones listadas con fecha y resultado simple (Bien, Regular, Practicando). Sin números técnicos visibles para el adulto mayor. |
| 3 | Reporte para médico | Botón visible: Generar reporte para mi médico. Solo en Modo 2 y 3. Ver F9 para el detalle del reporte. |

> **Regla crítica de lenguaje — F6**
> El adulto mayor NUNCA ve los scores numéricos (68.2, 74.5). Solo ve etiquetas simples en español: Muy bien, Bien, Practicando, Consultar. Los números son para FastAPI y para el reporte del médico, no para la pantalla del adulto mayor.

---

## F7 — Registro del cuidador

> **Responsable: Eduardo Villanueva**
> El cuidador crea su propia cuenta. No puede acceder a ningún adulto mayor hasta que ese adulto mayor lo vincule mediante QR.

| # | Pantalla | Detalle |
| --- | --- | --- |
| 1 | Selección de perfil | Pantalla inicial con dos opciones: "Soy adulto mayor" o "Soy cuidador o familiar". El cuidador selecciona la segunda. |
| 2 | Crear cuenta cuidador | Campos: Nombre completo, Email, Contraseña. Botón: Crear mi cuenta. |
| 3 | Verificación email | Mismo flujo que F1 paso 3. |
| 4 | Pantalla de espera | Mensaje: "Tu cuenta está lista. Para ver la información de un adulto mayor, esa persona debe vincularte desde su app." Instrucción: "Pídele que abra AuroraCare y seleccione Conectar cuidador." |
| 5 | Dashboard vacío | Dashboard del cuidador sin ninguna tarjeta vinculada aún. Mensaje amigable: "Todavía no tienes adultos mayores vinculados." |

---

## F8 — Vínculo QR entre adulto mayor y cuidador

> **Regla absoluta: Solo el adulto mayor puede iniciar este flujo**
> El cuidador NUNCA puede solicitar acceso. El QR lo genera el adulto mayor y se lo muestra al cuidador. Esta regla es parte del diseño de privacidad y no puede cambiarse.

### Parte A — El adulto mayor genera el QR

| # | Pantalla | Detalle |
| --- | --- | --- |
| 1 | Acceso al vínculo | Desde configuración o Modo 3: "Conectar a mi cuidador". Solo disponible en Modo 3. |
| 2 | Confirmación de intención | Mensaje: "Vas a conectar a alguien de confianza para que pueda ver tu progreso. Solo tú puedes desconectarlo." Botón: Continuar. Botón: Cancelar. |
| 3 | Generación del QR | QR generado localmente. Mensaje: "Muestra este código a tu cuidador para que lo escanee con AuroraCare." El QR expira en 10 minutos. |
| 4 | Confirmación del vínculo | Cuando el cuidador escanea: mensaje al adulto mayor: "Tu cuidador [nombre] ahora puede ver tu progreso." Botón: Aceptar. |

### Parte B — El cuidador escanea el QR

| # | Pantalla | Detalle |
| --- | --- | --- |
| 1 | Acceso al escáner | Desde el dashboard vacío del cuidador: botón "Vincularme con un adulto mayor". Abre la cámara. |
| 2 | Escaneo del QR | El cuidador apunta la cámara al QR del adulto mayor. Confirmación automática si el QR es válido. |
| 3 | Confirmación | Pantalla: "Quedaste vinculado con [nombre del adulto mayor]. Ya puedes ver su progreso cuando él autorice compartirlo." Botón: Ir a mi panel. |
| 4 | Dashboard activo | El dashboard del cuidador ahora muestra la tarjeta del adulto mayor vinculado. |

---

## F9 — Dashboard del cuidador

> **Responsable: Eduardo Villanueva — Solo Modo 3**
> El cuidador ve señales interpretadas, nunca datos crudos ni scores numéricos.

| # | Pantalla | Detalle |
| --- | --- | --- |
| 1 | Pantalla principal | Lista de adultos mayores vinculados (MVP: máximo 1). Tarjeta con nombre y señal resumen actual (color + texto simple). |
| 2 | Detalle del adulto mayor | Al tocar la tarjeta: tres secciones con señal por dominio (Memoria, Atención, Praxias). Texto interpretable generado por OpenAI. Sin números técnicos. |
| 3 | Historial de señales | Últimas 4 semanas de señales por dominio. Vista simple: íconos de color por semana. Sin gráficos complejos en MVP. |
| 4 | Reporte exportable | Botón: Ver reporte completo. Genera el PDF localmente. Opciones: Compartir por WhatsApp, Guardar en el teléfono. El PDF incluye el disclaimer médico obligatorio. |
| 5 | Notificación push | Si la señal cambia a ROJO: el cuidador recibe una notificación push. Texto: "El progreso de [nombre] muestra una tendencia que puede requerir atención. Revisa el reporte en AuroraCare." |

> **Regla de diseño — F9**
> El cuidador NUNCA ve: scores numéricos, métricas de sesión individuales, timestamps exactos de cada partida, ni el UUID del adulto mayor. Solo ve señales interpretadas en lenguaje natural y el reporte generado por OpenAI.

---

## F10 — Flujo ARCO — Derechos del usuario

> **Responsable: Daniela Castillo — Obligatorio por Ley 21.719**
> Este flujo debe estar completo y funcional antes de la publicación en Play Store. Sin ARCO la app no puede publicarse.

| Paso | Detalle |
| --- | --- |
| **Acceso** | Configuración > Mis datos y privacidad > Derechos sobre mis datos. |
| **A — Acceso** | El usuario ve todos sus datos almacenados: email, nombre, modo actual, fecha de registro, UUID anónimo, número de sesiones. Sin mostrar métricas individuales en esta vista. |
| **R — Rectificación** | El usuario puede cambiar su nombre y email. La contraseña se cambia por flujo separado de Firebase Auth. |
| **C — Cancelación** | El usuario puede eliminar su cuenta. Flujo: confirmación por email + segundo toque de confirmación en app. Al confirmar: UUID y todas las métricas asociadas se eliminan de Firestore. El email se elimina de Firebase Auth. Acción irreversible. |
| **O — Oposición** | El usuario puede desactivar la captura de métricas sin eliminar la cuenta. Equivale a bajar a Modo 1. Sus datos históricos quedan en Firestore hasta que decida eliminarlos. |

> **Regla crítica — Cancelación de cuenta**
> La cancelación debe ser de dos pasos: primero un email de confirmación, luego un botón de confirmación final en la app. El proceso debe completarse en menos de 24 horas desde la solicitud. Esto es un requisito explícito de Ley 21.719.

---

## F11 — Desvinculación del cuidador

El adulto mayor puede desvincular a su cuidador en cualquier momento, sin dar explicaciones y sin notificárselo previamente.

| # | Pantalla | Detalle |
| --- | --- | --- |
| 1 | Acceso | Configuración > Mi cuidador > Desvincular a [nombre]. |
| 2 | Confirmación | Mensaje: "Si desvinculamos a [nombre], ya no podrá ver tu progreso. Esta acción es inmediata." Botón: Confirmar. Botón: Cancelar. |
| 3 | Efecto inmediato | Al confirmar: el cuidador pierde acceso instantáneo. Su dashboard muestra: "Este adulto mayor ha decidido no compartir su información." Los datos del adulto mayor permanecen en su cuenta (no se eliminan). |
| 4 | Notificación al cuidador | El cuidador recibe una notificación: "[Nombre] ha decidido dejar de compartir su información contigo." No se envía ninguna razón ni detalle adicional. |

> **Regla de privacidad — F11**
> El cuidador NO puede ver los datos históricos del adulto mayor después de la desvinculación, ni siquiera los que ya existían antes. El acceso se revoca completamente e inmediatamente. Esto es parte del diseño de privacidad, no una limitación técnica.

---

## Resumen de responsabilidades por flujo

| Integrante | Flujos |
| --- | --- |
| **Benjamín Valle** | F1 Registro adulto mayor, F2 Login, F3 Selección de modo, F4 Sesión de juego, F5 Respiración guiada, F6 Ver progreso personal |
| **Eduardo Villanueva** | F7 Registro cuidador, F8 Vínculo QR (parte cuidador), F9 Dashboard cuidador |
| **Daniela Castillo** | F8 Vínculo QR (arquitectura y seguridad), F10 Flujo ARCO, F11 Desvinculación. Revisión de todos los flujos antes de Figma. |

> **Siguiente paso para el equipo**
> Antes de diseñar en Figma: revisar este documento con el equipo completo. Cada integrante valida los flujos de su responsabilidad. Cualquier cambio a un flujo debe ser aprobado por los tres antes de implementarse.

---

AuroraCare · USER_FLOWS.md v1.0 · Agosto 2026 · Daniela Castillo, Benjamín Valle, Eduardo Villanueva · Duoc UC
