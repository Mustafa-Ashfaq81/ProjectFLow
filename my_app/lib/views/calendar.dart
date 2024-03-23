import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

const int daysInWeek = 5; // Number of days to display

class CalendarPage extends StatefulWidget {
  final String username;
  const CalendarPage({Key? key, required this.username}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  late final String username;
  final int idx = 3;

  // Constructor to initialize the state
  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDateRow(), // Add date row
            for (int index = 0; index < 24; index++)
              _buildHourRow(index),
          ],
        ),
      ),
      bottomNavigationBar: Footer(index: idx, username: username),
    );
  }

  Widget _buildDateRow() {
    return Container(
      color: Colors.black,
      height: 30, // Adjust height as needed
      child: Row(
        children: [
          SizedBox(width: 50), // Placeholder for hour column
          for (int i = 0; i < daysInWeek; i++)
            Expanded(
              child: Center(
                child: Text(
                  _getDayOfWeek(i + 1), // Add day of the week
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHourRow(int hour) {
    // Placeholder for tasks for demonstration
    List<Map<String, dynamic>> tasksForHour = [
      {'name': 'Task $hour-1', 'startHour': hour, 'duration': 1}, // Example task starting at this hour and lasting for 1 hour
      {'name': 'Task $hour-2', 'startHour': hour + 1, 'duration': 2}, // Example task starting at the next hour and lasting for 2 hours
      {'name': 'Task $hour-3', 'startHour': hour + 3, 'duration': 3}, // Example task starting after 3 hours and lasting for 3 hours
    ];

    return Column(
      children: [
        // Rounded corners start
        ClipRRect(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.5), // Separator color
                  width: 5, // Separator height
                ),
              ),
            ),
            child: SizedBox(
              height: 60, // Reduced height for better visibility
              child: Row(
                children: [
                  SizedBox(
                    width: 50, // Width for hour column
                    child: Center(
                      child: Text(
                        '$hour:00',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        for (final task in tasksForHour)
                          _buildTaskContainer(task, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Rounded corners end
      ],
    );
  }

  Widget _buildTaskContainer(Map<String, dynamic> task, BuildContext context) {
    final taskStartIndex = task['startHour'];
    final taskEndIndex = taskStartIndex + task['duration'];
    final taskWidth = (MediaQuery.of(context).size.width / daysInWeek - 10) * 0.8; // Adjust width based on column width
    final hourHeight = 60; // Height of one hour row

    // Calculate height of the task based on its duration
    final taskHeight = hourHeight * task['duration'];

    return Container(
      height: taskHeight.toDouble(), // Set the height based on task duration
      width: taskWidth, // Set the width of the task container
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          task['name'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getDayOfWeek(int index) {
    DateTime now = DateTime.now();
    DateTime day = DateTime(now.year, now.month, now.day + index);
    return '${day.day} ${_getWeekday(day.weekday)}';
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}