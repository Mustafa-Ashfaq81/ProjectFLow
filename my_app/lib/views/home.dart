// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, unnecessary_cast, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:my_app/auth/controllers/authservice.dart';
import 'package:my_app/common/logoutdialog.dart';
import 'package:my_app/controllers/taskstatus.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/components/image.dart';
import 'package:my_app/components/search.dart';
import 'package:my_app/components/scrollablewindow.dart';
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
  }
  
  Future<void> atload() async {
    List<Map<String, dynamic>>? cachedOngoingProjects =
        CacheUtil.getData('ongoingProjects_$username');

    List<Map<String, dynamic>>? cachedCompletedProjects =
        CacheUtil.getData('completedProjects_$username');

    List<String>? cachedHeadings =
        CacheUtil.getData('headings_$username');


    if (cachedCompletedProjects != null) {
      completedtasks = completedIdeasView(context,cachedCompletedProjects,username);
    } else {
      print('completed-tasks-cache-null');
      completedtasks = fetchTasks("completed", username);
      CacheUtil.cacheData('completedProjects_$username', completedtasks);
    }

    if (cachedOngoingProjects != null)  {
      inprogresstasks = inprogressIdeasView(context,cachedOngoingProjects,username);
    } else {
      print('progress-tasks-cache-null');
      inprogresstasks = fetchTasks("progress", username);
      CacheUtil.cacheData('ongoingProjects_$username', inprogresstasks);
    }

    if(cachedHeadings != null){
      headings = cachedHeadings;
    } else {
      print('headings-cache-null');
      headings = await getTaskHeadings(username);
      CacheUtil.cacheData('headings_$username', headings);
    }
    profilepic = ImageSetter(username: username);
  }

  @override
  void dispose() {
    querycontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return FutureBuilder(
          future: atload(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Show loading page while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else { 
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
                      try{
                        await _auth.logout();
                      } catch(e){
                        print("not a normal account $e");
                        await _auth.signOutFromGoogle();
                      }
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
            ScrollableWindow(row: completedtasks),
            Center(
             child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Ongoing Projects',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
 );
 }
}
