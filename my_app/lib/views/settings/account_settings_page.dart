// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure you have this import
import 'package:my_app/components/footer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/common/toast.dart';

class AccountSettingsPage extends StatefulWidget {
  final String username;
  final bool isGoogleSignedIn;

  const AccountSettingsPage({
    Key? key,
    required this.username,
    this.isGoogleSignedIn = false,
  }) : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  // late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  var isGmailLogin = false;
  // var nameChanged = false;
  var passwordChanged = false;
  var emailChanged = false;
  var username = "";
  final initialEmail = 'email@example.com';

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final providerData = user.providerData;
      for (var info in providerData) {
        if (info.providerId == 'google.com') { isGmailLogin = true; }
      }
    }
    print("isGmailLogin ... $isGmailLogin");
    super.initState();
    _nameController = TextEditingController(
        text: widget.username); // Assuming username is the name
    _emailController = TextEditingController(text: 'email@example.com');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFFFE6C9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Profile Information'),
            _buildTextField(
              controller: _nameController,
              labelText: 'Name',
              icon: Icons.person,
            ),
            _buildTextField(
              controller: _emailController,
              labelText: 'Email',
              icon: Icons.email,
            ),
            _buildSectionTitle('Change Password'),
            _buildTextField(
              controller: _passwordController,
              labelText: 'New Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            _buildTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              icon: Icons.lock_outline,
              obscureText: true,
            ),
            const SizedBox(height: 24),
            !isGmailLogin ? Center(
              child: ElevatedButton(
                onPressed: () async {
                    if(checkifvalidinput()){
                      print("changed fields ... (email,pass) : $emailChanged, $passwordChanged");
                      await updateUserInfo(username,_emailController.text,_passwordController.text,emailChanged,passwordChanged);
                      
                    }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle( color: Colors.white, fontSize: 18),
                ),
              ),
            ) : Text(""),
          ],
        ),
      ),
      bottomNavigationBar: Footer(index: 0, username: username),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.black) : null,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
    );
  }

  bool checkifvalidinput(){
    if (_passwordController.text != "" || _confirmPasswordController.text != "" ) { passwordChanged = true; }
    if (_emailController.text != initialEmail)                                    { emailChanged = true; }
    if(passwordChanged == false && emailChanged == false){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Can only update profile info if something has changed'),duration: Duration(seconds: 2),));
      return false;
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',);
    final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*]).{8,}$',);

    if (!emailRegex.hasMatch(_emailController.text)) {
      showerrormsg(message: "Please enter a valid email address");
      return false;
    }

    if(passwordChanged){
      if (!passwordRegex.hasMatch(_passwordController.text)) {
        showerrormsg(message:"Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.");
        return false;
      }

      if (_confirmPasswordController.text != _passwordController.text) {
        showerrormsg(message: "Passwords do not match \u{1F6A8}");
        return false;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Form is valid and processing data'),duration: Duration(seconds: 2),));
    return true;
  }
}
