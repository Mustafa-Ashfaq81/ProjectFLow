// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/auth/views/register.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/models/taskmodel.dart';
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
      appBar:AppBar(
        title: Center(
          child: Text(
            'Login',
            textAlign: TextAlign.center, // Align text within the Text widget
            style: TextStyle(
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
        automaticallyImplyLeading: false, // Disable automatic back button
        backgroundColor: Colors.black, // Set background color to black
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
            // const SizedBox(height: 20),
                        const SizedBox(height: 5),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[400],thickness: 0.5,)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('Or continue with',
                    style: TextStyle(color: Colors.grey[700]) ,
                  ) ,
                ),
                Expanded(child: Divider(color: Colors.grey[400],thickness: 0.5,)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap:  _loginGmail,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius : BorderRadius.circular(16),
                      color: Colors.grey[200]
                    ),
                    child: Image.asset("pictures/google-icon.png", height:40)
                  ),
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

    if (useracc != null) 
    {
      String user = "";
      print("User is successfully logging in");
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((QuerySnapshot querySnapshot) 
          {
        for (var doc in querySnapshot.docs) 
        {
          //only one doc with that username
          user = doc['username'];
        }
      });
        


        Navigator.pushReplacement(

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

    void _loginGmail() async  { 
    UserCredential? usercred =  await _auth.signInWithGoogle(); 
    print(usercred);
    print("--------");
    if (usercred != null){
      var username = usercred.user!.displayName;
      final gmail = usercred.user!.email;

      //check if user is not created, create that user in db else just login 
      List<String> allemails = await getallEmails();
      if (allemails.contains(gmail) == false) { 
        var allusernames = await getallUsers();
        if (allusernames.contains(username) == true) {
          //append some numbers to username such that it stays unique
          int suffix = 1;
          String newUsername = username!;
          while (allusernames.contains(newUsername)) {
            newUsername = '$username!_${suffix++}';
          }
          username = newUsername;
        } 
        print("User is successfully created");
        List<Map<String, dynamic>>? mappedtasks = maptasks(get_random_task());
        try {
          createUser(
              UserModel(username: username, email: gmail, tasks: mappedtasks));
        } catch (e) {
          print("got-some-err-creating-user-model ---> $e");
        }
      }
          Navigator.pushReplacement(

          context,
          MaterialPageRoute(
            builder: (context) => HomePage( username: username!,),
      ));
    }
  }

}