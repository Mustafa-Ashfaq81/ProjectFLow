// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unnecessary_const

import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/models/taskmodel.dart';
import '../utils/cache_util.dart';

const int daysInWeek = 5;
const double hourHeight = 100;
const double hourWidth = 40;
DateTime _startDate = DateTime.now();
DateTime _endDate = DateTime.now().add(Duration(days: 5));

class CalendarPage extends StatefulWidget 
{
  final String username;
  const CalendarPage({Key? key, required this.username}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}



String _getTaskColor(String taskName) 
{
  final colors = [
    const Color(0xFFF09999),
    const Color(0xFF91BFEA),
    const Color(0xFFAD8484),
    const Color.fromARGB(255, 128, 180, 154),
    const Color.fromARGB(255, 205, 171, 120),
    const Color(0xFF0CBFB4),
    const Color(0xFFF1AB69),
  ];

  final hash = taskName.hashCode;
  final index = hash.abs() % colors.length;
  final color = colors[index];

  return color.value.toRadixString(16).padLeft(8, '0');
}

class CalendarPageState extends State<CalendarPage> 
{
  late final String username;
  final int idx = 3;
  List<Map<String, dynamic>> deadlines = [];

  @override
  void initState() 
  {
    super.initState();
    username = widget.username;
  }




  Future<void> atload() async 
  {
    List<Map<String, dynamic>>? cachedDeadlines =
        CacheUtil.getData('deadlines_$username');
    if (cachedDeadlines != null) 
    {
      deadlines = cachedDeadlines;
    } 
    else 
    {
      deadlines = await getdeadlines(username);
      CacheUtil.cacheData('deadlines_$username', deadlines);
    }
      deadlines = filterUpcomingTasks(deadlines, _startDate, _endDate);
      print("filtered deadlines $deadlines");
      
      

  }
//  upcomingTasks

  List<Map<String, dynamic>> filterUpcomingTasks(
      List<Map<String, dynamic>> tasks, DateTime startDate, DateTime endDate) {
    List<Map<String, dynamic>> upcomingTasks = tasks.where((task) {
      final dueDate = DateTime.parse(task['duedate'] as String);
      return dueDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          dueDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();

    for(int i=0; i<upcomingTasks.length; i++)
    {
      var task = upcomingTasks[i];
      task['duration'] = calculateDuration(task["start_time"], task["end_time"]).toString();
      var starthr =  int.parse(task["start_time"].split(':')[0]);
      if(task['start_time'].contains('PM')) { starthr += 12; }      //24 hr clock
      task['startHour'] = starthr.toString();
      task['name'] = task['heading'];
      //calculating the day of task (the respective column number as to be shown on calendar) ... days 1->5
      var diff = (DateTime.parse(task['duedate']).weekday - DateTime.now().weekday).abs();
      if (diff > 4) { task['day'] = (8 - diff).toString(); }
      else          { task['day'] = (diff + 1).toString(); } 
    }
    
    return upcomingTasks;
 }

 void _selectDateRange() async {
    final DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (selectedRange != null) {
      setState(() {
        _startDate = selectedRange.start;
        _endDate = selectedRange.end;
      });
      await atload();
    }
  }

 int calculateDuration(String startTime, String endTime) 
 {
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
  if (totalMinutes < 0) 
  {
    totalMinutes += 24 * 60; // Add 24 hours (1440 minutes) to account for rollover
  }
  double hours = totalMinutes / 60.0;
  return hours.ceil();
}


  @override
  Widget build(BuildContext context) 
  {
    return FutureBuilder(
        future: atload(),
        builder: (context, snapshot) 
        {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show loading page while fetching data
          } 
          else if (snapshot.hasError) 
          {
            return Text('Error: ${snapshot.error}');
          } 
          else 
          {
            return Scaffold(
                key: Key("calendar-page"),
              appBar: AppBar(
                title: const Center(child: const Text('Calendar')),
                backgroundColor: const Color(0xFFFFE6C9),
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDateRow(),
                    deadlines.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 40.0),
                            child: Row(
                              children: [
                                Expanded(
                                  // Allow the text to expand horizontally
                                  child: Text(
                                    "Your next 5 days are free of tasks and subtasks. This opens up a window for creativity, relaxation, or catching up on things you've been putting off.",
                                    textAlign: TextAlign
                                        .center, // Center align the text
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Stack(
                            children: [
                              _buildTimeGrid(),
                              ..._buildTasks(context),
                            ],
                          ),
                  ],
                ),
              ),
              bottomNavigationBar: Footer(index: idx, username: username),
              floatingActionButton: FloatingActionButton(
            onPressed: _selectDateRange,
            child: Icon(Icons.date_range),
              )
            );
          }
        });
  }

  Widget _buildDateRow() 
  {
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

  Widget _buildTimeGrid() 
  {
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

  List<Widget> _buildTasks(BuildContext context) 
  {
    final List<Map<String, dynamic>> tasks = deadlines;

    return tasks.map((task) 
    {
      task['color'] =
          _getTaskColor(task['name']); // Assign color based on task name
      return _buildTaskContainer(task, context);
    }).toList();
  }

  Widget _buildTaskContainer(Map<String, dynamic> task, BuildContext context)
  {
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  String _getDayOfWeek(int index) 
  {
      final adjustedWeekDay =
        (_startDate.add(Duration(days: index)).weekday) % 7; 

    switch (adjustedWeekDay) 
    {
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
    final day = _startDate.add(Duration(days: index));
    return day.day.toString();
  }
}
