import 'package:flutter/material.dart';
import 'package:my_app/auth/services/authservice.dart';
import 'package:my_app/common/logoutdialog.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/views/taskstatus.dart';

class HomePage extends StatefulWidget {
  final String username;
  HomePage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum MenuAction { logout }

class _HomePageState extends State<HomePage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  String username = "";
  final int idx = 0;

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Notes')),
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
                  ;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
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
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        'pictures/profile.png'), // Your profile image
                    radius: 24, // Adjust as needed
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 0.0),
              child: Text(
                username, // Your name
                style: TextStyle(
                  fontFamily: 'PilotExtended',
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Decrease the height here to move the search box up
            SizedBox(
                height:
                    20), // Adjust this value as needed to control space below your name
            Padding(
              padding: const EdgeInsets.only(
                  right: 20.0), // Adjust the margin as needed
              child: Container(
                width: 410, // Width of the search box
                height: 85, // Height of the search box
                padding: EdgeInsets.only(
                    left: 30), // Padding inside the container for alignment
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Tasks',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF000000), // Adjust the hint color
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Radius of the text field
                      borderSide: BorderSide.none, // Removes default border
                    ),
                    filled: true, // Needed for fillColor to work
                    fillColor:
                        Color(0xFFFFFFFF), // Background color of the text field
                    prefixIcon: Icon(
                      Icons.search, // Use the search icon
                      color: Color(0xFF000000), // Adjust the icon color
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 0.0),
              child: Text(
                'Completed Tasks', // Your name
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            fetchTasks("completed", username),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 20.0),
              child: Text(
                'Ongoing Projects', // Your name
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            fetchTasks("progress", username),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Footer(context, idx, username),
    );
  }
}
