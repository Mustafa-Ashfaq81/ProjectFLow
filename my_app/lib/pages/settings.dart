import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final int idx = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Center(
        child: Text(' add Settings of -change username         .'),
      ),
      bottomNavigationBar: Footer(context,idx),
    );
  }
}
