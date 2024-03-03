import 'package:flutter/material.dart';
import 'package:my_app/components/search.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/pages/task_details.dart';

class NotesPage extends StatefulWidget {
  final String username;
  NotesPage({required this.username});

  @override
  _NotesPageState createState() => _NotesPageState(username: username);
}

class _NotesPageState extends State<NotesPage> {
  String username;
  final int idx = 1;
  final TextEditingController queryController = TextEditingController();
  String currQuery = "";
  List<String> headings = [];
  List<Map<String,dynamic>> alltasks = [];

  _NotesPageState({required this.username});


  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  Future<void> atload() async {
    headings = await getTaskHeadings(username);
    alltasks = await getAllTasks(username);
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
        return Center(child:CircularProgressIndicator()); // Show loading indicator while fetching data
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Notes Page'),
            ),
            body: Column(
              children: [
                _buildSearchBox(),
                Expanded(
                  child: _buildNotesList(), // This will build the list of notes
                ),
              ],
            ),
            bottomNavigationBar: Footer(context, idx, username),
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
                hintStyle: TextStyle(color: Color(0xFF000000)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xFFFFFFFF),
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
            icon: Icon(Icons.search),
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
      Colors.pink[50]!,
      Colors.lightGreen[50]!,
      Colors.lightBlue[50]!,
      // Add more colors as needed
    ];

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        // Use modulo (%) operator to cycle through the colors list if there are more notes than colors
        Color bgColor = colors[index % colors.length];

        return Card(
          color: bgColor, // Use the bgColor for this note card
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            title: Text(
              notes[index]['heading'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(notes[index]['description']),
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