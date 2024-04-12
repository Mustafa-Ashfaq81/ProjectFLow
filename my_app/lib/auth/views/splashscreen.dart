// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:my_app/auth/views/start.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';

// This file implements the SplashScreen widget using the FlameSplashScreen library
// to display an animated splash screen as the app loads.



class SplashScreen extends StatefulWidget  // A stateful widget that displays an animated splash screen using FlameSplashScreen.
{
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  // State for the SplashScreen widget. Manages the lifecycle of the splash animation.
{
  late FlameSplashController controller;

  @override
  void initState()  // Initialize the splash screen controller with custom durations for animation phases
  {
    super.initState();
    controller = FlameSplashController(
      fadeInDuration: const Duration(seconds: 1),
      fadeOutDuration: const Duration(milliseconds: 250),
      waitDuration: const Duration(seconds: 2),
      autoStart: true,
    );
  }

  @override
  void dispose() // Clean up the controller when the widget is disposed to avoid memory leaks
  {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) /// This Widget Builds the splash screen UI with a logo and a custom message.
  {
    return Scaffold(
      body: FlameSplashScreen(
        theme: FlameSplashTheme(
          logoBuilder: (context) => Image.asset(
            'pictures/my_app_logo1.png',
            width: 200,
            height: 200,
          ),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
        showBefore: (BuildContext context) 
        {
          return const Text(
            "Where Ideas Turn Into Reality",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        },
        onFinish: (context) => Navigator.pushReplacement( // Transition to the StartPage once the splash animation completes
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        ),
        controller: controller,
      ),
    );
  }
}
