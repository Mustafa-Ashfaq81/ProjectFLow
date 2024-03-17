import 'package:flutter/material.dart';
import 'package:my_app/common/deletedialog.dart';


class SubTaskPage extends StatefulWidget {
  final String username;
  final List<dynamic> subtasks;    // The subtask 
  final int subtaskIndex;
  const SubTaskPage({Key? key, required this.username,  required this.subtaskIndex, required this.subtasks  }) : super(key: key);

  @override
  _SubtaskPageState createState() => _SubtaskPageState(username: username, subtaskIndex: subtaskIndex ,subtasks:subtasks );

}

class _SubtaskPageState extends State<SubTaskPage> {

  String username;
  final List<dynamic> subtasks;
  final int subtaskIndex;
  late TextEditingController _headingController;
  late TextEditingController _descriptionController;
  _SubtaskPageState({required this.username, required this.subtaskIndex,required this.subtasks });
   
  @override
  void initState() {
    super.initState();
    username = widget.username;
    _headingController = TextEditingController(text: widget.subtasks[subtaskIndex]['subheading']);
    _descriptionController = TextEditingController(text: widget.subtasks[subtaskIndex]['content']);
  }

  @override
  void dispose() {
    _headingController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    // Update the task's title in the global list and pop back to the previous screen
    setState(() {
      widget.subtasks[subtaskIndex]['subheading'] = _headingController.text;
      widget.subtasks[subtaskIndex]['content'] = _descriptionController.text;
    });
    Navigator.of(context).pop(); // Go back to the previous screen with the updated list
  }


  void _deleteTask() {
    // Remove the task from the global list
    setState(() {
      // subtasks.removeAt(widget.subtaskIndex); 
      //uncomment this after implementing backend functions to edit,remove subtasks ... 
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
      const Text("similarly fetch subtask description and display it in an editable text input field , access it by _descriptionController"),
      ElevatedButton(
        onPressed: _saveTask,
        child: const Text('Save Changes'),
      ),
      const SizedBox(height: 8), 
      ElevatedButton(
        onPressed:()  { showDeleteConfirmationDialog(context,_deleteTask); },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Use a color that indicates a destructive action
        ),
        child: const Text('Delete Subtask'),
      ),
    ],
        ),
      ),
    );
  }


}
