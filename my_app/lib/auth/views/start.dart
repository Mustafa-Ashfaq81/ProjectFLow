// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_app/auth/views/login.dart';
import 'package:my_app/auth/views/register.dart';
import 'package:my_app/controllers/alarmapi.dart';

// This file contains the StartPage widget, which serves as the main navigation hub
// for the application, providing buttons that lead to the Login, Register, and Alarm API pages.

// Users land on this page once the spash screen animation has completed.

class StartPage extends StatelessWidget  /// A stateless widget that displays the home screen of the application, offering naviation to different pages.
{
  const StartPage({super.key});

  @override
  Widget build(BuildContext context)  // Constructs the UI for the StartPage including the AppBar and buttons for navigation.
  {
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text(
              'Home',
              style: TextStyle(
                color: Colors.white, 
              ),
            ),
          ),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false, // Disable automatic back button
        ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 150, 
              child: ElevatedButton(
                onPressed: () 
                {
                  Navigator.push( context, MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                },
                child: const Text('Login'),
              ),
            ),
            const SizedBox(height: 20), 
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () 
                {
                   Navigator.push( context, MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                },
                child: const Text('Register'),
              ),
            ),
            const SizedBox(height: 20), 
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () 
                {
                   Navigator.push( context, MaterialPageRoute(builder: (context) => const AlarmPage()),
                    );
                },
                child: const Text('Alarm api'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}