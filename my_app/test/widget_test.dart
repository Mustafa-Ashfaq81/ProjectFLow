import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';

void main() async {
  setUpAll(() async {
    await initialize();
  });

  testWidgets('Sample Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: MyApp(
      initialRoute: '/login',
    )));

    await tester.pumpAndSettle();
    final emailFieldFinder = find.byType(TextFormField).first;
    expect(emailFieldFinder, findsOneWidget);
  });
}
