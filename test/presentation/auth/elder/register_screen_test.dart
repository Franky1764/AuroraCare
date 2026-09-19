import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_care/presentation/auth/elder/register_screen.dart';

void main() {
  testWidgets(
      'RegisterScreen muestra el botón y no envía el formulario si los '
      'campos están vacíos', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    expect(find.widgetWithText(ElevatedButton, 'Crear mi cuenta'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Crear mi cuenta'));
    await tester.pumpAndSettle();

    expect(find.text('Cuéntanos cómo te llamamos'), findsOneWidget);
    expect(find.text('Ingresa un correo válido'), findsOneWidget);
    expect(
      find.text('La contraseña debe tener al menos 6 caracteres'),
      findsOneWidget,
    );
  });
}
