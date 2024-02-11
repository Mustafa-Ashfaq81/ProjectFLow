import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/auth/pages/start.dart';
import 'package:my_app/auth/pages/login.dart';
import 'package:my_app/auth/pages/register.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


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

       theme: ThemeData(
      // useMaterial3: true, // Uncomment if you want to use Material 3 features
      primaryColor: Color(0xFFFFE6C9),
      scaffoldBackgroundColor: Color(0xFFFFE6C9),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0x1E232C), // Use this for buttons or specify in button style
      ),
      fontFamily: 'Urbanist', // Apply Urbanist as the default font for your app
    ),


      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage()
      },
    );
  }
}

void testingfunc() {
  int x = 4;
  print(x);
  print("my func called.....");
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Notes')),
        // automaticallyImplyLeading: false, // Remove the default back button
         backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('My ideas will be here...'),
      ),
    );
  }
}
