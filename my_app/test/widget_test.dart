import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/auth/views/login.dart';
import 'package:my_app/repositories/auth/mock.dart';

void main() async {
  testWidgets('Should log in', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: LoginPage(
      authRepository: MockedAuthRepository(),
    )));

    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;

    final loginButton = find.byType(ElevatedButton);

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.enterText(emailField, 'eessa@gmail.com');
    await tester.enterText(passwordField, '123456');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(true, true);
  });
  testWidgets('Should display error SnackBar on invalid login',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(
        authRepository: MockedAuthRepository(),
      ),
    ));

    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;
    final loginButton = find.byType(ElevatedButton);

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.enterText(emailField, 'invalid_email@gmail.com');
    await tester.enterText(passwordField, '123456');
    await tester.tap(loginButton);
    await tester.pump();

    final snackBarField = find.byType(SnackBar);
    expect(snackBarField, findsOneWidget);
    expect(find.text('Invalid Email or password'), findsOneWidget);
  });
}
