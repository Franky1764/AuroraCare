import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_care/presentation/auth/elder/register_screen.dart';

void main() {
  testWidgets('RegisterScreen renderiza los campos y el botón',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    expect(find.text('¿Cómo quiere que lo llamemos?'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Crear mi cuenta'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextButton, 'Ya tengo cuenta'),
      findsOneWidget,
    );
  });

  testWidgets(
      'RegisterScreen no envía el formulario si los campos están vacíos '
      'y muestra los mensajes de error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Crear mi cuenta'));
    await tester.pumpAndSettle();

    expect(find.text('Cuéntanos cómo te llamamos'), findsOneWidget);
    expect(find.text('Ingresa un correo válido'), findsOneWidget);
    expect(
      find.text('La contraseña debe tener al menos 6 caracteres'),
      findsOneWidget,
    );
  });

  testWidgets(
      'RegisterScreen ejecuta onRegisterSuccess cuando el formulario es '
      'válido', (WidgetTester tester) async {
    var registerSucceeded = false;

    await tester.pumpWidget(
      MaterialApp(
        home: RegisterScreen(
          onRegisterSuccess: () => registerSucceeded = true,
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Rosa').first,
      'Rosa',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'rosa@correo.cl').first,
      'rosa@correo.cl',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, '••••••').first,
      '123456',
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Crear mi cuenta'));
    await tester.pumpAndSettle();

    expect(registerSucceeded, isTrue);
  });
}
