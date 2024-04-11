// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/views/tasks/subtasks.dart';
import 'package:my_app/common/deletedialog.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/controllers/gptapi.dart';
import 'package:my_app/views/loadingscreens/loadingtask.dart';
import '../../common/toast.dart';
import 'package:my_app/utils/cache_util.dart'; // Ensure this is correctly imported

class TaskDetailsPage extends StatefulWidget {
  final String username;
  final Map<String, dynamic> task;
  const TaskDetailsPage({Key? key, required this.username, required this.task})
      : super(key: key);

  @override
  State<TaskDetailsPage> createState() =>
      _TaskPageState(username: username, mytask: task);
}

class _TaskPageState extends State<TaskDetailsPage> {
  String username;
  Map<String, dynamic> mytask;
  _TaskPageState({required this.username, required this.mytask});

  List<Map<String, dynamic>> teamMembers = [];
  List<dynamic> subtasks = [];
  late TextEditingController _projectHeadingController;
  late TextEditingController _projectDescriptionController;
  final FocusNode _headingFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  var taskdetailschanged = false;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    mytask = widget.task;
    // Initialize the text controllers with random text
    _projectHeadingController = TextEditingController(
      text: mytask['heading'],
    );
    _projectDescriptionController = TextEditingController(
      text: mytask['description'],
    );
  }

  @override
  void dispose() {
    _projectHeadingController.dispose();
    _projectDescriptionController.dispose();
    _headingFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  Future<void> atload() async {
    subtasks = await getSubTasks(username, mytask['heading']);
    // print("subtasks ... $subtasks");
  }

  void _saveProjectDetails() async {
    // Here we would typically save the data to a database or some other storage.
    // For demonstration, we're just printing the values to the console.
    String headingg = _projectHeadingController.text;
    String desc = _projectDescriptionController.text;
    print('Project Heading: $headingg');
    print('Project Description: $desc');
    taskdetailschanged = true;

    // Show a snackbar as feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project details saved!')),
    );

    await editTask(username, headingg, desc, mytask['heading']);
    await TaskService().updateCachedNotes(username, headingg, mytask['heading'],
        desc, "date", "start_time", "end_time", "edit");
    showmsg(message: "Task has been updated successfully!");

    List<Map<String, dynamic>>? cachedAllTasks =
        CacheUtil.getData('tasks_$username');
    if (cachedAllTasks != null) {
      int index = cachedAllTasks
          .indexWhere((task) => task['heading'] == mytask['heading']);
      if (index != -1) {
        cachedAllTasks[index]['heading'] = headingg; // Update the heading
        cachedAllTasks[index]['description'] = desc; // Update the description
        CacheUtil.cacheData('tasks_$username', cachedAllTasks);
      }
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(username: username),
        ));
  }

  void deleteProject() async {
    String headingg = _projectHeadingController.text;
    await deleteTask(username, headingg);
    await TaskService().updateCachedNotes(
        username, headingg, headingg, "desc", "date", "start", "end", "delete");
    showmsg(message: "Task has been deleted successfully!");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(username: username),
        )); // Go back to the previous screen with the list updated
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 35.0), // Adjust the value as needed
            child: Text(
              'Task Details',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      iconTheme: IconThemeData(
          color: Colors.white), // Set the color of the back button
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
        padding: EdgeInsets.only(
            left: 10), // Adjust padding to move icon slightly to left
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
        future: atload(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingTask(); // Show loading page while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildDuedateProjectTeam(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('Task Heading'),
                    _buildProjectHeadingInput(),
                    const SizedBox(height: 10),
                    _buildSectionTitle('Task Description'),
                    _buildProjectDescriptionInput(),
                    const SizedBox(height: 20),
                    _buildProgressIndicatorWithText(), // Moved here
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            showDeleteConfirmationDialog(
                                context, deleteProject);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 215, 100),
                          ),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('Delete Task',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(width: 35),
                        ElevatedButton(
                          onPressed: _saveProjectDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 215, 100),
                          ),
                          child: const Text('Save Project Details',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildSubtasks(username),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget _buildSubtasks(String username) {
    //show diff views dep on if subtasks are available

    if (subtasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "This task currently has no subtasks. Let's add more depth to your project with some creative ideas!",
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showEnhanceConfirmationDialog,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Enhance your project ideas'),
              style: ElevatedButton.styleFrom(
                // primary: Colors.deepOrange,
                // onPrimary: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 4.0,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionTitle('All Subtasks'),
            const SizedBox(height: 20),
            _buildTaskMenu(username),
          ],
        ));
  }

// Method to create the project heading input field
  Widget _buildProjectHeadingInput() {
    return TextField(
      controller: _projectHeadingController,
      focusNode: _headingFocus,
      decoration: const InputDecoration(
        hintText: 'Enter project heading here',
      ),
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(
            _descriptionFocus); // Move focus to the description field
      },
      textInputAction:
          TextInputAction.next, // Adds a "next" button to the keyboard
    );
  }

  Widget _buildProjectDescriptionInput() {
    return TextField(
      controller: _projectDescriptionController,
      focusNode: _descriptionFocus,
      decoration: const InputDecoration(
        hintText: 'Enter project description here',
      ),
      onSubmitted: (_) {
        _descriptionFocus.unfocus();
      },
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction
          .done, // Adds a "done" button to the keyboard for multiline input
    );
  }

  Widget _buildDuedateProjectTeam() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildIconContainer(icon: Icons.calendar_month),
                const SizedBox(width: 10),
                const Column(
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
                const SizedBox(width: 110),
                _buildIconContainer(icon: Icons.group),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
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
        ));
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
        const Text(
          'Project Progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 150),
        SizedBox(
          width: 20, // Width of the circle
          height: 20, // Height of the circle
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            strokeWidth: 2,
          ),
        ),
        const SizedBox(width: 5), // Space after the progress indicator
        Text(
          '${(progress * 100).toInt()}%', // The percentage text
          style: const TextStyle(
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
              // Navigate to CreateSubTaskPage
            },
            child: const Text(
              'Add Subtask',
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
      // bottomNavigationBar: _buildFooterButton(),
    );
  }

  Future<void> _showEnhanceConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Enhancement'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You can only use the enhance feature once.'),
                Text(
                    'Make sure your description and heading are adequately detailed.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                // Call your enhance feature method here
                Navigator.of(context).pop(); // Dismiss the dialog
                await _enhanceProject();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _enhanceProject() async {
    List<Map<String, dynamic>> newsubtasks = await gptapicall(
      _projectHeadingController.text,
      _projectDescriptionController.text,
    );
    await addSubTasks(username, mytask['heading'], newsubtasks);
    setState(() {
      subtasks = newsubtasks;
    });
    // Show a message or perform other actions after enhancing the project
  }

  Widget _buildTaskMenu(String username) {
    // Assuming your tasks are fetched or defined here
    final List<String> tasks =
        subtasks.map((item) => item['subheading'] as String).toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(5.0),
          color: Colors.orangeAccent,
          child: ListTile(
            title: Text(
              tasks[index],
              style: const TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.edit, color: Colors.blue),
            onTap: () async {
              // Use async-await instead of then
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubTaskPage(
                      username: username,
                      taskheading: taskdetailschanged
                          ? _projectHeadingController.text
                          : mytask['heading'],
                      subtasks: subtasks,
                      subtaskIndex: index),
                ),
              );
              // This ensures setState is called within the correct context
              // setState(() {}); // Refresh the list upon return
            },
          ),
        );
      },
    );
  }
}
