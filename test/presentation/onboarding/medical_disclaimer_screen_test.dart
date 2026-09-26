import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_care/presentation/onboarding/medical_disclaimer_screen.dart';

ElevatedButton _continueButton(WidgetTester tester) =>
    tester.widget(find.widgetWithText(ElevatedButton, 'Entendido, continuar'));

void main() {
  testWidgets(
    'MedicalDisclaimerScreen muestra los 3 párrafos, la casilla y el botón, '
    'sin botón de omitir',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MedicalDisclaimerScreen()),
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
      expect(find.text('Entiendo y acepto lo anterior'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, 'Entendido, continuar'),
        findsOneWidget,
      );

      expect(find.textContaining('Omitir'), findsNothing);
      expect(find.textContaining('Saltar'), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
    },
  );

  testWidgets('el botón está deshabilitado hasta marcar la casilla', (
    WidgetTester tester,
  ) async {
    var accepted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MedicalDisclaimerScreen(onAccept: () => accepted = true),
      ),
    );

    expect(_continueButton(tester).onPressed, isNull);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(_continueButton(tester).onPressed, isNotNull);

    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Entendido, continuar'),
    );
    await tester.pump();
    expect(accepted, isTrue);
  });

  testWidgets('tocar el texto marca y desmarca la casilla', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MedicalDisclaimerScreen()));

    await tester.tap(find.text('Entiendo y acepto lo anterior'));
    await tester.pump();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
    expect(_continueButton(tester).onPressed, isNotNull);

    await tester.tap(find.text('Entiendo y acepto lo anterior'));
    await tester.pump();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
    expect(_continueButton(tester).onPressed, isNull);
  });

  testWidgets('existe un botón de volver en el AppBar y permite retroceder', (
    WidgetTester tester,
  ) async {
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
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(MedicalDisclaimerScreen), findsNothing);
  });
}
