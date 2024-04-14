import 'package:flutter/material.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/views/loadingscreens/loadingtask.dart';

class CompletedTaskPage extends StatefulWidget {
  final String username;
  final Map<String, dynamic> task;
  const CompletedTaskPage({Key? key, required this.username, required this.task})
      : super(key: key);

  @override
  State<CompletedTaskPage> createState() =>
      _CompletedTaskPageState(username: username, mytask: task);
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {
  String username;
  Map<String, dynamic> mytask;
  _CompletedTaskPageState({required this.username, required this.mytask});
  List<dynamic> subtasks = [];
  late String taskheading ; 
  late String taskdesc ; 
  bool showFullDescription = false; // toggle button for project description
  // bool showContent = false; // toggle button for project subtasks content

   @override
  void initState() {
    super.initState();
    username = widget.username;
    mytask = widget.task;
    taskheading = mytask['heading'];
    taskdesc = mytask['description'];
  }

  Future<void> atload() async {
    subtasks = await getSubTasks(username, mytask['heading']);
  }

  @override
  Widget build(BuildContext context) {
       return FutureBuilder(
        future: atload(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingTask(); // Show loading page while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
            appBar: _buildAppBar(),
            body:  SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Project Heading'),
                    const SizedBox(height: 5),
                    _buildProjectHeading(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Project Description'),
                    const SizedBox(height: 5),
                    _buildProjectNotes(),
                    const SizedBox(height: 20),
                    _buildSubtasks(username),
                  ],
                ),
              ),
            )
            );
          }
        });
  }

  Widget _buildSectionTitle(String title) {
    return Center( child: 
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
   );
  }

    AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 35.0), // Adjust the value as needed
            child: Text(
              'Completed Project Details',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      iconTheme: IconThemeData(color: Colors.white), // Set the color of the back button
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
        padding: EdgeInsets.only(left: 10), // Adjust padding to move icon slightly to left
      ),
    );
  }

  Widget _buildProjectHeading() {
    return Text(
        taskheading,
        style: const TextStyle(
          fontSize: 18.0, 
          fontWeight: FontWeight.bold,
        ),
      );
  }

  Widget _buildProjectNotes() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text left
      children: [
        Text(
          taskdesc,
          maxLines: showFullDescription ? null : 3, // Toggle maxLines based on state
        ),
        if (taskdesc.length > 75) // Show toggle button if needed
          TextButton(
            onPressed: () {
              setState(() {
                showFullDescription = !showFullDescription; //stateful builder?
              }); // Update state to rebuild UI
            },
            child: Text(
              showFullDescription ? 'Show less' : 'Show more',
            ),
          ),
      ],
    );
  }

  Widget _buildSubtasks(String username) {
    //show diff views dep on if subtasks are available

    if (subtasks.isEmpty) {
      return const Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Center( 
              child :Text(
              "This project has no subtasks.",
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
             ),
            ),
            SizedBox(height: 20),
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
            _buildTaskMenu(),
          ],
        ));
  }

  Widget _buildTaskMenu() {
     return Column(
      children: subtasks.asMap().entries.map((entry) => _buildSubtask(entry.key, entry.value)).toList(),
    );
  }

 Widget _buildSubtask(int index, dynamic subtask) {
  bool showContent = false; // State variable for toggle button

  return  StatefulBuilder(builder: (BuildContext context, StateSetter setState) { //avoids reloading at setState() calls
   return Column ( children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align heading and icon
      children: [
        Expanded( // Wrap heading to avoid overflow
          child: Text(
            subtask['subheading']!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: Icon(
            showContent ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              showContent = !showContent;
            });
          },
        ),
        ],
      ),
      const SizedBox(height: 8.0),
      Visibility(
          visible: showContent,
           child: Column( // Use Column to stack content vertically
            children: [
              Text(
                subtask['content']!, 
                // textAlign: TextAlign.left, 
              ),
            ],
          ),
        ),
      ]
    );
   });
  }
}