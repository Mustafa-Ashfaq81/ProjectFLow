// ignore_for_file: avoid_print, duplicate_ignore, use_build_context_synchronously, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/auth/views/login.dart';
import 'package:my_app/auth/controllers/authservice.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/utils/cache_util.dart';
import 'package:my_app/utils/inappmsgs_util.dart';

// This file contains the RegisterPage widget which handles user registration
// using FirebaseAuth. It provides UI for username, email, and password inputs and
// handles their validation and submission.

class RegisterPage
    extends StatefulWidget // A stateful widget that provides a user registration interface
{
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<
    RegisterPage> // State class for `RegisterPage` that handles user input and registration logic
{
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureText = true;
  bool _obscureConfirmPassword = true;

  bool isSigningUp = false;

  @override
  void
      dispose() // Dispose controllers to free up resources when the widget is removed from the tree.
  {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(
      BuildContext
          context) // Constructs the user interface for the registration page.
  {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Register',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        )),
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
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
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
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

  void
      _register() async // Handles the user registration process by validating inputs and creating a new user account
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
      showCustomError("Please fill in all the fields", context);
      return;
    }

    // Email format validation
    if (!emailRegex
        .hasMatch(email)) // Check if email follows standard email pattern.
    {
      // showerrormsg(message: "Please enter a valid email address");
      showCustomError("Please enter a valid email address", context);
      return;
    }

    // Password complexity validation
    if (!passwordRegex.hasMatch(password)) {
      // showerrormsg(
      //     message:
      //         "Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.");
      showCustomError(
          "Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.",
          context);

      return;
    }

    // Password match validation
    if (password != pass) {
      // showerrormsg(message: "Passwords do not match \u{1F6A8}");
      showCustomError("Passwords do not match \u{1F6A8}", context);
      return;
    } else {
      setState(() {
        isSigningUp =
            true; // Indicate that the registration process has started.
      });
      var allusernames = await getallUsers();
      if (allusernames.contains(name) == true) {
        // showerrormsg(message: 'username already taken \u{1F6A8}');
        showCustomError('username already taken \u{1F6A8}', context);
      } else {
        User? user = await _auth.registeracc(email, password, context);
        if (user != null) {
          print("User is successfully created");
          // List<Map<String, dynamic>>? mappedtasks = maptasks(get_random_task());
          List<Map<String, dynamic>> mappedtasks = [];
          try {
            createUser(
                UserModel(username: name, email: email, tasks: mappedtasks));
            await TaskService().fetchAndCacheNotesData(name);
            await TaskService().fetchAndCacheColabRequests(name);
          } catch (e) {
            print(
                "An Error Occured While Creating the User Model. Error: ---> $e");
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
        isSigningUp =
            false; // Indicate that the registration process has started.
      });
    }
  }
}
