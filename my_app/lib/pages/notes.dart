import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class ChatPage extends StatefulWidget {
  final String username;
  ChatPage({required this.username});

  @override
  _ChatPageState createState() => _ChatPageState(username: username);
}

class _ChatPageState extends State<ChatPage> {
  String username;
  final int idx = 1;
  _ChatPageState({required this.username});

  final TextEditingController queryController = TextEditingController();
  String currQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: Column(
        children: [
          _buildSearchBox(),
          Expanded(
            child: _buildNotesList(), // This will build the list of notes
          ),
        ],
      ),
      bottomNavigationBar: Footer(context, idx, username),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
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
              controller: queryController,
              decoration: InputDecoration(
                hintText: 'Search Notes',
                hintStyle: TextStyle(color: Color(0xFF000000)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xFFFFFFFF),
              ),
              onChanged: (text) {
                setState(() {
                  currQuery = text;
                });
                // Assuming you have logic to handle search query changes
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Assuming you have logic to initiate search
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    final List<Map<String, dynamic>> notes = [
      {
        'title': 'Mobile App Wireframe',
        'description':
            'Revolutionize your real estate taking experience with our idea enhancement app which will not only give you...',
        'completed': false,
      },
      {
        'title': 'Se Homework',
        'description':
            'Revolutionize your real estate taking experience with our idea enhancement app which will not only give you...',
        'completed': true,
      },
      {
        'title': 'Null Studios',
        'description':
            'Revolutionize your real estate taking experience with our idea enhancement app which will not only give you...',
        'completed': false,
      },
    ];

    // Define a list of colors
    final List<Color> colors = [
      Colors.pink[50]!,
      Colors.lightGreen[50]!,
      Colors.lightBlue[50]!,
      // Add more colors as needed
    ];

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        // Use modulo (%) operator to cycle through the colors list if there are more notes than colors
        Color bgColor = colors[index % colors.length];

        return Card(
          color: bgColor, // Use the bgColor for this note card
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            title: Text(
              notes[index]['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(notes[index]['description']),
            onTap: () {
              // TODO: Implement navigation to note details page
            },
          ),
        );
      },
    );
  }
}