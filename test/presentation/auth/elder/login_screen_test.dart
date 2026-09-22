import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_care/presentation/auth/elder/login_screen.dart';

void main() {
  testWidgets('LoginScreen renderiza los campos y los elementos interactivos',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
    expect(
      find.widgetWithText(TextButton, 'Olvidé mi contraseña'),
      findsOneWidget,
    );
    expect(find.widgetWithText(TextButton, 'Crear cuenta'), findsOneWidget);
  });

  testWidgets(
      'LoginScreen no envía el formulario si los campos están vacíos y '
      'muestra los mensajes de error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa un correo válido'), findsOneWidget);
    expect(find.text('Ingresa tu contraseña'), findsOneWidget);
  });

  testWidgets('LoginScreen ejecuta onLoginSuccess cuando el formulario es válido',
      (WidgetTester tester) async {
    var loginSucceeded = false;

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          onLoginSuccess: () => loginSucceeded = true,
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'carla@email.com').first,
      'carla@email.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, '••••••').first,
      'secreta123',
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pumpAndSettle();

    expect(loginSucceeded, isTrue);
  });
}
