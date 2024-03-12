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
  final TextEditingController _confirmPasswordController = TextEditingController();

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
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 5),
            const Row(
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
            const SizedBox(height: 5),

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
                    controller: _usernameController),
                const SizedBox(height: 20),
                TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    controller: _emailController),
                const SizedBox(height: 20),
                TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    controller: _passwordController),
                const SizedBox(height: 20),
                TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    controller: _confirmPasswordController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1E232C), // Button background color
                    foregroundColor:
                        Colors.white, // Button text color set to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    minimumSize: const Size(200, 50),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: isSigningUp
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Register',
                              style: TextStyle(
                                fontSize: 18, // Adjust the font size here
                                fontWeight:
                                    FontWeight.bold, // Make the text bold
                              ))),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
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
    );
  }

  void _register() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String pass = _confirmPasswordController.text;
    String name = _usernameController.text;

    if (password != pass) {
      showerrormsg(message: "passwords not matching");
    } else {
      setState(() {
        isSigningUp = true;
      });
      var allusernames = await getallUsers();
      if (allusernames.contains(name) == true) {
        showerrormsg(message: "username already taken");
      } else {
        User? user = await _auth.registeracc(email, password);

        if (user != null) {
          print("User is successfully created");
          List<Map<String, dynamic>>? mappedtasks = maptasks(get_random_task());
          try {
            createUser(
                UserModel(username: name, email: email, tasks: mappedtasks));
            print("user model created");
          } catch (e) {
            print("got-some-err ---> $e");
          }
          // Navigator.pushNamed(context, "/home");
          Navigator.push(
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
