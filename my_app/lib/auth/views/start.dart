import 'package:flutter/material.dart';
import 'package:my_app/auth/views/login.dart';
import 'package:my_app/auth/views/register.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Home')),
         backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 150, // Increase the width of the buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push( context, MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                },
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 20), // Adding some spacing
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.push( context, MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
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