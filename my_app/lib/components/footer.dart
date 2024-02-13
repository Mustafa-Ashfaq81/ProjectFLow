import 'package:flutter/material.dart';
import 'package:my_app/pages/task.dart';
import 'package:my_app/pages/calendar.dart';
import 'package:my_app/pages/chat.dart';
import 'package:my_app/pages/settings.dart';
import 'package:my_app/pages/home.dart';

class FooterMenu extends StatefulWidget {
  final int index;
  FooterMenu({required this.index});
  @override
  _FooterMenuState createState() => _FooterMenuState(selectedIndex: index);
}

class _FooterMenuState extends State<FooterMenu> {
  int selectedIndex; // Track the selected index
  _FooterMenuState({required this.selectedIndex});

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    print(index);
    // Here you can add functionality to navigate to different pages or update the UI accordingly
    if (index == 1) {
      print("chat page for GPT-API ");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(),
          ));
    } else if (index == 2) {
      print("CRUD - tasks");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskPage(),
          ));
    } else if (index == 3) {
      print("check calendar");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalendarPage(),
          ));
    } else if (index == 4) {
      print("update settings");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ));
    } else {
      print("go to home");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
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
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.6),
      onTap: _onItemTapped,
    );
  }
}

Theme Footer(BuildContext context, int index) {
  return Theme(
    data: Theme.of(context).copyWith(
      // This custom theme only applies to the BottomNavigationBar.
      canvasColor: Colors.black, // Forcefully sets the background color
      primaryColor: Colors.white, // This will affect the selected item color.
      textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(
                color: Colors.white.withOpacity(
                    0.6)), // This will affect the unselected item color.
          ),
    ),
    child: FooterMenu(index: index),
  );
}
