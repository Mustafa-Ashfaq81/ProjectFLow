import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class NotificationsSettingsPage extends StatefulWidget {
  final String username;

  const NotificationsSettingsPage({Key? key, required this.username})
      : super(key: key);

  @override
  _NotificationsSettingsPageState createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _taskNotificationsEnabled = true;
  bool _messageNotificationsEnabled = true;
  bool _groupNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Notifications Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Task Notifications'),
            _buildNotificationSwitch(
              value: _taskNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _taskNotificationsEnabled = value;
                });
              },
              label: 'Enable task notifications',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Message Notifications'),
            _buildNotificationSwitch(
              value: _messageNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _messageNotificationsEnabled = value;
                });
              },
              label: 'Enable message notifications',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Group Notifications'),
            _buildNotificationSwitch(
              value: _groupNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _groupNotificationsEnabled = value;
                });
              },
              label: 'Enable group notifications',
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
                  'Save Settings',
                  style: TextStyle(fontSize: 18),
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

  Widget _buildNotificationSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    required String label,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      activeColor: Colors.deepPurple,
      contentPadding: EdgeInsets.zero,
    );
  }
}
