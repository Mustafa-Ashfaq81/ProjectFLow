import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class CalendarPage extends StatefulWidget {
  final String username;
  const CalendarPage({super.key, required this.username});
  @override
  _CalendarPageState createState() => _CalendarPageState(username: username);
}

class _CalendarPageState extends State<CalendarPage> {
  String username;
  final int idx = 3;
  _CalendarPageState({required this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Page',
        style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('This is where you add deadlines.'),
      ),
      bottomNavigationBar: Footer(context, idx, username),
    );
  }
}
