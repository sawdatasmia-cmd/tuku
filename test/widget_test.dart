import 'package:flutter_test/flutter_test.dart';

import 'package:tuku/main.dart';

void main() {
  testWidgets('Tuku app shows the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TukuApp());

    expect(find.text('Tuku'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Create one'), findsOneWidget);
  });
}
