import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_care/presentation/onboarding/role_selection_screen.dart';

void main() {
  testWidgets(
      'RoleSelectionScreen muestra ambos roles y dispara sus callbacks',
      (WidgetTester tester) async {
    var elderTapped = false;
    var caregiverTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: RoleSelectionScreen(
          onSelectElder: () => elderTapped = true,
          onSelectCaregiver: () => caregiverTapped = true,
        ),
      ),
    );

    expect(find.text('Soy adulto mayor'), findsOneWidget);
    expect(find.text('Soy cuidador o familiar'), findsOneWidget);

    await tester.tap(find.text('Soy adulto mayor'));
    await tester.pumpAndSettle();
    expect(elderTapped, isTrue);

    await tester.tap(find.text('Soy cuidador o familiar'));
    await tester.pumpAndSettle();
    expect(caregiverTapped, isTrue);
  });
}
