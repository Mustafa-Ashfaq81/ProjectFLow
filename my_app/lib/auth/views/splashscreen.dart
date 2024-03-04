import 'package:flutter/material.dart';
import 'package:my_app/auth/views/start.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:page_transition/page_transition.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override 
  void initState() { 
    super.initState(); 
    // Timer(Duration(seconds: 3),
      // ()=>Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => StartPage())) ); 
  } 
  @override 
  Widget build(BuildContext context) { 
    return AnimatedSplashScreen(
      splash: 'pictures/my_app_logo.png',
      duration: 5,
      nextScreen: const StartPage(),
      splashTransition: SplashTransition.rotationTransition,
      // pageTransitionType: PageTransitionType.scale,
    );
  } 
}