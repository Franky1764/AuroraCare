import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_care/presentation/onboarding/medical_disclaimer_screen.dart';

void main() {
  testWidgets(
      'MedicalDisclaimerScreen muestra los 3 párrafos y el botón, sin '
      'boton de volver ni de omitir', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MedicalDisclaimerScreen(),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains(
                  'AuroraCare no diagnostica ninguna enfermedad.',
                ),
      ),
      findsOneWidget,
    );
    expect(
      find.text('Es una herramienta de bienestar para ejercitar la mente.'),
      findsOneWidget,
    );
    expect(
      find.text('Ante cualquier duda de salud, hable con su médico.'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ElevatedButton, 'Entendido, continuar'),
      findsOneWidget,
    );

    expect(find.byType(AppBar), findsNothing);
    expect(find.byType(BackButton), findsNothing);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.textContaining('Omitir'), findsNothing);
    expect(find.textContaining('Saltar'), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('MedicalDisclaimerScreen no se cierra con el botón atrás',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MedicalDisclaimerScreen(),
                  ),
                ),
                child: const Text('Abrir'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.byType(MedicalDisclaimerScreen), findsOneWidget);

    // Simula el botón físico/gesto de atrás de Android.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(MedicalDisclaimerScreen), findsOneWidget);
  });
}
