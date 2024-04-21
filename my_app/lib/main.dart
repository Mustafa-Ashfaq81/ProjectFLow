// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/repositories/auth/app.dart';
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
// import 'package:my_app/views/chatroom.dart';
import 'package:my_app/views/calendar.dart';
import 'package:my_app/views/settings/settings.dart';
import 'package:my_app/views/tasks/task.dart';
import 'package:my_app/views/tasks/completedtask.dart';
import 'package:my_app/views/tasks/completedSubtask.dart';
import 'package:my_app/views/tasks/newtask.dart';
import 'package:my_app/views/tasks/notesPage.dart';
import 'package:my_app/views/tasks/subtasks.dart';

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
          // return
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
          '/login': (context) => LoginPage(
                authRepository: AuthRepository(),
              ),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(
                username: "abz",
              ),
          '/colab': (context) => const ColabPage(
                username: "abz",
              ),
          '/calendar': (context) => const CalendarPage(
                username: "abz",
              ),
          '/settings': (context) => const SettingsPage(
                username: "abz",
              ),
          '/alltasks': (context) => const AllTasksPage(
                username: "abz",
              ),
          '/newtask': (context) => const NewTaskPage(
                username: "abz",
              ),
          '/task': (context) => const TaskDetailsPage(
                username: "abz",
                task: {},
              ),
          '/completedtask': (context) => const CompletedTaskPage(
                username: "abz",
                task: {},
              ),
          '/completedsubtask': (context) => const CompletedSubtaskPage(
                subtask: {},
              ),
          '/subtasks': (context) => const SubTaskPage(
                username: "abz",
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
