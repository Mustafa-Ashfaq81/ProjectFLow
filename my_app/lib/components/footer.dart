// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:my_app/views/tasks/newtask.dart';
import 'package:my_app/views/calendar.dart';
import 'package:my_app/views/tasks/alltasks.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/views/colab.dart';

class Footer extends StatelessWidget {
  final int index;
  final String username;

  const Footer({Key? key, required this.index, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: Theme.of(context).textTheme.copyWith(
              bodySmall: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
      ),
      child: FooterMenu(
        index: index,
        username: username,
      ),
    );
  }
}
class FooterMenu extends StatefulWidget {
  final int index;
  final String username;
  const FooterMenu({super.key, required this.index, required this.username});

  @override
  _FooterMenuState createState() =>
      _FooterMenuState(selectedIndex: index, username: username);
}

class _FooterMenuState extends State<FooterMenu> {
  int selectedIndex; // This tracks the selected index on the footer menu
  String username;
  _FooterMenuState({required this.selectedIndex, required this.username});

  void _onItemTapped(int index) {
    // You can optimize this by using a switch statement instead of if-else chain.
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(username: username),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllTasksPage(username: username),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewTaskPage(username: username),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalendarPage(username: username),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ColabPage(username: username),
          ),
        );
        break;
      default:
        break;
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
          icon: Icon(Icons.text_snippet),
          label: 'Notes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Collab',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.6),
      showUnselectedLabels: true, // This ensures that labels are shown for unselected items
      onTap: _onItemTapped,
    );
  }
}