import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:my_app/auth/views/splashscreen.dart';
import 'package:my_app/auth/views/start.dart';
import 'package:my_app/auth/views/login.dart';
import 'package:my_app/auth/views/register.dart';

import 'package:my_app/views/home.dart';
import 'package:my_app/views/calendar.dart';
import 'package:my_app/views/colab.dart';
import 'package:my_app/views/settings/settings.dart';
import 'package:my_app/views/tasks/task.dart';
import 'package:my_app/views/tasks/alltasks.dart';
import 'package:my_app/views/tasks/subtasks.dart';
import 'package:my_app/views/tasks/newtask.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter/gestures.dart';


Future main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(); // Load the environment variables
  String apiKey = dotenv.env['API_KEY']!;
  String messagingSenderId = dotenv.env['MSG_SENDER_ID']!;
  String projectId = dotenv.env['PROJECT_ID']!;
  String appId = dotenv.env['APP_ID']!;

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey:apiKey ,
        appId: appId ,
        messagingSenderId: messagingSenderId ,
        projectId:projectId, 
      ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {  // This widget is the root of your application.
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    testingfunc();
    return MaterialApp(
      title: 'Flutter Hello World',

      theme: ThemeData
      (
      // useMaterial3: true, // Uncomment if you want to use Material 3 features
      primaryColor: const Color(0xFFFFE6C9),
      scaffoldBackgroundColor: const Color(0xFFFFE6C9),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0x001e232c), // Use this for buttons or specify in button style
      ),
      fontFamily: 'Urbanist', // Apply Urbanist as the default font for your app
    ),


      initialRoute: '/splash',
      routes: {
        // ignore: prefer_const_constructors
        '/splash' : (context) => SplashScreen(), 
        '/': (context) => const StartPage(),
        '/login': (context) => const LoginPage(),
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
              task:{},
            ),
           '/subtasks': (context) => const SubTaskPage(
              username: "abz",
              taskIndex: 0,
            ),
      },
      debugShowCheckedModeBanner: false, 
    );
  }
}

void testingfunc() {
  print(" my app is being built.....");
}


// // {-theme: ThemeData(
//   // useMaterial3: true, // Uncomment if you want to use Material 3 features
//   primaryColor: Color(0xFFFFE6C9),
//   scaffoldBackgroundColor: Color(0xFFFFE6C9),
//   buttonTheme: ButtonThemeData(
//     buttonColor: Color(0xFFFFE6C9), //  Use this for buttons or specify in button style
//   ),
// ),}
