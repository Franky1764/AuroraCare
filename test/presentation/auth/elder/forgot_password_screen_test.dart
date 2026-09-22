import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_care/presentation/auth/elder/forgot_password_screen.dart';

void main() {
  testWidgets('ForgotPasswordScreen renderiza el formulario inicial',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    expect(find.text('Olvidé mi contraseña'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Enviar instrucciones'),
      findsOneWidget,
    );
  });

  testWidgets(
      'ForgotPasswordScreen muestra error y no cambia de estado con '
      'correo inválido', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'rosa@correo.cl').first,
      'correo-invalido',
    );

    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Enviar instrucciones'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ingresa un correo válido'), findsOneWidget);
    expect(find.text('Revisa tu correo'), findsNothing);
  });

  testWidgets(
      'ForgotPasswordScreen cambia a la confirmación con correo válido',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'rosa@correo.cl').first,
      'rosa@correo.cl',
    );

    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Enviar instrucciones'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Revisa tu correo'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Volver a iniciar sesión'),
      findsOneWidget,
    );
  });
}
