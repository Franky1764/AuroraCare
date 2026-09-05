import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Necesario para poder usar 'await' antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase usando la configuración generada por flutterfire configure
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuroraCare - Spike',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SpikeScreen(),
    );
  }
}

class SpikeScreen extends StatefulWidget {
  const SpikeScreen({super.key});

  @override
  State<SpikeScreen> createState() => _SpikeScreenState();
}

class _SpikeScreenState extends State<SpikeScreen> {
  // IMPORTANTE: 10.0.2.2 es la IP especial que el EMULADOR Android usa
  // para referirse a "localhost" de tu Mac (no es un error de tipeo).
  // Si algún día pruebas en un celular físico conectado por USB o WiFi,
  // esto debe cambiar a la IP real de tu Mac en la red local.
  static const String baseUrl = 'http://10.0.2.2:8000';

  String _resultado = 'Presiona el botón para probar el spike completo';
  bool _cargando = false;

  Future<void> _ejecutarSpike() async {
    setState(() {
      _cargando = true;
      _resultado = 'Paso 1: probando /health...';
    });

    try {
      // ---------- Paso 1: /health ----------
      final healthResponse = await http.get(Uri.parse('$baseUrl/health'));
      if (healthResponse.statusCode != 200) {
        throw Exception('Health check falló: ${healthResponse.statusCode}');
      }
      setState(() => _resultado = 'Paso 1 OK. Paso 2: /session/analyze...');

      // ---------- Paso 2: /session/analyze ----------
      final analyzeResponse = await http.post(
        Uri.parse('$baseUrl/session/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'session_uuid': 'test-uuid-flutter-001',
          'game_type': 'memorice',
          'nivel': 1,
          'metricas': {
            'tiempo_total_seg': 120,
            'errores': 3,
            'intentos': 15,
            'tasa_acierto_pct': 70,
          },
        }),
      );
      if (analyzeResponse.statusCode != 200) {
        throw Exception('Analyze falló: ${analyzeResponse.statusCode}');
      }
      setState(() => _resultado = 'Paso 2 OK. Paso 3: /report/generate (llamando a OpenAI)...');

      // ---------- Paso 3: /report/generate ----------
      final reportResponse = await http.post(
        Uri.parse('$baseUrl/report/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'periodo_dias': 28,
          'resumen_dominios': {
            'memoria': {
              'score_promedio': 68.2,
              'senal': 'estable',
              'sesiones': 8,
            },
            'atencion': {
              'score_promedio': 74.5,
              'senal': 'mejora',
              'sesiones': 7,
            },
            'praxias': {
              'score_promedio': 61.0,
              'senal': 'atencion',
              'sesiones': 6,
            },
          },
        }),
      );

      if (reportResponse.statusCode != 200) {
        throw Exception('Report falló: ${reportResponse.statusCode}');
      }

      final data = jsonDecode(utf8.decode(reportResponse.bodyBytes));
      final textoReporte = data['reporte_texto'] as String?;

      setState(() {
        _cargando = false;
        _resultado = textoReporte ?? 'El backend respondió pero sin texto de reporte (revisar Plan B).';
      });
    } catch (e) {
      setState(() {
        _cargando = false;
        _resultado = 'Error en el spike: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AuroraCare - Spike técnico')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _cargando ? null : _ejecutarSpike,
              child: Text(_cargando ? 'Ejecutando...' : 'Probar spike completo'),
            ),
            const SizedBox(height: 24),
            if (_cargando) const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 16),
            Text(
              _resultado,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}