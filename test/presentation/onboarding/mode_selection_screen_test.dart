import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_care/core/constants/app_colors.dart';
import 'package:aurora_care/presentation/onboarding/mode_selection_screen.dart';

bool _isHighlighted(WidgetTester tester, int mode) {
  final card = tester.widget<Card>(
    find.descendant(
      of: find.byKey(ValueKey('mode_card_$mode')),
      matching: find.byType(Card),
    ),
  );
  final side = (card.shape as RoundedRectangleBorder).side;
  return side.color == AppColors.primary && side.width == 3;
}

void main() {
  testWidgets('ModeSelectionScreen renderiza los 3 títulos',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ModeSelectionScreen()),
    );

    expect(find.text('Solo jugar'), findsOneWidget);
    expect(find.text('Jugar y ver mi progreso'), findsOneWidget);
    expect(
      find.text('Jugar, ver mi progreso y conectar con un cuidador'),
      findsOneWidget,
    );
  });

  testWidgets('tocar cada tarjeta dispara onModeSelected con su número',
      (WidgetTester tester) async {
    final selected = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: ModeSelectionScreen(
          onModeSelected: (mode) async => selected.add(mode),
        ),
      ),
    );

    await tester.tap(find.text('Solo jugar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jugar y ver mi progreso'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.text('Jugar, ver mi progreso y conectar con un cuidador'),
    );
    await tester.pumpAndSettle();

    expect(selected, [1, 2, 3]);
    expect(_isHighlighted(tester, 3), isTrue);
    expect(_isHighlighted(tester, 1), isFalse);
  });

  testWidgets(
      'muestra un CircularProgressIndicator mientras simula el guardado '
      'cuando onModeSelected es null', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ModeSelectionScreen()),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.text('Solo jugar'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(
      'muestra el banner de error y Reintentar cuando onModeSelected falla',
      (WidgetTester tester) async {
    var calls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: ModeSelectionScreen(
          onModeSelected: (mode) async {
            calls++;
            throw Exception('fallo simulado');
          },
        ),
      ),
    );

    await tester.tap(find.text('Solo jugar'));
    await tester.pumpAndSettle();

    expect(
      find.text('No se pudo guardar tu modo. Intenta de nuevo.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(TextButton, 'Reintentar'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(calls, 1);

    await tester.tap(find.widgetWithText(TextButton, 'Reintentar'));
    await tester.pumpAndSettle();
    expect(calls, 2);
  });

  testWidgets('initialMode: 3 muestra esa tarjeta resaltada al construir',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ModeSelectionScreen(initialMode: 3)),
    );

    expect(_isHighlighted(tester, 3), isTrue);
    expect(_isHighlighted(tester, 1), isFalse);
    expect(_isHighlighted(tester, 2), isFalse);
  });
}
