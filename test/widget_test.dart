import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_care/main.dart';

void main() {
  testWidgets('AuroraCareApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: AuroraCareApp()),
    );

    expect(find.text('AuroraCare'), findsOneWidget);
  });
}
