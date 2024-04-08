// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:my_app/auth/views/start.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
// import 'package:audioplayers/audioplayers.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FlameSplashController controller;

  @override
  void initState() {
    super.initState();
    controller = FlameSplashController(
      fadeInDuration: const Duration(seconds: 1),
      fadeOutDuration: const Duration(milliseconds: 250),
      waitDuration: const Duration(seconds: 2),
      autoStart: true,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        showBefore: (BuildContext context) {
          return const Text(
            "Where Ideas Turn Into Reality",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        },
        onFinish: (context) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        ),
        controller: controller,
      ),
    );
  }
}
