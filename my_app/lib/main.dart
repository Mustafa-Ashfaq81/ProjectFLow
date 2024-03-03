import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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

  runApp(MyApp());
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
      primaryColor: Color(0xFFFFE6C9),
      scaffoldBackgroundColor: Color(0xFFFFE6C9),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0x1E232C), // Use this for buttons or specify in button styl
      
      ),
      fontFamily: 'Urbanist', // Apply Urbanist as the default font for your app
 
    ),


      initialRoute: '/',
      routes: {
        // ignore: prefer_const_constructors
        '/': (context) => StartPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(
              username: "abz",
            ),
          '/colab': (context) => ColabPage(
              username: "abz",
            ),
        '/calendar': (context) => CalendarPage(
              username: "abz",
            ),
        '/settings': (context) => SettingsPage(
              username: "abz",
            ),
        '/alltasks': (context) => AllTasksPage(
              username: "abz",
            ),
        '/task': (context) => TaskDetailsPage(
              username: "abz",
              task:{},
            ),
           '/subtasks': (context) => SubTaskPage(
              username: "abz",
              taskIndex: 0,
            ),
            '/newtask': (context) => NewTaskPage(
              username: "abz",
            ),
      },
    );
  }
}

void testingfunc() {
  int x = 5;
  print("$x my app is being built.....");
}


// // {-theme: ThemeData(
//   // useMaterial3: true, // Uncomment if you want to use Material 3 features
//   primaryColor: Color(0xFFFFE6C9),
//   scaffoldBackgroundColor: Color(0xFFFFE6C9),
//   buttonTheme: ButtonThemeData(
//     buttonColor: Color(0xFFFFE6C9), //  Use this for buttons or specify in button style
//   ),
// ),}
