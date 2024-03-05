import 'package:flutter/material.dart';
import 'package:my_app/auth/views/start.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override 
  void initState() { 
    super.initState(); 
  } 
  @override 
  Widget build(BuildContext context) { 
    return AnimatedSplashScreen(
      //splash: 'pictures/my_app_logo.png',
      splash:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column( 
          children: [   
            Center(child:Image.asset('pictures/my_app_logo.png', height:100, width:200)),
            Container(
              padding: const EdgeInsets.only(top: 50.0), 
              child: const Text(
                'Welcome to the Idea Enhancer App!',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      duration: 5000, //5 seconds
      nextScreen: const StartPage(),
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
    );
  } 
}