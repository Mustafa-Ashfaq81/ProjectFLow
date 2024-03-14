// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/auth/views/register.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/auth/controllers/authservice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login')),
        automaticallyImplyLeading: false, 
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome back! Glad to \n see you, Again!',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 5),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your Email',
                    fillColor: Colors.white,
                    filled: true,
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  controller: _emailController,
                ),

                const SizedBox(height: 10), 

                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter your Password',
                    fillColor: Colors.white, 
                    filled: true,
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.grey.shade400), 
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .blue), 
                    ),
                  ),
                  controller: _passwordController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1E232C), 
                    foregroundColor:
                        Colors.white, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
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

    void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? useracc = await _auth.loginacc(email, password);

    if (useracc != null) {
      String user = "";
      print("User is successfully logging in");
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          //only one doc with that username
          user = doc['username'];
        }
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              username: user,
            ),
          ));
    } else {
      print("some error occured ... has been TOASTED");
    }
  }

}
