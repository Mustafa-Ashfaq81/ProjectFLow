import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

const int daysInWeek = 5;
const double hourHeight = 100;
const double hourWidth = 40
;

class CalendarPage extends StatefulWidget {
  final String username;
  const CalendarPage({Key? key, required this.username}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

const Map<String, Color> taskColors = {
  'Gym': Colors.orange,
  'Cricket': Colors.green,
  'Football': Colors.brown,
  'Project Meeting': Color(0xFFFED36A),
  'Figma Design': Color(0xFFFED36A),
  'Notes': Colors.cyan,
  'App Making': Color(0xFFF1AB69),
};

class CalendarPageState extends State<CalendarPage> {
  late final String username;
  final int idx = 3;

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        leading: const BackButton(), // Added back button for navigation
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Implement settings navigation if required
            },
          ),
        ],
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

  Widget _buildDateRow() {
    return Container(
      color: Colors.black,
      height: 100,
      child: Row(
        children: [
          SizedBox(width: hourWidth),
          for (int i = 0; i < daysInWeek; i++)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayNumber(i),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _getDayOfWeek(i),
                    style: TextStyle(
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
    // Example task data
    final List<Map<String, dynamic>> tasks = [
      {'name': 'Gym', 'startHour': 9, 'duration': 1, 'day': 1, 'color': 'Gym'},
      {
        'name': 'Cricket',
        'startHour': 10,
        'duration': 2,
        'day': 2,
        'color': 'Cricket'
      },
      {
        'name': 'Football',
        'startHour': 11,
        'duration': 2,
        'day': 1,
        'color': 'Football'
      },
      {
        'name': 'Project Meeting',
        'startHour': 9,
        'duration': 3,
        'day': 3,
        'color': 'Project Meeting'
      },
      {
        'name': 'Figma Design',
        'startHour': 12,
        'duration': 2,
        'day': 4,
        'color': 'Figma Design'
      },
      {
        'name': 'Notes',
        'startHour': 13,
        'duration': 1,
        'day': 5,
        'color': 'Notes'
      },
      {
        'name': 'App Making',
        'startHour': 14,
        'duration': 1,
        'day': 5,
        'color': 'App Making'
      },
    ];

    return tasks.map((task) => _buildTaskContainer(task, context)).toList();
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
          color: taskColors[task['color']] ?? Colors.blue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 3),
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
