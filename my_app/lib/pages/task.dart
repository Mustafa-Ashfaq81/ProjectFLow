import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class TaskPage extends StatefulWidget {
  final String username;
  TaskPage({required this.username});
  @override
  _TaskPageState createState() => _TaskPageState(username: username);
}

class _TaskPageState extends State<TaskPage> {
  String username;
  final int idx = 2;
  _TaskPageState({required this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Page'),
      ),
      body: Center(
        child: Text('This is where you add tasks.'),
      ),
      bottomNavigationBar: Footer(context, idx, username),
    );
  }
}
