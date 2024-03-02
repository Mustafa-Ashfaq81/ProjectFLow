import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/auth/pages/start.dart';
import 'package:my_app/auth/pages/login.dart';
import 'package:my_app/auth/pages/register.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/pages/task.dart';
import 'package:my_app/pages/settings.dart';
import 'package:my_app/pages/chat.dart';
import 'package:my_app/pages/calendar.dart';
import 'package:my_app/pages/colab.dart';
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
        buttonColor: Color(0x001e232c), // Use this for buttons or specify in button styl
      
      ),
      fontFamily: 'Urbanist', // Apply Urbanist as the default font for your app
 
    ),


      initialRoute: '/',
      routes: {
        // ignore: prefer_const_constructors
        '/': (context) => StartPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(
              username: "routedfrommainpage",
            ),
        '/tasks': (context) => const TaskPage(
              username: "routedfrommainpage",
            ),
        '/settings': (context) => const SettingsPage(
              username: "routedfrommainpage",
            ),
        '/calendar': (context) => const CalendarPage(
              username: "routedfrommainpage",
            ),
        '/chat': (context) => const ChatPage(
              username: "routedfrommainpage",
            ),
          '/colab': (context) => const ColabPage(
              username: "routedfrommainpage",
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
