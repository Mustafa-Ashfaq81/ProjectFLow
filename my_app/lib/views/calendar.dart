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

const Map<String, Color> taskColors = {
  'Gym': Color(0xFFF09999),
  'Cricket': Color(0xFF91BFEA),
  'Football': Color(0xFFAD8484),
  'Project Meeting': Color.fromARGB(255, 128, 180, 154),
  'Figma Design': Color.fromARGB(255, 205, 171, 120),
  'Notes': Color(0xFF0CBFB4),
  'App Making': Color(0xFFF1AB69),
};

Color _getRandomColor() {
  List<Color> colors = [
    const Color(0xFFF09999),
    const Color(0xFF91BFEA),
    const Color(0xFFAD8484),
    const Color.fromARGB(255, 128, 180, 154),
    const Color.fromARGB(255, 205, 171, 120),
    const Color(0xFF0CBFB4),
    const Color(0xFFF1AB69),
  ];

  return colors[Random().nextInt(colors.length)];
}


class CalendarPageState extends State<CalendarPage> {
  late final String username;
  final int idx = 3;
  List<Map<String,String>> deadlines = [];

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  Future<void> atload() async {
    deadlines = await getdeadlines(username);
    // print("deadlines ... $deadlines");
  }

  @override
  Widget build(BuildContext context) {
     return FutureBuilder(
        future: atload(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),); // Show loading page while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
              return Scaffold(
              appBar: AppBar(
                title: Center(child: const Text('Calendar')),
                backgroundColor: const Color(0xFFFFE6C9),
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDateRow(),
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
      }
    );
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
  final List<Map<String, dynamic>> tasks = [
    {'name': 'Gym', 'startHour': 9, 'duration': 1, 'day': 1},
    {'name': 'Cricket', 'startHour': 10, 'duration': 2, 'day': 2},
    {'name': 'Football', 'startHour': 11, 'duration': 2, 'day': 1},
    {'name': 'Project Meeting', 'startHour': 9, 'duration': 3, 'day': 3},
    {'name': 'Figma Design', 'startHour': 12, 'duration': 2, 'day': 4},
    {'name': 'Notes', 'startHour': 13, 'duration': 1, 'day': 5},
    {'name': 'App Making', 'startHour': 14, 'duration': 1, 'day': 5},
    {'name': 'AP exam', 'startHour': 14, 'duration': 4, 'day': 1},
  ];

  return tasks.map((task) {
    task['color'] = _getRandomColor(); // Assign random color
    return _buildTaskContainer(task, context);
  }).toList();
}
  Widget _buildTaskContainer(Map<String, dynamic> task, BuildContext context) {
  final taskStartIndex =
      task['startHour'] - 9; // Normalize start hour to 0-based index
  final screenWidth = MediaQuery.of(context).size.width;
  final taskWidth =
      (screenWidth - hourWidth) / daysInWeek; // Width of each task
  final taskHeight = hourHeight * task['duration'];
  final taskDay = task['day'] - 1; // Convert to 0-based index

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
        color: task['color'], // Use color directly from task map
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
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final day = firstDayOfWeek.add(Duration(days: index));

    switch (day.weekday) {
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


  String _getDayNumber(int index) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final day = firstDayOfWeek.add(Duration(days: index));
    return day.day.toString();
  }
  
}
