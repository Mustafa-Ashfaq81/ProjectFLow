import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() => runApp(MyApp());

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

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Home')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 150, // Increase the width of the buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Login'),
              ),
            ),
            
            SizedBox(height: 20), // Adding some spacing
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Register'),

              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
        automaticallyImplyLeading: false, // Remove the default back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(height: 5),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 5),
            // ignore: prefer_const_constructors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [


                // ignore: prefer_const_constructors
                Text(
                  'Welcome back! Glad to \n see you, Again!',
                  // textAlign: TextAlign.center,
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ),



                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 5),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter your Email',
                  fillColor: Colors.white, 
                  filled: true, 
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), 
                  ),
                ),
              ),

                SizedBox(height: 10), // Increased height for more spacing

                TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter your Password',
                  fillColor: Colors.white, // Set the fill color to white
                  filled: true, 
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400), // Change the border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Change the border color when the field is selected
                  ),
                ),
              ),



                SizedBox(height: 20),

                ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E232C), // Button background color
                  foregroundColor: Colors.white, // Button text color set to white
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  minimumSize: Size(200, 50),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              )

              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Register now',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Register')),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(height: 5),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome! Glad to \n see you!',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 5),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true,

                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E232C), // Button background color
                    foregroundColor: Colors.white, // Button text color set to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    minimumSize: Size(200, 50),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),

                  child: Text(
                  'Register',
                  style: TextStyle(
                  fontSize: 18, // Adjust the font size here
                  fontWeight: FontWeight.bold, // Make the text bold
                  )
                  )




                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Login now',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Notes')),
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: Text('My ideas will be here...'),
      ),
    );
  }
}