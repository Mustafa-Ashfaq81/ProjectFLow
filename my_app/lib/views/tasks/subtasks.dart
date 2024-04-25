import 'package:flutter/material.dart';
import 'package:my_app/utils/dialogs/deletedialog.dart';
import 'package:my_app/utils/dialogs/completedialog.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/views/tasks/task.dart';
import 'package:my_app/views/tasks/completedtask.dart';

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
  final FocusNode _descriptionFocus = FocusNode();
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
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _saveTask() async{
    // Update the subtask's title,description in the global list and pop back to the previous screen
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saving your subtask details ... '),
        duration: Duration(seconds: 2),
      ),
    );
    await editSubTask(username,_headingController.text, _descriptionController.text,widget.subtasks[subtaskIndex]['subheading'],taskheading);
    setState(() {
      widget.subtasks[subtaskIndex]['subheading'] = _headingController.text;
      widget.subtasks[subtaskIndex]['content'] = _descriptionController.text;
    });
    Navigator.of(context).pop(); // Go back to the previous screen with the updated list
  }


  Future<void> _deleteTask() async{
    // Remove the task from the global list
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleting this subtask ... '),
        duration: Duration(seconds: 2),
      ),
    );
    await deleteSubTask(username, taskheading, widget.subtasks[subtaskIndex]['subheading']);
    setState(() {
      subtasks.removeAt(widget.subtaskIndex); 
    });
    Map<String, dynamic> thisTask = await getTaskbyHeading(taskheading, username);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskDetailsPage(username: username, task: thisTask),
        ),
    );
  }

  void _completeSubTask() async{
    // Remove the task from the global list
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Marking this subtask as completed ... '),
        duration: Duration(seconds: 2),
      ),
    );
    await completeSubtask(username, taskheading, widget.subtasks[subtaskIndex]['subheading']);
    final isCompletedTask = await isCompleted(username,taskheading);
    Map<String, dynamic> thisTask = await getTaskbyHeading(taskheading, username);
    if(isCompletedTask){
       Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompletedTaskPage(username: username, task: thisTask),
          ),
        );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskDetailsPage(username: username, task: thisTask),
        ),
      );
    }
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
      //  TextField(
      //   controller: _descriptionController,
      //   decoration: const InputDecoration(
      //     labelText: 'Subtask Description',
      //   ),
      // ),
      Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFFFFE6C9), // Beige color for the box
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.brown[200]!), // Border color
          ),
          child: TextField(
            controller: _descriptionController,
            focusNode: _descriptionFocus,
            decoration: InputDecoration(
              hintText: 'Enter subtask description here',
              border: InputBorder.none, // Hide the default border of the TextField
            ),
            style:
                TextStyle(fontSize: 16.0, color: Colors.brown[800]), // Text color
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              _descriptionFocus.unfocus();
            },
          ),
      ),
      const SizedBox(height: 20),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red,
          onPressed: () async { 
            Map<String, dynamic> thisTask = await getTaskbyHeading(taskheading, username);
            showDeleteConfirmationDialog(context,_deleteTask,username,thisTask); 
          },
         ),
          const SizedBox(width: 105),
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
      const SizedBox(height: 50),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: ()  { showCompleteConfirmationDialog(context,_completeSubTask); },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color.fromARGB(255, 255, 215, 100),
            ),
            icon: const Icon(Icons.done, color: Color.fromARGB(255, 0, 88, 3)),
            label: const Center ( child : Text('Mark as Completed',
                style: TextStyle(color: Colors.black))),
          ),
        ]
      )


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
