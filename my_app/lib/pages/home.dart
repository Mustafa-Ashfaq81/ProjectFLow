import 'package:flutter/material.dart';
import 'package:my_app/auth/services/authservice.dart';
import 'package:my_app/common/logoutdialog.dart';
import 'package:my_app/views/taskstatus.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/components/image.dart';
import 'package:my_app/components/search.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/pages/settings.dart';

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
  // _HomePageState() { //constructor(init) for async functions
  //   print("init-state-async");
  //   atload(); //async func
  // }

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
    // editTask(username, "t_three"); //for testing
    //instantiate this data only once (at page load)
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
        title: const Center(child: Text('My Notes',
        style: TextStyle(color: Colors.white), ),),
        centerTitle: true, 
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
        iconTheme: IconThemeData(color: Colors.white),
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
            // Decrease the height here to move the search box up
            const SizedBox(
                height:
                    20), // Adjust this value as needed to control space below your name
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
                            color: Color(0xFF000000), // Adjust the hint color
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
                          showSearch(
                              context: context,
                              delegate: SearchTasks(
                                  username: username, headings: headings));
                          querycontroller.clear();
                        }
                      },
                      // onSubmitted:  showSearch(context: context, delegate: SearchTasks());,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: SearchTasks(
                                username: username, headings: headings));
                      } // Simulate search button press
                      ),
                ],
              ),
            ), // Padding inside the container for alignment
            const Padding(
              padding: EdgeInsets.only(left: 30.0, top: 0.0),
              child: Text(
                'Completed Tasks', // Your name
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
                'Ongoing Projects', // Your name
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
