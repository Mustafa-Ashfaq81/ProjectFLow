import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/views/settings/account_settings_page.dart';
import 'package:my_app/views/settings/notifications_settings_page.dart';
import 'package:my_app/views/settings/help_page.dart';
import 'package:my_app/auth/controllers/authservice.dart';
import 'package:my_app/common/logoutdialog.dart';
import 'package:my_app/views/settings/about_us_page.dart';

class SettingsPage extends StatefulWidget {
  final String username;

  const SettingsPage({Key? key, required this.username}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _logoutClicked = false;
  final FirebaseAuthService _auth = FirebaseAuthService();

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
                  // Navigate to account settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AccountSettingsPage(username: widget.username),
                    ),
                  );
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
                  // Navigate to account settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AccountSettingsPage(username: widget.username),
                    ),
                  );
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
                  // Navigate to notifications settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationsSettingsPage(username: widget.username),
                    ),
                  );
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
                  setState(() async{
                    _logoutClicked = true;
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      try{
                        await _auth.logout();
                      } catch(e){
                        print("not a normal account $e");
                        await _auth.signOutFromGoogle();
                      }
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/", (_) => false);
                      }
                  });
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
                  // Navigate to help page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpPage(username: widget.username),
                    ),
                  );
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
                  // Navigate to about us page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AboutUsPage(username: widget.username),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _logoutClicked
          ? Center(
              child: BottomLogoutPopup(
                onClose: () {
                  setState(() {
                    _logoutClicked = false;
                  });
                },
              ),
            )
          : Footer(index: 0, username: widget.username),
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

class BottomLogoutPopup extends StatelessWidget {
  final VoidCallback onClose;

  const BottomLogoutPopup({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 238, 215, 174),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 425,
        height: 300,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 102,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B8D5E),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 56,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Logout Success',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'You have been logged out',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Container(
                  width: 182,
                  height: 56,
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
