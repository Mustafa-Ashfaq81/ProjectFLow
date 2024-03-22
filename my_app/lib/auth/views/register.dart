// ignore_for_file: avoid_print, duplicate_ignore, use_build_context_synchronously, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/auth/views/login.dart';
import 'package:my_app/auth/controllers/authservice.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/models/taskmodel.dart';
import '../../common/toast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Register')),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
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
                        // decoration: BoxDecoration(), // You can add decoration if needed
                        child:
                            const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome! Glad to \n see you!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                      controller: _confirmPasswordController,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E232C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        minimumSize: const Size(200, 50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      child: isSigningUp
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Register',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login now',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  void _register() async 
  {
    String email = _emailController.text;
    String password = _passwordController.text;
    String pass = _confirmPasswordController.text;
    String name = _usernameController.text;

    // Email regex for validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );

    // Password complexity regex
    final passwordRegex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*]).{8,}$',
    );

    // Empty field checks
    if (email.isEmpty || password.isEmpty || pass.isEmpty || name.isEmpty) {
      showerrormsg(message: "Please fill in all fields");
      return;
    }

    // Email format validation
    if (!emailRegex.hasMatch(email)) {
      showerrormsg(message: "Please enter a valid email address");
      return;
    }

    // Password complexity validation
    if (!passwordRegex.hasMatch(password)) {
      showerrormsg(
          message:
              "Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.");
      return;
    }

    // Password match validation
    if (password != pass) {
      showerrormsg(message: "Passwords do not match \nIcon: \u{1F6A8}");
      return;
    }
    else 
    {
      setState(() 
      {
        isSigningUp = true;
      });
      var allusernames = await getallUsers();
      if (allusernames.contains(name) == true) 
      {
        showerrormsg(message: 'username already taken \nIcon: \u{1F6A8}');
      } 

      else 
      {
        User? user = await _auth.registeracc(email, password);
        if (user != null) {
          print("User is successfully created");
          List<Map<String, dynamic>>? mappedtasks = maptasks(get_random_task());
          try {
            createUser(
                UserModel(username: name, email: email, tasks: mappedtasks));
          } catch (e) {
            print("got-some-err-creating-user-model ---> $e");
          }
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  username: name,
                ),
              ));
        } else {
          print(" some error occurred ... has been TOASTED");
        }
      }
      setState(() {
        isSigningUp = false;
      });
    }
  }
}
