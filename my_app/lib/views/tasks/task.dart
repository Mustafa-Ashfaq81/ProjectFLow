// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, no_logic_in_create_state, const_with_non_constant_argument

import 'package:flutter/material.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/views/tasks/subtasks.dart';
import 'package:my_app/common/deletedialog.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/controllers/gptapi.dart';
import 'package:my_app/views/loadingscreens/loadingtask.dart';
import '../../common/toast.dart';
import 'package:my_app/utils/cache_util.dart'; // Ensure this is correctly imported
import 'package:my_app/controllers/calendarapi.dart';

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
  late double progress;
  var taskdetailschanged = false;
  late String duedatestring;

  late TextEditingController _projectHeadingController;
  late TextEditingController _projectDescriptionController;
  final FocusNode _headingFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final CalendarClient calendarClient = CalendarClient();

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
    if(mytask['duedate']!=""){
      DateTime date = DateTime.parse(mytask['duedate']);
      String monthname = getMonth(date.month);
      duedatestring =  "${date.day} ${monthname}";
    } else { duedatestring = ""; }
  }

  String getMonth(int month) {
     switch (month) 
    {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'ERROR';
    }
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
    //fetching progress of task
    if (subtasks.length>0) {
      int completedCount = 0;
      int totalCount = subtasks.length;
      for (var subtask in subtasks) {
        if (subtask['progress'] == 'completed') { completedCount++; }
      }
      progress =  totalCount == 0 ? 0.0 : completedCount / totalCount;
    } else {  //default 0 progress if NO subtasks 
      progress = 0.0;
    }
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
  }

  void deleteProject(Function onCompletion) async {
    String headingg = _projectHeadingController.text;

    // Delete the task from the local app data
    await deleteTask(username, headingg);
    await TaskService().updateCachedNotes(
        username, headingg, headingg, "desc", "date", "start", "end", "delete");

    // Get the event ID of the task you want to delete from Google Calendar
    String? eventId = await getEventId(headingg);

    if (eventId != null) {
      // Delete the event from Google Calendar
      await calendarClient.delete("primary", eventId);

      showmsg(message: "Task has been deleted successfully!");
      onCompletion();

      // Refresh the UI by calling setState
      setState(() {});
    } else {
      showmsg(message: "Event not found in Google Calendar");
    }
  }

  void onDeletionComplete() {
    setState(() {});
    Navigator.pop(context);
  }

  Future<String?> getEventId(String eventTitle) async {
    // Retrieve the list of events from Google Calendar
    var events = await calendarClient.getEvents();

    // Find the event with the matching title
    for (var event in events) {
      if (event.summary == eventTitle) {
        return event.id;
      }
    }

    return null; // Event not found
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
              'Project Details',
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
                    _buildSectionTitle('Project Heading'),
                    const SizedBox(height: 5),
                    _buildProjectHeadingInput(),
                    const SizedBox(height: 20),
                    _buildDuedateProjectTeam(),
                    const SizedBox(height: 20),
                    _buildProgressBarAndDeleteButton(),
                    const SizedBox(height: 15),
                    _buildSectionTitle('Project Notes'),
                    const SizedBox(height: 5),
                    _buildProjectNotesInput(),
                    const SizedBox(height: 20),
                    _buildSaveButton(context),
                    const SizedBox(height: 20),
                    _buildSubtasks(username),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget _buildSaveButton(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _saveProjectDetails();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(username: username),
                  ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 255, 215, 100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.save, color: Colors.black),
              SizedBox(width: 8),
              Text('Save Project', style: TextStyle(color: Colors.black)),
            ],
          ),
        ), 
      ],
    );
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
              "This project currently has no tasks. Let's add more depth to your project with some creative ideas!",
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
            _buildSectionTitle('All Tasks'),
            const SizedBox(height: 20),
            _buildTaskMenu(username),
          ],
        ));
  }

// Method to create the project heading input field
  Widget _buildProjectHeadingInput() {
    return TextFormField(
      controller: _projectHeadingController,
      focusNode: _headingFocus,
      decoration: InputDecoration(
        hintText: 'Enter project heading here',
        hintStyle: TextStyle(color: Colors.grey[400]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[500]!),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      style: TextStyle(fontSize: 18.0),
      cursorColor: Colors.blue,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        _headingFocus.unfocus(); // Hide keyboard
        FocusScope.of(context).requestFocus(_descriptionFocus);
      },
    );
  }

  Widget _buildProjectNotesInput() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFFFE6C9), // Beige color for the box
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.brown[200]!), // Border color
      ),
      child: TextField(
        controller: _projectDescriptionController,
        focusNode: _descriptionFocus,
        decoration: InputDecoration(
          hintText: 'Enter project description here',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(duedatestring),
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

  Widget _buildProgressBarAndDeleteButton() {
    // Customizable values
    // double progress = 0.6; // 60%
    Color progressColor = progress < 0.5 ? Colors.red : Colors.green; // Color of the progress indicator

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 165),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold, // Make percentage bold
            color: progressColor, // Set color based on progress
          ),
        ),
        const SizedBox(width: 15),
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
              showDeleteConfirmationDialog(
                context,
                () => deleteProject(onDeletionComplete),
              );
          },
        )

      ],
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
    _saveProjectDetails();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sending call to OpenAi servers, this may take a few seconds ... '),
        duration: Duration(seconds: 5),
      ),
    );
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
