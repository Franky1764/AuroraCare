import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_care/presentation/onboarding/welcome_screen.dart';

void main() {
  testWidgets('WelcomeScreen muestra el título y el botón Comenzar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    expect(find.text('AuroraCare'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Comenzar'), findsOneWidget);
  });
}
