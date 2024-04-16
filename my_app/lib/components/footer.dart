// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:my_app/views/calendar.dart';
import 'package:my_app/views/tasks/notesPage.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/views/colab.dart';

/*

This files contains the implementation of the footer class. Footer is used to navigate between different pages in the application.
You will be able to see the footer at the bottom of the screen in the application

*/

// The Main class wraps the `FooterMenu` widget, providing theme data specific to our app's design requirements

class Footer extends StatelessWidget 
{
  final int index;
  final String username;

  const Footer({Key? key, required this.index, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
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

/*

The Footer Menu allows navigation between different parts of the application using a bottom bar
Tracks the currently selected tab with [index] and adjusts the application's navigation stack

*/

class FooterMenu extends StatefulWidget 
{
  final int index;
  final String username;
  const FooterMenu({super.key, required this.index, required this.username});

  @override
  _FooterMenuState createState() =>
      _FooterMenuState(selectedIndex: index, username: username);
}

class _FooterMenuState extends State<FooterMenu> 
{
  int selectedIndex; // This tracks the selected index on the footer menu
  String username;
  _FooterMenuState({required this.selectedIndex, required this.username});

   // Changes the application's page by navigating to new routes while preserving the user context
   
  void _onItemTapped(int index)  async
  {
    if (index != selectedIndex) 
    {
      switch (index) 
      {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(username: username),
            ),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AllTasksPage(username: username),
            ),
          );
          break;
        case 2:
          try {
            dynamic conversationObject = {
              'appId':
                  '318ca4627d2288155b7b63aa7a622814e', // The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from Kommunicate dashboard.
            };
            dynamic result =
                await KommunicateFlutterPlugin.buildConversation(conversationObject);
            print("Conversation builder success : " + result.toString());
          } on Exception catch (e) {
            print("Conversation builder error occurred : " + e.toString());
          }
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CalendarPage(username: username),
            ),
          );
          break;
        case 4:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ColabPage(username: username),
            ),
          );
          break;
        default:
          break;
      }
      setState(() 
      {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notes_sharp),
          label: 'Notes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.question_answer),
          label: 'Chatbot',
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
      showUnselectedLabels:
          true, // This ensures that labels are shown for unselected items
      onTap: _onItemTapped,
    );
  }
}
