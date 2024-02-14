import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class  SettingsPage  extends StatefulWidget {
  final String username;
  SettingsPage({required this.username});
  @override
  _SettingsPageState createState() => _SettingsPageState(username: username);
}

class _SettingsPageState extends State<SettingsPage> {
  String username;
  final int idx = 4;
  _SettingsPageState({required this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Center(
        child: Text('This is where you add Settingss.'),
      ),
      bottomNavigationBar: Footer(context, idx, username),
    );
  }
}
