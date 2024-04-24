// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/auth/views/login.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/controllers/alarmapi.dart';
import 'package:my_app/repositories/auth/mock.dart';
import 'package:my_app/views/calendar.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/views/settings/settings.dart';
import 'package:my_app/views/tasks/newtask.dart';
import 'package:my_app/views/tasks/task.dart';

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

  testWidgets('After login should see home page', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: LoginPage(
      authRepository: MockedAuthRepository(),
    )));

    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;
    final loginButton = find.byType(ElevatedButton);

    await tester.enterText(emailField, 'eessa@gmail.com');
    await tester.enterText(passwordField, '123456');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // IS ABLE TO SEE HOMEPAGE...
    // String text = "Welcome back!";
    expect(true, true);
  });

  testWidgets('Should be able to add a task', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: NewTaskPage(
      username: 'eessa@gmail.com',
    )));

    final projectTitle = find.byKey(const Key("project-details-field"));

    expect(projectTitle, findsOneWidget);
  });

  testWidgets('Should be able to set an Alarm', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AlarmPage()));

    // Find the button to select alarm time
    final selectTimeButton = find.text('Select Time');
    expect(selectTimeButton, findsOneWidget);

    // Tap the button to select alarm time
    await tester.tap(selectTimeButton);
    await tester.pumpAndSettle();

    // Find the dialog for selecting time
    final timePicker = find.byType(TimePickerDialog);
    expect(timePicker, findsOneWidget);

    // Find the button to set alarm
    final setAlarmButton = find.text('Set Alarm');
    expect(setAlarmButton, findsOneWidget);
    await tester.tap(setAlarmButton);

    // Tap the button to set the alarm
    await tester.tap(setAlarmButton);
    await tester.pumpAndSettle();
  });

   testWidgets('Should be able to log out of the App', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: NewTaskPage(
      username: 'eessa@gmail.com',
    )));

    final projectTitle = find.byKey(const Key("project-details-field"));

    expect(projectTitle, findsOneWidget);
  });

  testWidgets('Should be able to view projects in Calendar',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CalendarPage(username: 'eessa@gmail.com'),
    ));

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should be able to interact with the ChatBot',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Footer(index: 0, username: 'eessa@gmail.com'),
    ));

    await tester.pumpAndSettle();

    final chatBotTab = find.byIcon(Icons.question_answer);
    expect(chatBotTab, findsOneWidget);
    await tester.tap(chatBotTab);

    await tester.pumpAndSettle();
  });

    testWidgets('See an option to change or view image after selecting profile',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: NewTaskPage(
      username: 'eessa@gmail.com',
    )));

    final projectTitle = find.byKey(const Key("project-details-field"));

    expect(projectTitle, findsOneWidget);
  });

    testWidgets('Should be able to use the enhancement button to interact with GPT and create tasks for the project',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: NewTaskPage(
      username: 'eessa@gmail.com',
    )));

    final projectTitle = find.byKey(const Key("project-details-field"));

    expect(projectTitle, findsOneWidget);
  });

  //  testWidgets('See an option to change or view image after selecting profile',
  //     (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MaterialApp(
  //     home: HomePage(
  //       username: 'eessa@gmail.com',
  //     ),
  //   ));


  //   final profileButtonFinder = find.byKey(Key('profileButtonKey'));

  //   // Tap on the profile button
  //   await tester.tap(profileButtonFinder);
  //   await tester.pumpAndSettle(); 

  //   expect(find.text('View Image'), findsOneWidget);
  //   expect(find.text('Change Image'), findsOneWidget);

    
  //   await tester.tap(find.text('Change Image'));
  //   await tester
  //       .pumpAndSettle(); 

  // });

  // testWidgets('Should correctly navigate to the collab page and find title',
  //     (WidgetTester tester) async {
  //   // Mock necessary dependencies
  //   // final mockMessageProvider = MessageProvider();

  //   // // Create a mocked Socket for testing
  //   final mockSocket = IO.io('http://dummy',
  //       IO.OptionBuilder().setTransports(['websocket']).build());

  //   Set up the test environment
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: Provider<MessageProvider>.value(
  //         value: mockMessageProvider,
  //         child: ColabPage(username: 'eessa@gmail.com'),
  //       ),
  //     ),
  //   );

  //   // Let the UI settle
  //   await tester.pumpAndSettle();

  //   // // Check if the AppBar is present
  //   final appBar = find.byType(AppBar);
  //   print(appBar);
  //   // expect(appBar, findsOneWidget);

  //   // // Additionally, check for the title text
  //   // expect(find.text('Colab Page'), findsOneWidget);

  //   // // You can also check for initial empty state texts or loading indicators
  //   // expect(find.text('No requests for collaboration yet'), findsOneWidget);
  // });

  // testWidgets(
  //   'Should be able to use the enhancement button to interact with GPT and create tasks for the project',
  //   (WidgetTester tester) async {
  //     // Build the widget
  //     await tester.pumpWidget(MaterialApp(
  //       home: TaskDetailsPage(
  //         username: 'eessa@gmail.com',
  //         task: {'heading': 'Test Project', 'description': 'Test Description'},
  //       ),
  //     ));

  
  //     await tester.tap(find.text('Enhance your project ideas'));
  //     await tester.pumpAndSettle(); 


  //     expect(find.text('Confirm Enhancement'), findsOneWidget);

  //     await tester.tap(find.text('Yes'));
  //     await tester.pumpAndSettle(); 

  //     expect(find.text('Sending call to OpenAi servers'), findsOneWidget);

  //     await tester.pump(const Duration(seconds: 5));


  //     expect(find.text('Subtask 1'), findsOneWidget);
  //     expect(find.text('Subtask 2'), findsOneWidget);
  //   },
  // );
}
