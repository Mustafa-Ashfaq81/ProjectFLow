import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class SettingsPage extends StatefulWidget {
  final String username;

  const SettingsPage({Key? key, required this.username}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  print("Clicked");
                },
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/user_image.png'),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'User Bio',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildClickableSettingsItem(
                icon: Icons.account_circle,
                title: 'Account',
                subtitle: 'Privacy, security, change email or password',
                titleSize: 16,
                subtitleSize: 12,
                onTap: () {
                  print("Clicked");
                },
              ),
              const SizedBox(height: 20),
              _buildClickableSettingsItem(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Message, group & call tones',
                titleSize: 16,
                subtitleSize: 12,
                onTap: () {
                  print("Clicked");
                },
              ),
              const SizedBox(height: 20),
              _buildClickableSettingsItem(
                icon: Icons.logout,
                title: 'Log Out',
                subtitle: 'Securely End Your Session',
                titleSize: 16,
                subtitleSize: 12,
                onTap: () {
                  print("Clicked");
                },
              ),
              const SizedBox(height: 20),
              _buildClickableSettingsItem(
                icon: Icons.help,
                title: 'Help',
                subtitle: 'Help Center, contact us, privacy policy',
                titleSize: 16,
                subtitleSize: 12,
                onTap: () {
                  print("Clicked");
                },
              ),
              const SizedBox(height: 20),
              _buildClickableSettingsItem(
                icon: Icons.info,
                title: 'About Us',
                subtitle: 'Mission statement and other details',
                titleSize: 16,
                subtitleSize: 12,
                onTap: () {
                  print("Clicked");
                },
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Footer(index: idx, username: username), // Add your footer widget here
    );
  }

  Widget _buildClickableSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required double titleSize,
    required double subtitleSize,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(width: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: titleSize, color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(fontSize: subtitleSize, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
