// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api,unnecessary_cast,use_build_context_synchronously, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:my_app/components/search.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/views/tasks/task.dart';
import 'package:my_app/views/loadingscreens/loadingalltasks.dart';
import 'package:my_app/utils/cache_util.dart'; // Ensure this is correctly imported


class AllTasksPage extends StatefulWidget 
{
  final String username;
  const AllTasksPage({super.key, required this.username});

  @override
  _AllTasksPageState createState() => _AllTasksPageState(username: username);
}

class _AllTasksPageState extends State<AllTasksPage> 
{
  String username;
  final int idx = 1;
  final TextEditingController queryController = TextEditingController();
  String currQuery = "";
  List<String> headings = [];
  List<Map<String,dynamic>> alltasks = [];

  _AllTasksPageState({required this.username});


  @override
  void initState() {
    super.initState();
    username = widget.username;
  }


  Future<void> atload() async 
  {
  List<Map<String, dynamic>>? cachedAllTasks = CacheUtil.getData('tasks_$username');
  if (cachedAllTasks != null) 
  {

    alltasks = cachedAllTasks;
  } 
  else 
  {

    headings = await getTaskHeadings(username);
    alltasks = await getAllTasks(username);

    CacheUtil.cacheData('tasks_$username', alltasks);
  }
}

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return FutureBuilder(
          future: atload(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
        return const LoadingAllTasks();  // Show loading page while fetching data
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
         return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBar(
              centerTitle: true, // Aligns the title to the center
              backgroundColor: Colors.black, // Set background color to black
              automaticallyImplyLeading: false, // Disable automatic back button

              title: Text(
                'My Notes',
                style: TextStyle(color: Colors.white), // Set text color to white
                  ),
            ),
                ),
            body: Column(
              children: [
                _buildSearchBox(),
                Expanded(
                  child: _buildNotesList(), // This will build the list of notes
                ),
              ],
            ),
             bottomNavigationBar: Footer(index: idx, username: username),
          );
      }

    });
    }
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10.0,
        top: 20.0,
        left: 10.0,
        bottom: 20.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: queryController,
              decoration: InputDecoration(
                hintText: 'Search Notes',
                hintStyle: const TextStyle(color: Color(0xFF000000)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
              ),
              onChanged: (text) {
                setState(() {
                  currQuery = text;
                });
                if (currQuery != "") {
                   Future<String?> selectedTask = showSearch(
                      context: context,
                      delegate:
        
                          SearchTasks(username: username, headings: headings)
                              as SearchDelegate<String>,
                  );
                  selectedTask.then((taskheading) async {
                    Map<String, dynamic> task = await getTaskbyHeading(taskheading!,username);
                    if (taskheading != "") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailsPage(username:username,task:task),
                          ),
                        );
                    }
                  });
                  queryController.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Future<String?> selectedTask = showSearch(
                context: context,
                delegate:
                    SearchTasks(username: username, headings: headings)
                        as SearchDelegate<String>,
              );
              selectedTask.then((taskheading) async {
                Map<String, dynamic> task = await getTaskbyHeading(taskheading!,username);
                if (taskheading != "") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsPage(username:username,task:task),
                      ),
                    );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    final List<Map<String, dynamic>> notes = alltasks;

    // Define a list of colors
    final List<Color> colors = [
      // Colors.transparent,
      const Color(0xFF141310).withOpacity(0.85),
      const Color(0xFFE16C00).withOpacity(0.48),
      // Colors.pink[50]!,
      // Colors.lightGreen[50]!,
      // Colors.lightBlue[50]!,
      // Add more colors as needed
    ];

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        // Using modulo (%) operator to cycle through the colors list if there are more notes than colors
        Color bgColor = colors[index % colors.length];

        return Card(
          color: bgColor, // Using the bgColor for this note card
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            title: Text(
              notes[index]['heading'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                // backgroundColor: Colors.white
                color: Colors.white
              ),
            ),
            subtitle: Text(
              notes[index]['description'],
              style: const TextStyle(
                // fontWeight: FontWeight.bold,
                // backgroundColor: Colors.white
                color: Colors.white
              ),
            ),
            onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsPage(username:username,task:notes[index]),
                      ),
                    );
            },
          ),
        );
      },
    );
  }
}