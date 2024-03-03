import 'package:flutter/material.dart';
import 'package:my_app/pages/task.dart';
// import 'package:my_app/components/search.dart';
// import 'package:my_app/components/footer.dart';
// import 'package:my_app/models/usermodel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskDetailsPage(username: 'musti'),
    );
  }
}

class TaskDetailsPage extends StatefulWidget {
  final String username;
  const TaskDetailsPage({Key? key, required this.username}) : super(key: key);

  @override
  State<TaskDetailsPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskDetailsPage> {
  final int idx = 2;
  List<Map<String, dynamic>> teamMembers = [];

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFFE6C9),
      title: const Text(
        'Task Details',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            _buildDuedateProjectTeam(),
            const SizedBox(height: 30),
            _buildSectionTitle('Project Details'),
            const SizedBox(height: 10),
            _buildNormalText('This is all what the project is about...'),
            const SizedBox(height: 30),
            _buildProgressIndicatorWithText(),
            const SizedBox(height: 30),
            _buildSectionTitle('All Tasks'),
            const SizedBox(height: 20),
            _buildTaskMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildDuedateProjectTeam() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildIconContainer(icon: Icons.calendar_month),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Due Date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('20th Sept'),
              ],
            ),
            const SizedBox(width: 200),
            _buildIconContainer(icon: Icons.group),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Team',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildTeamMemberAvatars()
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamMemberAvatars() {
    double size = 10; // Adjust size as needed
    double overlap = 2; // Adjust overlap as needed
    double personSize = 15;

    return Stack(
      clipBehavior:
          Clip.none, // Allows avatars to be drawn outside the Stack's bounds
      children: [
        // First avatar (leftmost)
        CircleAvatar(
          radius: size,
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white, size: personSize),
        ),
        // Second avatar
        Positioned(
          left: size - overlap, // Adjust the position for overlap
          child: CircleAvatar(
            radius: size,
            backgroundColor: Colors.green,
            child: Icon(Icons.person, color: Colors.white, size: personSize),
          ),
        ),
        // Third avatar
        Positioned(
          left: 2 * (size - overlap), // Adjust the position for overlap
          child: CircleAvatar(
            radius: size,
            backgroundColor: Colors.red,
            child: Icon(Icons.person, color: Colors.white, size: personSize),
          ),
        ),
        // Add more Positioned CircleAvatar widgets as needed
      ],
    );
  }

  Widget _buildIconContainer({required IconData icon}) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: const Color(0xFFFED36A),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Center(
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  Widget _buildNormalText(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15.0,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProgressIndicatorWithText() {
    // Customizable values
    double progress = 0.6; // 60%
    Color progressColor = Colors.green; // Color of the progress indicator

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Project Progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 200),
        Container(
          width: 20, // Width of the circle
          height: 20, // Height of the circle
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            strokeWidth: 2,
          ),
        ),
        SizedBox(width: 5), // Space after the progress indicator
        Text(
          '${(progress * 100).toInt()}%', // The percentage text
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterButton() {
    return BottomAppBar(
      color: Colors.black, // Set the background color of the footer
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: double.infinity, // Set the height of the button
          width: double
              .infinity, // Set the width of the button to match the width of the screen
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Button background color
              foregroundColor: Colors.black, // Text and icon color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    8), // Adjust the border radius to match your design
              ),
              elevation: 0, // Removes shadow
            ),
            onPressed: () {
              // Navigate to TaskPage when button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TaskPage(username: 'musti',)), // TaskPage is the destination widget
              );
            },
            child: Text(
              'Add Task',
              style: TextStyle(fontSize: 16), // Set your text size here
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildFooterButton(),
    );
  }
}

Widget _buildTaskMenu() {
  // This will be replaced by the new TaskMenu widget
  return TaskMenu();
}

// New TaskMenu widget to handle task state
class TaskMenu extends StatefulWidget {
  @override
  _TaskMenuState createState() => _TaskMenuState();
}

class _TaskMenuState extends State<TaskMenu> {
  final List<String> tasks = [
    'User Interviews',
    'Wireframes',
    'Design System',
    'Icons',
    'Final Mockups',
    'Gym',
  ];

  // This list will keep track of which tasks have been completed
  List<bool> completedTasks = [];

  @override
  void initState() {
    super.initState();
    // Initialize all tasks as not completed
    completedTasks = List.generate(tasks.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(tasks.length, (index) {
        return Card(
          margin: EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.orangeAccent,
          child: ListTile(
            title: Text(
              tasks[index],
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            trailing: Icon(
              Icons.check_circle,
              color: completedTasks[index] ? Colors.green : Colors.white,
            ),
            onTap: () {
              setState(() {
                completedTasks[index] = !completedTasks[index];
              });
            },
          ),
        );
      }),
    );
  }
}
