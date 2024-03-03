import 'package:flutter/material.dart';
import 'package:my_app/common/deletedialog.dart';

// Ensure this list is accessible here. This could be a global list or managed via a state management solution.
List<String> tasks = [
  'User Interviews',
  'Wireframes',
  'Design System',
  'Icons',
  'Final Mockups',
  'Gym',
];

class SubTaskPage extends StatefulWidget {
  final String username;
  final int taskIndex;    // Index of the task in the global 'tasks' list
  const SubTaskPage({Key? key, required this.username,  required this.taskIndex  }) : super(key: key);

  @override
  _SubtaskPageState createState() => _SubtaskPageState(username: username, taskIndex: taskIndex);

}

class _SubtaskPageState extends State<SubTaskPage> {

  String username;
  final int taskIndex;
  late TextEditingController _headingController;
  _SubtaskPageState({required this.username, required this.taskIndex,});
   
  @override
  void initState() {
    super.initState();
    username = widget.username;
    _headingController = TextEditingController(text: tasks[widget.taskIndex]);
  }

  @override
  void dispose() {
    _headingController.dispose();
    super.dispose();
  }

  void _saveTask() {
    // Update the task's title in the global list and pop back to the previous screen
    setState(() {
      tasks[widget.taskIndex] = _headingController.text;
    });
    Navigator.of(context).pop(); // Go back to the previous screen with the updated list
  }


  void _deleteTask() {
    // Remove the task from the global list
    setState(() {
      tasks.removeAt(widget.taskIndex);
    });
    Navigator.of(context).pop(); // Go back to the previous screen with the list updated
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Subtask'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed:  ()  { showDeleteConfirmationDialog(context,_deleteTask); }, // Show confirmation dialog before deleting
          ),
        ],
      ),
      body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      TextField(
        controller: _headingController,
        decoration: const InputDecoration(
          labelText: 'Subtask Title',
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: _saveTask,
        child: const Text('Save Changes'),
      ),
      const SizedBox(height: 8), // Add some space between the buttons
      ElevatedButton(
        onPressed:()  { showDeleteConfirmationDialog(context,_deleteTask); },
        child: const Text('Delete Subtask'),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue, // Use a color that indicates a destructive action
        ),
      ),
    ],
        ),
      ),
    );
  }


}
