import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final int idx = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Page'),
      ),
      body: Center(
        child: Text('This is where you add tasks.'),
      ),
      bottomNavigationBar: Footer(context,idx),
    );
  }
}
