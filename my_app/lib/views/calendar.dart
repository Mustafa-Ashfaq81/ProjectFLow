import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/models/taskmodel.dart';

const int daysInWeek = 5;
const double hourHeight = 100;
const double hourWidth = 40;

class CalendarPage extends StatefulWidget {
  final String username;
  const CalendarPage({Key? key, required this.username}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}


String _getRandomColor() {
  List<Color> colors = [
    const Color(0xFFF09999),
    const Color(0xFF91BFEA),
    const Color(0xFFAD8484),
    const Color.fromARGB(255, 128, 180, 154),
    const Color.fromARGB(255, 205, 171, 120),
    const Color(0xFF0CBFB4),
    const Color(0xFFF1AB69),
  ];

  List<String> stringColors = colors.map((color) => color.value.toRadixString(16).padLeft(8, '0')).toList();

  return stringColors[Random().nextInt(colors.length)];
}

class CalendarPageState extends State<CalendarPage> {
  late final String username;
  final int idx = 3;
  List<Map<String, dynamic>> deadlines = [];

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  Future<void> atload() async {
    deadlines = await getdeadlines(username);
    //below array was for testing if it filters correctly or not
    // deadlines = [{"heading": "task10", "duedate": "2024-03-27", "start_time": "11:00 PM", "end_time": "6:00 PM"},
    // {"heading": "task10", "duedate": "2024-03-26", "start_time": "11:00 PM", "end_time": "6:00 PM"},
    // {"heading": "task10", "duedate": "2024-03-25", "start_time": "11:00 PM", "end_time": "6:00 PM"},
    // {"heading": "task10", "duedate": "2024-03-28", "start_time": "11:00 PM", "end_time": "6:00 PM"},
    // {"heading": "task10", "duedate": "2024-03-29", "start_time": "11:00 PM", "end_time": "6:00 PM"},
    // {"heading": "task10", "duedate": "2024-03-30", "start_time": "11:00 PM", "end_time": "6:00 PM"},
    // {"heading": "task10", "duedate": "2024-04-01", "start_time": "11:00 PM", "end_time": "6:00 PM"},
    // {"heading": "task10", "duedate": "2024-04-02", "start_time": "11:00 PM", "end_time": "6:00 PM"}];
    deadlines = filterUpcomingTasks(deadlines);
    print("filtered deadlines $deadlines");
  }

  List<Map<String, dynamic>> filterUpcomingTasks(List<Map<String, dynamic>> tasks) { //only gets tasks within next 5 days
    final today = DateTime.now();
    const lookAheadDays = 5;
    List<Map<String, dynamic>> upcomingTasks = tasks.where((task) {
      final dueDate = DateTime.parse(task['duedate'] as String);
      return dueDate.isAfter(today.subtract(Duration(days: 1))) &&
          dueDate.isBefore(today.add(Duration(days: lookAheadDays)));
    }).toList();

    for(int i=0; i<upcomingTasks.length; i++){
      var task = upcomingTasks[i];
      task['duration'] = calculateDuration(task["start_time"], task["end_time"]).toString();
      // print("durationnnnn");
      var starthr =  int.parse(task["start_time"].split(':')[0]);
      if(task['start_time'].contains('PM')) { starthr += 12; }      //24 hr clock
      task['startHour'] = starthr.toString();
      task['day'] = (DateTime.parse(task['duedate']).weekday - DateTime.now().weekday + 1).toString();
      task['name'] = task['heading'];
    }
    
    return upcomingTasks;
 }

