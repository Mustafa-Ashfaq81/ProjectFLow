// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, unnecessary_cast, prefer_const_constructors, sort_child_properties_last

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

import '../utils/cache_util.dart';

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
    username = widget.username;
    atload();
  }

  Widget buildTasksList(List<Map<String, dynamic>> tasksData) {
    List<Widget> taskWidgets = tasksData.map((task) {
      return ListTile(
        title: Text(task['heading']),
        subtitle: Expanded(
          child: Text(
            task['description'],
            style: const TextStyle(color: Colors.white70),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onTap: () {
          // Working as of now. No need to implement an OnTap Method for this particular Element
        },
      );
    }).toList();

    // Return the list of task widgets wrapped in a Column, ListView, etc.
    return ListView(children: taskWidgets);
  }

  Future<void> atload() async {
    List<Map<String, dynamic>>? cachedOngoingProjects =
        CacheUtil.getData('ongoingProjects_$username');

    List<Map<String, dynamic>>? cachedCompletedProjects =
        CacheUtil.getData('completedProjects_$username');

    if (cachedOngoingProjects != null) 
    {
      print("NULL: So fetching Ongoing Projects");
      inprogresstasks = buildTasksList(cachedOngoingProjects);
    } else {
      inprogresstasks = fetchTasks("progress", username);
    }

    if (cachedCompletedProjects != null) {
      completedtasks = buildTasksList(cachedCompletedProjects);
    } else {
      completedtasks = fetchTasks("progress", username);
    }

    completedtasks = fetchTasks("completed", username);
    inprogresstasks = fetchTasks("progress", username);
    profilepic = ImageSetter(username: username);
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text(
                'My Tasks',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
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
                        builder: (context) =>
                            SettingsPage(username: username)));
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
                      fontSize: 18,
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
                username,
                style: const TextStyle(
                  fontFamily: 'PilotExtended',
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                right: 30.0,
                top: 20.0,
                left: 30.0,
                bottom: 20.0,
              ),
              child: GestureDetector(
                onTap: () {
                  Future<String?> selectedTask = showSearch(
                    context: context,
                    delegate:
                        SearchTasks(username: username, headings: headings)
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
                          controller: querycontroller,
                          decoration: InputDecoration(
                            hintText: 'Search Task',
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
                        icon: const Icon(Icons.search),
                        color: Colors.black45,
                        onPressed: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
            // completedtasks,
            ScrollableWindow(row: completedtasks),
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
      bottomNavigationBar: Footer(index: idx, username: username),
    );
  }
}


class ScrollableWindow extends StatelessWidget {
  final Widget row; // widget to display as the row

  const ScrollableWindow({Key? key, required this.row}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% width
      margin: const EdgeInsets.symmetric(horizontal: 22.0,vertical:22.0), // Equal padding
      decoration: BoxDecoration(
        color: const Color(0xFFFFE6C9),
        borderRadius: BorderRadius.circular(10.0), // Optional rounded corners
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(215, 90, 89, 88).withOpacity(0.2),
            blurRadius: 5.0, // Optional shadow effect
            spreadRadius: 2.0, // Optional shadow effect
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10.0),
      child: row
    );
  }
}
