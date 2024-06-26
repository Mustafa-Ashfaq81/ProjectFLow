// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, unnecessary_cast, prefer_const_constructors, sort_child_properties_last, unused_element, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:my_app/views/tasks/newtask.dart';
import 'package:my_app/controllers/taskstatus.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/components/image.dart';
import 'package:my_app/components/search.dart';
import 'package:my_app/components/scrollablewindow.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/views/settings/settings.dart';
import 'package:my_app/views/tasks/task.dart';
import '../utils/cache_util.dart';

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
  TextEditingController querycontroller = TextEditingController();

  // Widgets for displaying completed tasks, in-progress tasks, and profile picture

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

  // Function to load data asynchronously when the widget is built

  Future<void> atload() async {
    // Fetch cached data for ongoing and completed projects, and task headings
    List<Map<String, dynamic>>? cachedOngoingProjects =
        CacheUtil.getData('ongoingProjects_$username');

    List<Map<String, dynamic>>? cachedCompletedProjects =
        CacheUtil.getData('completedProjects_$username');

    List<String>? cachedHeadings = CacheUtil.getData('headings_$username');

    // Check if completed projects data is cached

    if (cachedCompletedProjects != null) {
      completedtasks =
          completedIdeasView(context, cachedCompletedProjects, username);
    } else {
      print('completed-tasks-cache-null');
      completedtasks = fetchTasks("completed", username);
      CacheUtil.cacheData('completedProjects_$username', completedtasks);
    }

// Check if ongoing projects data is cached

    if (cachedOngoingProjects != null) {
      inprogresstasks =
          inprogressIdeasView(context, cachedOngoingProjects, username);
    } else {
      print('progress-tasks-cache-null');
      inprogresstasks = fetchTasks("progress", username);
      CacheUtil.cacheData('ongoingProjects_$username', inprogresstasks);
    }

    // Check if task headings data is cached
    if (cachedHeadings != null) {
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
    // Build the widget asynchronously to load data
    return FutureBuilder(
        future: atload(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show loading page while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Build the home page with fetched data

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: AppBar(
                  title: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Text(
                        'My Projects',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  foregroundColor: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    // Settings icon leading to settings page
                    IconButton(
                      icon: Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                SettingsPage(username: username)));
                      },
                      padding: EdgeInsets.only(right: 10),
                    ),
                  ],
                  backgroundColor: Colors.black,
                ),
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome message and profile picture
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Welcome back!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          profilepic,
                        ],
                      ),
                    ),
                    // Username display
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0,
                          top: 0.0), // Adjust top value to reduce space
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
                    // Search bar for tasks
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 30.0,
                        top: 20.0,
                        left: 30.0,
                        bottom: 20.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Show search delegate to search tasks
                          Future<String?> selectedTask = showSearch(
                            context: context,
                            delegate: SearchTasks(
                                username: username,
                                headings: headings) as SearchDelegate<String>,
                          );
                          selectedTask.then((taskheading) async {
                            Map<String, dynamic> task =
                                await getTaskbyHeading(taskheading!, username);
                            if (taskheading != "") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailsPage(
                                      username: username, task: task),
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
                                    hintText: 'Search Task By Heading',
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
                                icon: const Icon(Icons.search,
                                    color: Colors
                                        .black), // Set the color property here

                                color: Colors.black,
                                onPressed: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Section for ongoing projects
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
                    // Section for completed projects
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Completed Projects',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ScrollableWindow(row: completedtasks),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Floating action button for adding new tasks
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewTaskPage(username: username),
                    ),
                  );
                },
                backgroundColor: Color.fromARGB(255, 41, 157, 252),
                child: Icon(
                  Icons.add,
                  size: 15, // Adjust the size as needed
                ),
              ),
              // Footer
              bottomNavigationBar: Footer(index: idx, username: username),
            );
          }
        });
  }
}
