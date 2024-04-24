// ignore_for_file: unnecessary_null_comparison

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Login Flow', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('logs in the user', () async {
      // Find text input fields and buttons. Adjust these finders to match your widgets.
      final emailFieldFinder = find.byValueKey('email_input');
      final passwordFieldFinder = find.byValueKey('password_input');
      final loginButtonFinder = find.byValueKey('login_button');

      // Wait for the email field to be present
      await driver.waitFor(emailFieldFinder);

      // Enter text into fields
      await driver.tap(emailFieldFinder);
      await driver.enterText('test@example.com');

      await driver.tap(passwordFieldFinder);
      await driver.enterText('testpassword');

      // Tap the login button
      await driver.tap(loginButtonFinder);

      // Optionally, check for navigation to the next page or check for success messages
      final successFinder = find.text(
          'Login Successful'); // Adjust as per your success message or screen
      await driver.waitFor(successFinder);

      // You can add more assertions here to validate your app's state
    });
  });
}
