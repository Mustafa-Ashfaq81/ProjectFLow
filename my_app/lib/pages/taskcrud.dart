import 'package:flutter/material.dart';

// Ensure this list is accessible here. This could be a global list or managed via a state management solution.
List<String> tasks = [
  'User Interviews',
  'Wireframes',
  'Design System',
  'Icons',
  'Final Mockups',
  'Gym',
];

class TaskCRUDPage extends StatefulWidget {
  final int taskIndex; // Index of the task in the global 'tasks' list
  const TaskCRUDPage({Key? key, required this.taskIndex}) : super(key: key);

  @override
  State<TaskCRUDPage> createState() => _TaskCRUDPageState();
}

class _TaskCRUDPageState extends State<TaskCRUDPage> {
  late TextEditingController _headingController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the title of the task to be edited
    _headingController = TextEditingController(text: tasks[widget.taskIndex]);
  }

  void _saveTask() {
    // Update the task's title in the global list and pop back to the previous screen
    setState(() {
      tasks[widget.taskIndex] = _headingController.text;
    });
    Navigator.of(context).pop(); // Go back to the previous screen with the updated list
  }

  void _showDeleteConfirmationDialog() {
    // Show a dialog to confirm the deletion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Dismiss the dialog
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Delete the task and pop back to the previous screen
                _deleteTask();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
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
        title: const Text('Edit Task'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog, // Show confirmation dialog before deleting
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
          labelText: 'Task Title',
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: _saveTask,
        child: const Text('Save Changes'),
      ),
      const SizedBox(height: 8), // Add some space between the buttons
      ElevatedButton(
        onPressed: _showDeleteConfirmationDialog,
        child: const Text('Delete Task'),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue, // Use a color that indicates a destructive action
        ),
      ),
    ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _headingController.dispose();
    super.dispose();
  }
}
