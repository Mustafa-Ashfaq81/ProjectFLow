import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/auth/pages/login.dart';
import 'package:my_app/auth/services/authservice.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/models/usermodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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
        title: Center(child: Text('Register')),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(height: 5),
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
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome! Glad to \n see you!',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 5),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    controller: _usernameController),
                SizedBox(height: 20),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    controller: _emailController),
                SizedBox(height: 20),
                TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    controller: _passwordController),
                SizedBox(height: 20),
                TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    controller: _confirmPasswordController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF1E232C), // Button background color
                    foregroundColor:
                        Colors.white, // Button text color set to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    minimumSize: Size(200, 50),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: isSigningUp
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text('Register',
                              style: TextStyle(
                                fontSize: 18, // Adjust the font size here
                                fontWeight:
                                    FontWeight.bold, // Make the text bold
                              ))),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Login now',
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

  void _register() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String pass = _confirmPasswordController.text;
    String name = _usernameController.text;

    if (password != pass) {
      //showmsg(message : "passwords not matching");
      print("passwords not matching..");
    } else {
      setState(() {
        isSigningUp = true;
      });
      User? user = await _auth.registeracc(email, password);

      if (user != null) {
        print("User is successfully created");
        createUser(UserModel(username: name, email: email, tasks: []));
        // Navigator.pushNamed(context, "/home");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                email: email,
              ),
            ));
      } else {
        print(" some error occurred ... has been TOASTED");
      }
      setState(() {
        isSigningUp = false;
      });
    }
  }
}
