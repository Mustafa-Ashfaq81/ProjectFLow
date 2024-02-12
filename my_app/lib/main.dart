import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/auth/pages/start.dart';
import 'package:my_app/auth/pages/login.dart';
import 'package:my_app/auth/pages/register.dart';
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
        '/home': (context) => HomePage()
      },
    );
    
  }
}

// // {-theme: ThemeData(
//   // useMaterial3: true, // Uncomment if you want to use Material 3 features
//   primaryColor: Color(0xFFFFE6C9),
//   scaffoldBackgroundColor: Color(0xFFFFE6C9),
//   buttonTheme: ButtonThemeData(
//     buttonColor: Color(0xFFFFE6C9), //  Use this for buttons or specify in button style
//   ),
// ),}

void testingfunc() {
  int x = 4;
  print(x);
  print("my func called.....");
}

class HomePage extends StatefulWidget 
{
  final String? username;

  HomePage({Key? key, this.username}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Here you can add functionality to navigate to different pages or update the UI accordingly
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Notes')),
        backgroundColor: Colors.black,
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('pictures/profile.png'), // Your profile image
                  radius: 24, // Adjust as needed
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 0.0),
            child: Text(
              'Essa Shahid Arshad', // Your name
              style: TextStyle(
                fontFamily: 'PilotExtended', 
                fontSize: 23, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Decrease the height here to move the search box up
          SizedBox(height: 20), // Adjust this value as needed to control space below your name
          Container(
            width: 410, // Width of the search box
            height: 85, // Height of the search box
            padding: EdgeInsets.only(left: 30), // Padding inside the container for alignment
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Tasks',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF000000), // Adjust the hint color
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Radius of the text field
                  borderSide: BorderSide.none, // Removes default border
                ),
                filled: true, // Needed for fillColor to work
                fillColor: Color(0xFFFFFFFF), // Background color of the text field
                prefixIcon: Icon(
                  Icons.search, // Use the search icon
                  color: Color(0xFF000000), // Adjust the icon color
                ),
              ),
            ),
          ),
            Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 0.0),
            child: Text(
              'Completed Tasks', // Your name
              style: TextStyle(
                fontFamily: 'Inter', 
                fontSize: 22, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Row(
       crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 30.0, top: 10.0),
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            color: Color(0xFFE16C00).withOpacity(0.48),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              'Your Content Here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.0), // Adjust the space between the containers
        Container(
          margin: const EdgeInsets.only(left: 0.0, top: 10.0),
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            color: Color(0xFF141310),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              'Your Content Here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),

          

             Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20.0),
            child: Text(
              'Ongoing Projects', // Your name
              style: TextStyle(
                fontFamily: 'Inter', 
                fontSize: 22, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

           Column(
       crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 30.0, top: 10.0),
          height: 90.0,
          width: 450.0,
          decoration: BoxDecoration(
            color: Color(0xFFE16C00).withOpacity(0.48),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              'Your Content Here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        // SizedBox(width: 20.0), // Adjust the space between the containers
        Container(
          margin: const EdgeInsets.only(left: 30.0, top: 15.0),
          height: 90.0,
          width: 450.0,
          decoration: BoxDecoration(
            color: Color(0xFF141310),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              'Your Content Here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
          
          // Expanded(
          //   child: Center(
          //     child: Text('My ideas will be here...'),
          //   ),
          // ),
        ],
      ),
      
bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // This custom theme only applies to the BottomNavigationBar.
          canvasColor: Colors.black, // Forcefully sets the background color
          primaryColor: Colors.white, // This will affect the selected item color.
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.white.withOpacity(0.6)), // This will affect the unselected item color.
              ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
          icon: Icon(Icons.add),  
          label: '',
           ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white, 
          unselectedItemColor: Colors.white.withOpacity(0.6), 
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// background: #000000;