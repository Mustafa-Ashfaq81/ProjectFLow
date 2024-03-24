import 'package:flutter/material.dart';
import 'package:my_app/common/deletedialog.dart';
import 'package:my_app/models/taskmodel.dart';

class SubTaskPage extends StatefulWidget {
  final String username;
  final String taskheading;        // The task
  final List<dynamic> subtasks;    // The subtasks of this task
  final int subtaskIndex;          // Index of this subtask
  const SubTaskPage({Key? key, required this.username,  required this.subtaskIndex, required this.subtasks , required this.taskheading  }) : super(key: key);

  @override
  _SubtaskPageState createState() => _SubtaskPageState(username: username, subtaskIndex: subtaskIndex ,subtasks:subtasks, taskheading: taskheading );

}

class _SubtaskPageState extends State<SubTaskPage> {

  String username;
  String taskheading;  
  final List<dynamic> subtasks;
  final int subtaskIndex;
  late TextEditingController _headingController;
  late TextEditingController _descriptionController;
  _SubtaskPageState({required this.username, required this.subtaskIndex,required this.subtasks, required this.taskheading });
   
  @override
  void initState() {
    super.initState();
    taskheading = widget.taskheading;
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

  void _saveTask() async{
    // Update the subtask's title,description in the global list and pop back to the previous screen
    await editSubTask(username,_headingController.text, _descriptionController.text,widget.subtasks[subtaskIndex]['subheading'],taskheading);
    setState(() {
      widget.subtasks[subtaskIndex]['subheading'] = _headingController.text;
      widget.subtasks[subtaskIndex]['content'] = _descriptionController.text;
    });
    Navigator.of(context).pop(); // Go back to the previous screen with the updated list
  }


  void _deleteTask() async{
    // Remove the task from the global list
    await deleteSubTask(username, taskheading, widget.subtasks[subtaskIndex]['subheading']);
    setState(() {
      subtasks.removeAt(widget.subtaskIndex); 
      //uncomment this after implementing backend functions to edit,remove subtasks ... 
    });
    Navigator.of(context).pop(); // Go back to the previous screen with the list updated
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 35.0), // Adjust the value as needed
              child: Text(
                'Subtask Details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
            color: Colors.white), // Set the color of the back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.only(left:10), // Adjust padding to move icon slightly to left
        ),
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
       TextField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          labelText: 'Subtask Description',
        ),
      ),
      const SizedBox(height: 20),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: ()  { showDeleteConfirmationDialog(context,_deleteTask); },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color.fromARGB(255, 255, 215, 100),
            ),
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Delete Subtask',
                style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 205),
          ElevatedButton(
            onPressed: _saveTask,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color.fromARGB(255, 255, 215, 100),
            ),
            child: const Text('Save Subtask Details',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),

      // ElevatedButton(
      //   onPressed: _saveTask,
      //   child: const Text('Save Changes'),
      // ),
      // const SizedBox(height: 8), 
      // ElevatedButton(
      //   onPressed:()  { showDeleteConfirmationDialog(context,_deleteTask); },
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: Colors.red, // Use a color that indicates a destructive action
      //   ),
      //   child: const Text('Delete Subtask'),
      // ),
    ],
        ),
      ),
    );
  }


}
