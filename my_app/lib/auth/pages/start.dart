import 'package:flutter/material.dart';
import 'package:my_app/auth/pages/login.dart';
import 'package:my_app/auth/pages/register.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home',
        style: TextStyle(color: Colors.white),)),
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
            )
          ],
        ),
      ),
    );
  }
}