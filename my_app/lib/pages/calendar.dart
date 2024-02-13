import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final int idx = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Page'),
      ),
      body: Center(
        child: Text('This is where you add deadlines.'),
      ),
      bottomNavigationBar: Footer(context,idx),
    );
  }
}
