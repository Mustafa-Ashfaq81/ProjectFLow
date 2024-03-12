import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String username;
  const SettingsPage({super.key, required this.username});
  @override
  _SettingsPageState createState() => _SettingsPageState(username: username);
}

class _SettingsPageState extends State<SettingsPage> {
  String username;
  _SettingsPageState({required this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: const Center(
        child: Text('This is where you add Settingss.'),
      ),
    );
  }
}