 int calculateDuration(String startTime, String endTime) {
  final startHour = int.parse(startTime.split(':')[0]);
  final startMinute = int.parse(startTime.split(':')[1].split(' ')[0]);
  final isStartPM = startTime.contains('PM');

  final endHour = int.parse(endTime.split(':')[0]);
  final endMinute = int.parse(endTime.split(':')[1].split(' ')[0]);
  final isEndPM = endTime.contains('PM');

  // Adjust for 12-hour clock and handle PM cases
  final adjustedStartHour = isStartPM ? (startHour == 12 ? 12 : startHour + 12) : startHour;
  final adjustedEndHour = isEndPM ? (endHour == 12 ? 12 : endHour + 12) : endHour;

  // Calculate total minutes considering possible day rollover
  int totalMinutes = (adjustedEndHour * 60 + endMinute) - (adjustedStartHour * 60 + startMinute);
  if (totalMinutes < 0) {
    totalMinutes += 24 * 60; // Add 24 hours (1440 minutes) to account for rollover
  }
  double hours = totalMinutes / 60.0;
  return hours.ceil();
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: atload(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show loading page while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Center(child: const Text('Calendar')),
                backgroundColor: const Color(0xFFFFE6C9),
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDateRow(),
                    deadlines.isEmpty ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                    child: Row(
                      children: [
                        Center(child: Text("No tasks or subtasks due for the next 5 days"),)
                      ],
                    )):
                    Stack(
                      children: [
                        _buildTimeGrid(),
                        ..._buildTasks(context),
                      ],
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Footer(index: idx, username: username),
              // floatingActionButton: FloatingActionButton(
              // onPressed: () {
              // Implement task adding functionality
              // },
              // child: const Icon(Icons.add),
              // backgroundColor: Colors.black,
              // ),
            );
          }
        });
  }

  Widget _buildDateRow() {
    return Container(
      color: Colors.black,
      height: 100,
      child: Row(
        children: [
          const SizedBox(width: hourWidth),
          for (int i = 0; i < daysInWeek; i++)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayNumber(i),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getDayOfWeek(i),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeGrid() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: hourWidth,
            child: Column(
              children: List.generate(
                24,
                (index) => Container(
                  height: hourHeight,
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${index + 1}:00",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: List.generate(
                24,
                (index) => Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  height: hourHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTasks(BuildContext context) {
    // final List<Map<String, dynamic>> tasks = [
    //   {'name': 'Gym', 'startHour': "9", 'duration': "1", 'day': "1"},
    //   {'name': 'Cricket', 'startHour': "10", 'duration': "2", 'day': "2"},
    //   {'name': 'Football', 'startHour': "11", 'duration': "2", 'day': "1"},
    //   {'name': 'Project Meeting', 'startHour': "9", 'duration': "3", 'day': "3"},
    //   {'name': 'Figma Design', 'startHour': "12", 'duration': "2", 'day': "4"},
    //   {'name': 'Notes', 'startHour': "13", 'duration': "1", 'day': "5"},
    //   {'name': 'App Making', 'startHour': "14", 'duration': "1", 'day': "5"},
    //   {'name': 'AP exam', 'startHour': "14", 'duration': "4", 'day': "1"},
    // ];
    final List<Map<String, dynamic>> tasks = deadlines;

    return tasks.map((task) {
      task['color'] = _getRandomColor(); // Assign random color
      return _buildTaskContainer(task, context);
    }).toList();
  }

  Widget _buildTaskContainer(Map<String, dynamic> task, BuildContext context) {
    final taskStartIndex =
        int.parse(task['startHour']); // Normalize start hour to 0-based index // -9 part removed
    final screenWidth = MediaQuery.of(context).size.width;
    final taskWidth =
        (screenWidth - hourWidth) / daysInWeek; // Width of each task
    final taskHeight = hourHeight * int.parse(task['duration']);
    final taskDay = int.parse(task['day']) - 1; // Convert to 0-based index

    // Increase the width of each task container by reducing the right margin
    final taskContainerWidth = taskWidth - 4; // Smaller right margin

    return Positioned(
      top: taskStartIndex * hourHeight,
      left: taskDay * taskWidth + hourWidth,
      child: Container(
        height: taskHeight,
        width: taskContainerWidth,
        margin: const EdgeInsets.only(
            left: 5, top: 5, bottom: 5), // Adjusted margin
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(int.parse(task['color'], radix: 16)), // Use color directly from task map
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            task['name'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  String _getDayOfWeek(int index) {
    final now = DateTime.now();
    final todayWeekday = now.weekday; 
    final adjustedWeekDay = (index + todayWeekday) % 7;

    switch (adjustedWeekDay) {
      case 0:
        return 'Sun';
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
      default:
        return 'ERROR';
    }
  }

  String _getDayNumber(int index) {
    final now = DateTime.now();
    final day = now.add(Duration(days: index));
    return day.day.toString();
  }
}
