// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/auth/views/register.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/models/usermodel.dart';
// import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/auth/controllers/authservice.dart';
import 'package:my_app/utils/cache_util.dart';

// This file contains the LoginPage widget which handles user authentication
// via Firebase for our note-taking application. It supports simple email/password as well as Google sign-in methods.


class LoginPage extends StatefulWidget  /// A stateful widget that provides a login interface for the application.
{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>  // State for `LoginPage` that handles the login logic and user input.
{
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  var isLoggingIn = false;

  @override
  void dispose()  // Clean up controllers when the widget is disposed.
  {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context)  // Builds the login interface with email and password fields, a login button, and a Google sign-in option.
  {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Login',
            textAlign: TextAlign.center, 
            style: TextStyle(
              color: Colors.white, 
            ),
          ),
        ),
        automaticallyImplyLeading: false, // Disable automatic back button
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
                  onTap: () 
                  {
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
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Enter your Password',
                    fillColor: Colors.white,
                    filled: true,
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
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
                ElevatedButton(
                  onPressed: _login,
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
                  child: isLoggingIn ? CircularProgressIndicator() :const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  color: Colors.grey[400],
                  thickness: 0.5,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Or continue with',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Expanded(
                    child: Divider(
                  color: Colors.grey[400],
                  thickness: 0.5,
                )),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final usercred = await _auth.signInWithGoogle(context);
                    if (usercred != null) 
                    {
                     await _loginGmail(usercred);
                    }
                  },
                  child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200]),
                      child:
                          Image.asset("pictures/google-icon.png", height: 40)),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
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

  void _login() async  /// Initiates the login process using the entered email and password.
  {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() 
    {
      isLoggingIn = true;
    });

    try 
    {
      String user = "";
        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get()
            .then((QuerySnapshot querySnapshot) 
            {
          for (var doc in querySnapshot.docs) 
          {
            user = doc['username'];
          }
      });
      User? useracc = await _auth.loginacc(email, password,user,context);

      if (useracc != null) 
      {
        print("User is successfully logging in");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                username: user,
              ),
            ));
      }
    } on FirebaseAuthException catch (e)    // Handle different Firebase authentication errors.
    {
      String message;
      switch (e.code) 
      {
        case "user-not-found":
          message = "No user found for that email.";
          break;
        case "wrong-password":
          message = "Wrong password provided for that user.";
          break;
        case "network-request-failed":
          message = "Check your internet connection and try again.";
          break;
        default:
          message = "An unexpected error occurred. Please try again.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to log in. Please try again later.")),
      );
    }

    setState(() 
    {
      isLoggingIn = false;
    });
  }
  
  Future<void> _loginGmail(UserCredential usercred) async  //if the user is not created, we create that user in db else we just login using the method
  { 
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logging in with Gmail ... '),duration: Duration(seconds: 3),));
    var username = usercred.user!.displayName;
    final gmail = usercred.user!.email;
    List<String> allemails = await getallEmails();
    if (allemails.contains(gmail) == false) {
      var allusernames = await getallUsers();
      if (allusernames.contains(username) == true) 
      {
        int suffix = 1; // To ensure username remains unique, we append a suffix to it if it already exists.
        String newUsername = username!;
        while (allusernames.contains(newUsername)) 
        {
          newUsername = '$username!_${suffix++}';
        }
        username = newUsername;
      }
      // List<Map<String, dynamic>>? mappedtasks = maptasks(get_random_task());
      List<Map<String, dynamic>> mappedtasks = [];
      try 
      {
        createUser(UserModel(username: username, email: gmail, tasks: mappedtasks));
        await TaskService().fetchAndCacheNotesData(username!);
        await TaskService().fetchAndCacheColabRequests(username);
      } catch (e) 
      {
        print("Error Occured! While Creating user model. Error: ---> $e");
      }
    } 
    else 
    {   final userCollection = FirebaseFirestore.instance.collection("users");
        final snapshot =
          await userCollection.where('email', isEqualTo: gmail).get();
        final doc = snapshot.docs.first; 
        username = doc.data()['username'];
        await TaskService().fetchAndCacheNotesData(username!);
        await TaskService().fetchAndCacheColabRequests(username);
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            username: username!,
          ),
    ));
  }
}