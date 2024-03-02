import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskPage(username: 'Essa'),
    );
  }
}

class TaskPage extends StatefulWidget {
  final String username;

  const TaskPage({Key? key, required this.username}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> 
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: Footer(context, 2, widget.username), 
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFFE6C9),
      title: const Text('Create New Task'),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Task Title'),
            const SizedBox(height: 10),
            _buildTextInputField(hint: 'Enter task title', maxLines: 1),
            const SizedBox(height: 20),
            _buildSectionTitle('Task Details'),
            const SizedBox(height: 10),
            _buildTextInputField(hint: 'Enter task details', maxLines: null),
            const SizedBox(height: 20),
            _buildSectionTitle('Add Team Members'),
            const SizedBox(height: 10),
            _buildTeamMembersRow(),
            const SizedBox(height: 20),
            _buildSectionTitle('Time & Date'),
            const SizedBox(height: 10),
            _buildTimeAndDateSection(),
            const SizedBox(height: 30),
            _buildCreateTaskButton(),
          ],
        ),
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

  Widget _buildTextInputField({required String hint, int? maxLines}) {
    return Container(
      width: 400.0,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: TextField(
        maxLength: maxLines == 1 ? 50 : 500,
        keyboardType: maxLines == 1 ? TextInputType.text : TextInputType.multiline,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
          hintText: hint,
        ),
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget _buildTeamMembersRow() {
    // Dummy data for team members, replace with your actual data source
    List<Map<String, dynamic>> teamMembers = [
      {"name": "Robert", "color": Colors.lightBlue[100]},
      {"name": "Sophia", "color": Colors.lightGreen[100]},
      {"name": "Ethan", "color": Colors.lightBlue[100]},
      {"name": "Olivia", "color": Colors.lightBlue[100]},
      {"name": "Liam", "color": Colors.orange[100]},
      {"name": "Mia", "color": Colors.yellow[100]},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: teamMembers
            .map((member) => _buildTeamMember(member["name"], member["color"]))
            .toList(),
      ),
    );
  }

  Widget _buildTeamMember(String name, Color color) {
    return Container(
      height: 40.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.person_outline, color: Colors.grey),
          const SizedBox(width: 8),
          Text(name),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () 
            {
            },
            child: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

 Widget _buildTimeAndDateSection() 
 {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          _buildIconContainer(icon: Icons.access_time),
          const SizedBox(width: 10),
          _buildDateTimeField('09:00 AM', 'Time Start'),
          const SizedBox(width: 10),
          const Text(
            ':',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          _buildDateTimeField('10:00 AM', 'Time End'),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          _buildIconContainer(icon: Icons.calendar_month),
          const SizedBox(width: 10),
          _buildDateTimeField('Select Date', 'Date'),
        ],
      ),
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

  Widget _buildDateTimeField(String hint, String label) {
  return Expanded( 
    child: Container(
      height: 40.0,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: TextField(
        readOnly: label == 'Date', 
        onTap: () {
          if (label == 'Date')
           {
            _selectDate(context);
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
          hintText: hint,
        ),
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.black,
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.datetime,
      ),
    ),
  );
}

Future<void> _selectDate(BuildContext context) async 
{
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), 
    firstDate: DateTime(2000),
    lastDate: DateTime(2025), 
  );
  if (picked != null) 
  {
    
  }
}

  Widget _buildCreateTaskButton() 
  {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          primary: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: () 
        {

        },
        child: const Text(
          'Create Task',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
