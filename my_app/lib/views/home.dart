// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:my_app/auth/controllers/authservice.dart';
import 'package:my_app/common/logoutdialog.dart';
import 'package:my_app/controllers/taskstatus.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/components/image.dart';
import 'package:my_app/components/search.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/views/settings/settings.dart';
import 'package:my_app/views/tasks/task.dart';


// enum data type for logout and settings

enum MenuAction { logout, settings }

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController querycontroller = TextEditingController();

  Widget completedtasks = const Text("loading-at-init-state");
  Widget inprogresstasks = const Text("loading-at-init-state");
  Widget profilepic = const Text("loading-at-init-state");

  final int idx = 0;
  String username = "";
  String currquery = "";
  List<String> headings = [];

  @override
  void initState() {
    super.initState();
    print("init-state-sync");
    username = widget.username;
    completedtasks = fetchTasks("completed", username);
    inprogresstasks = fetchTasks("progress", username);
    profilepic = ImageSetter(username: username);
    atload();
  }

  Future<void> atload() async {
    headings = await getTaskHeadings(username);
  }

  @override
  void dispose() {
    querycontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('My Notes')),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await _auth.logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("/", (_) => false);
                  }
                  break;
                case MenuAction.settings:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsPage(username: username)));
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.settings,
                  child: Text('Settings'),
                ),
              ];
            },
          )
        ],
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  profilepic,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 0.0),
              child: Text(
                username, // Your name
                style: const TextStyle(
                  fontFamily: 'PilotExtended',
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height:20),
            Padding(
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
                      controller: querycontroller,
                      decoration: InputDecoration(
                          hintText: 'Search Task',
                          hintStyle: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF000000), // Adjusting the hint color
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Radius of the text field
                            borderSide:
                                BorderSide.none, // Removes default border
                          ),
                          filled: true, // Needed for fillColor to work
                          fillColor: const Color(0xFFFFFFFF)),
                      onChanged: (text) {
                        setState(() {
                          currquery = text;
                        });
                        if (currquery != "") {
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
                          querycontroller.clear();
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
                      } 
                      ),
                ],
              ),
            ), // Padding inside the container for alignment
            const Padding(
              padding: EdgeInsets.only(left: 30.0, top: 0.0),
              child: Text(
                'Completed Tasks', 
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            completedtasks,
            const Padding(
              padding: EdgeInsets.only(left: 30.0, top: 20.0),
              child: Text(
                'Ongoing Projects', 
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            inprogresstasks,
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Footer(context, idx, username),
    );
  }
}
