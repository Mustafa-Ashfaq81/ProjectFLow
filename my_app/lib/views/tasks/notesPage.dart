// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api,unnecessary_cast,use_build_context_synchronously, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:my_app/components/search.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/views/tasks/completedtask.dart';
import 'package:my_app/views/tasks/task.dart';
import 'package:my_app/views/loading.dart';
import 'package:my_app/utils/cache_util.dart';

class AllTasksPage extends StatefulWidget {
  final String username;
  const AllTasksPage({super.key, required this.username});

  @override
  _AllTasksPageState createState() => _AllTasksPageState(username: username);
}

class _AllTasksPageState extends State<AllTasksPage> {
  String username;
  final int idx = 1;
  final TextEditingController queryController = TextEditingController();
  String currQuery = "";
  List<String> headings = [];
  List<Map<String, dynamic>> alltasks = [];

  _AllTasksPageState({required this.username});

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  Future<void> atload() async {
    List<Map<String, dynamic>>? cachedAllTasks =
        CacheUtil.getData('tasks_$username');
    List<String>? cachedHeadings = CacheUtil.getData('headings_$username');
    if (cachedAllTasks != null) {
      alltasks = cachedAllTasks;
    } else {
      print('progress-tasks-cache-null');
      alltasks = await getAllTasks(username);
      CacheUtil.cacheData('tasks_$username', alltasks);
    }
    if (cachedHeadings != null) {
      headings = cachedHeadings;
    } else {
      print('headings-cache-null');
      headings = await getTaskHeadings(username);
      CacheUtil.cacheData('headings_$username', headings);
    }
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
          future: atload(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingTask(); // Show loading page while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: AppBar(
                    centerTitle: true, // Aligns the title to the center
                    backgroundColor:
                        Colors.black, // Set background color to black
                    automaticallyImplyLeading:
                        false, // Disable automatic back button

                    title: Text(
                      'My Notes',
                      style: TextStyle(
                          color: Colors.white), // Set text color to white
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    _buildSearchBox(),
                    Expanded(
                      child:
                          // completedIdeasView(context, headings, username)
                          _buildNotesList(), // This will build the list of notes
                    ),
                  ],
                ),
                bottomNavigationBar: Footer(index: idx, username: username),
              );
            }
          });
    });
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10.0,
        top: 20.0,
        left: 10.0,
        bottom: 20.0,
      ),
      child: GestureDetector(
        onTap: () {
          Future<String?> selectedTask = showSearch(
            context: context,
            delegate: SearchTasks(username: username, headings: headings)
                as SearchDelegate<String>,
          );
          selectedTask.then((taskheading) async {
            Map<String, dynamic> task =
                await getTaskbyHeading(taskheading!, username);
            if (taskheading != "") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TaskDetailsPage(username: username, task: task),
                ),
              );
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: queryController,
                  decoration: InputDecoration(
                    hintText: 'Search Notes',
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                  enabled: false,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                color: Colors.black45,
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    final List<Map<String, dynamic>> notes = alltasks;

    // Define a list of colors
    final List<Color> colors = [
      const Color(0xFF141310).withOpacity(0.80),
      const Color(0xFFE16C00).withOpacity(0.41),
    ];

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        // Using modulo (%) operator to cycle through the colors list if there are more notes than colors
        Color bgColor = colors[index % colors.length];

        // Extracting the first line of the description
        String firstLine = notes[index]['description'].split('\n').first;

        return Card(
          color: bgColor, // Using the bgColor for this note card
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            title: Text(
              notes[index]['heading'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0, // Increased font size for heading
                  // backgroundColor: Colors.white
                  color: Colors.white),
            ),
            subtitle: Text(
              firstLine,
              style: const TextStyle(
                  fontSize: 14.0, // Reduced font size for description
                  color: Colors.white),
            ),
            onTap: () async {
              Map<String, dynamic> task =
                  await getTaskbyHeading(notes[index]['heading'], username);
              if (notes[index]['status'] == 'completed') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CompletedTaskPage(username: username, task: task),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TaskDetailsPage(username: username, task: task),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
