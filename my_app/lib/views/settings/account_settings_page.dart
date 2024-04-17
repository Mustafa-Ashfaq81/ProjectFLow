// ignore_for_file: prefer_const_constructors, deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/utils/inappmsgs_util.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountSettingsPage extends StatefulWidget {
  final String username;

   // Constructor for AccountSettingsPage
  const AccountSettingsPage({Key? key, required this.username})
      : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late TextEditingController _emailController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  var isGmailLogin = false;
  var passwordChanged = false;
  var emailChanged = false;
  var username = "";

  @override
  void initState() {
    super.initState();
    username = widget.username;
    _emailController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    checkGoogleSignIn();
    getUserEmail();

  }

  
  // Function to check if user is signed in with Google
  Future<void> checkGoogleSignIn() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final providerData = user.providerData;
      for (var info in providerData) {
        if (info.providerId == 'google.com') {
          setState(() {
            isGmailLogin = true;
          });
          break;
        }
      }
    }
  }


 // Function to get user's email address
  Future<void> getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final email = user.email;
      setState(() {
        _emailController.text = email ?? '';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


 // Function to launch Google Account Settings page
  Future<void> _launchGoogleAccountSettings() async {
    const url = 'https://myaccount.google.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Color(0xFFFFE6C9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Profile Information'),
            !isGmailLogin
                ? _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                  )
                : Container(),
            !isGmailLogin ? _buildSectionTitle('Change Password') : Container(),
            !isGmailLogin
                ? _buildTextField(
                    controller: _oldPasswordController,
                    labelText: 'Old Password',
                    icon: Icons.lock,
                    obscureText: true,
                  )
                : Container(),
            !isGmailLogin
                ? _buildTextField(
                    controller: _passwordController,
                    labelText: 'New Password',
                    icon: Icons.lock,
                    obscureText: true,
                  )
                : Container(),
            !isGmailLogin
                ? _buildTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  )
                : Container(),
            isGmailLogin
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        Text(
                          'You are logged in with your Google account. To change your email, password, or username, please visit your Google account settings.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 50.0),
                        ElevatedButton(
                          onPressed: () {
                            _launchGoogleAccountSettings();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Open Google Account Settings',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 50.0),
                        Image.asset(
                          'pictures/google1.png',
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(height: 24),
            !isGmailLogin
                ? Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (checkifvalidinput()) {
                          await updateUserInfo(
                              username,
                              _emailController.text,
                              _oldPasswordController.text,
                              _passwordController.text,
                              emailChanged,
                              passwordChanged,
                              context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      bottomNavigationBar: Footer(index: 0, username: username),
    );
  }


 // Widget for section titles

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      );


  // Widget for building text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.black) : null,
        labelText: labelText,
        labelStyle: const TextStyle(
            color: Colors.black), // Set label text color to black
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
    );
  }

  // Function to check if input is valid
  bool checkifvalidinput() {
    if (_passwordController.text != "" ||
        _confirmPasswordController.text != "") {
      passwordChanged = true;
    }
    if (_emailController.text != FirebaseAuth.instance.currentUser?.email) {
      emailChanged = true;
    }
    if (passwordChanged == false && emailChanged == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Can only update profile info if something has changed'),
        duration: Duration(seconds: 2),
      ));
      return false;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    final passwordRegex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*]).{8,}$',
    );

    if (!emailRegex.hasMatch(_emailController.text)) {
      // showerrormsg(message: "Please enter a valid email address");
      showCustomError("Please enter a valid email address", context);
      return false;
    }

    if (passwordChanged) {
      if (_oldPasswordController.text.isEmpty) {
        // showerrormsg(message: "Please enter your old password");
        showCustomError("Please enter your old password", context);
        return false;
      }

      if (!passwordRegex.hasMatch(_passwordController.text)) {
        // showerrormsg(
        //     message:
        //         "Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.");
        showCustomError("Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.", context);
        return false;
      }

      if (_confirmPasswordController.text != _passwordController.text) {
        // showerrormsg(message: "Passwords do not match \u{1F6A8}");
         showCustomError("Passwords do not match \u{1F6A8}", context);
        return false;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Form is valid and processing data'),
      duration: Duration(seconds: 2),
    ));
    return true;
  }
}
