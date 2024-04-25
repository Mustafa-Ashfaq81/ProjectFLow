// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:my_app/components/image.dart';
import 'package:my_app/components/msgprovider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:alarm/alarm.dart';
import 'package:my_app/auth/views/splashscreen.dart';
import 'package:my_app/auth/views/start.dart';
import 'package:my_app/auth/views/login.dart';
import 'package:my_app/auth/views/register.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/views/colab.dart';
import 'package:my_app/views/calendar.dart';
import 'package:my_app/views/settings/settings.dart';
import 'package:my_app/views/tasks/task.dart';
import 'package:my_app/views/tasks/completedtask.dart';
import 'package:my_app/views/tasks/completedSubtask.dart';
import 'package:my_app/views/tasks/newtask.dart';
import 'package:my_app/views/tasks/notesPage.dart';
import 'package:my_app/views/tasks/subtasks.dart';
import 'dart:convert';
import 'dart:io';

Future<void> runNodeServer() async {
  try {
    final serverDirectory = Directory('/server');
    final process =
        await Process.start('node', [serverDirectory.path + '/server.js']);
    process.stdout.transform(utf8.decoder).listen((output) {
      print('Node Server Output: $output');
    });
    process.stderr.transform(utf8.decoder).listen((error) {
      print('Node Server Error: $error');
    });
  } catch (e) {
    print("err running node js server... $e");
  }
}

Future initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  String apiKey = dotenv.env['API_KEY']!;
  String messagingSenderId = dotenv.env['MSG_SENDER_ID']!;
  String projectId = dotenv.env['PROJECT_ID']!;
  String appId = dotenv.env['APP_ID']!;

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
    ),
  );
}

Future main() async {
  await initialize();

  if (!kIsWeb) {
    //android
    await Alarm.init(showDebugLogs: true);
  }

  runApp(const MyApp(
    initialRoute: '/splash',
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  // This widget is the root of our application.
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MessageProvider>(
      create: (context) =>
          MessageProvider(), // Create an instance of MsgProvider
      child:
          MaterialApp(
        title: 'Flutter Hello World',
        theme: ThemeData(
          primaryColor: const Color(0xFFFFE6C9),
          scaffoldBackgroundColor: const Color(0xFFFFE6C9),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0x001e232c),
          ),
          fontFamily: 'Urbanist',
        ),

        initialRoute: initialRoute,
        // Project routes for the different screens
        routes: {
          '/': (context) => const StartPage(),
          '/splash': (context) => SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(
                username: "testUser",
              ),
          '/colab': (context) => const ColabPage(
                username: "testUser",
              ),
          '/calendar': (context) => const CalendarPage(
                username: "testUser",
              ),
          '/settings': (context) => const SettingsPage(
                username: "testUser",
              ),
          '/alltasks': (context) => const AllTasksPage(
                username: "testUser",
              ),
          '/newtask': (context) => const NewTaskPage(
                username: "testUser",
              ),
          '/task': (context) => const TaskDetailsPage(
                username: "testUser",
                task: {},
              ),
          '/completedtask': (context) => const CompletedTaskPage(
                username: "testUser",
                task: {},
              ),
          '/completedsubtask': (context) => const CompletedSubtaskPage(
                subtask: {},
              ),
          '/subtasks': (context) => const SubTaskPage(
                username: "testUser",
                subtasks: [],
                subtaskIndex: -1,
                taskheading: "zzz",
              ),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
