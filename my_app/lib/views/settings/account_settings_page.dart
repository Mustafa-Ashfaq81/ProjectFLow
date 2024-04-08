import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class AccountSettingsPage extends StatefulWidget {
  final String username;

  const AccountSettingsPage({Key? key, required this.username})
      : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: widget.username); // Assuming username is the name
    _emailController = TextEditingController(text: 'email@example.com');
    _passwordController = TextEditingController();
    _confirmPasswordController =
        TextEditingController(); // Initialize the controller
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Updated for a more modern look
        title: const Text('Account Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[900], // Darker shade for better contrast
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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement saving logic here
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(index: 0, username: widget.username),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
    );
  }
}
