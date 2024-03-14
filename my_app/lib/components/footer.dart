// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:my_app/views/tasks/newtask.dart';
import 'package:my_app/views/calendar.dart';
import 'package:my_app/views/tasks/alltasks.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/views/colab.dart';

class FooterMenu extends StatefulWidget {
  final int index;
  final String username;
  const FooterMenu({super.key, required this.index, required this.username});
  @override
  _FooterMenuState createState() =>
      _FooterMenuState(selectedIndex: index, username: username);
}

class _FooterMenuState extends State<FooterMenu> {
  int selectedIndex; // This Tracks the selected index on the footer menu
  String username; 
  _FooterMenuState({required this.selectedIndex, required this.username});

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    // Here we can add functionality to navigate to different pages or update the UI accordingly
    if (index == 1) {
      // print("chat page for GPT-API ");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllTasksPage(username: username),
          ));
    } else if (index == 2) {
      // print("CRUD - tasks");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewTaskPage(username: username),
          ));
    } else if (index == 3) {
      // print("check calendar");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalendarPage(username: username),
          ));
    } else if (index == 4) {
      // print("colab requests");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ColabPage(username: username),
          ));
    } else {
      // print("go to home");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(username: username),
          ));
    }
  }

// Building the application below using the App Bae
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.text_snippet),
          label: 'Notes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Collaboration',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.6),
      onTap: _onItemTapped,
    );
  }
}

Theme Footer(BuildContext context, int index, String username) {
  return Theme(
    data: Theme.of(context).copyWith(
      canvasColor: Colors.black, 
      primaryColor: Colors.white, 
      textTheme: Theme.of(context).textTheme.copyWith(
            bodySmall: TextStyle(
                color: Colors.white.withOpacity(
                    0.6)), 
          ),
    ),
    child: FooterMenu(
      index: index,
      username: username,
    ),
  );
}
