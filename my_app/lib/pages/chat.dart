import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final int idx = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: Center(
        child: Text('This is where you chat with GPT.'),
      ),
      bottomNavigationBar: Footer(context,idx),
    );
  }
}
