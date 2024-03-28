// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_app/auth/views/login.dart';
import 'package:my_app/auth/views/register.dart';
// import 'package:my_app/controllers/alarmapi.dart';
import 'package:my_app/controllers/alarm2.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text(
              'Home',
              style: TextStyle(
                color: Colors.white, // Set text color to white
              ),
            ),
          ),
          backgroundColor: Colors.black, // Set background color to black
          automaticallyImplyLeading: false, // Disable automatic back button
        ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 150, // Increase the width of the buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push( context, MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                },
                child: const Text('Login'),
              ),
            ),
            const SizedBox(height: 20), // Adding some spacing
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.push( context, MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                },
                child: const Text('Register'),
              ),
            ),
            const SizedBox(height: 20), // Adding some spacing
            // SizedBox(
            //   width: 150,
            //   child: ElevatedButton(
            //     onPressed: () {
            //        Navigator.push( context, MaterialPageRoute(builder: (context) => const AlarmPage()),
            //         );
            //     },
            //     child: const Text('Alarm api'),
            //   ),
            // ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.push( context, MaterialPageRoute(builder: (context) => const AlarmPage()),
                    );
                },
                child: const Text('Alarm api 2 '),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}