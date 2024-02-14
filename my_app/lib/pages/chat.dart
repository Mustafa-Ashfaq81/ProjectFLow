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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: Center(
        child: Text('This is where you chat with GPT.'),
      ),
      bottomNavigationBar: Footer(context, idx, username),
    );
  }
}
