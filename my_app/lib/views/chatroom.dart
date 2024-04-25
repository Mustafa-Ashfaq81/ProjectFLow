// ignore_for_file: prefer_const_constructors, library_prefixes

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_app/components/msgprovider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:my_app/views/colab.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String room;
  final String id;
  final IO.Socket socket;
  final MessageProvider provider;
  // Constructor for ChatPage
  const ChatPage(
      {Key? key,
      required this.username,
      required this.room,
      required this.socket,
      required this.id,
      required this.provider})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatPage> {
  late MessageProvider _provider;
  late IO.Socket _socket;
  final TextEditingController _messageInputController = TextEditingController();

  void _sendMessage() {
    // Method to send a message
    final thismsg = {
      'message': _messageInputController.text.trim(),
      'sender': widget.username,
      'room': widget.id,
      'sentAt': DateTime.now().millisecondsSinceEpoch
    };
    _provider.addNewMessage(Message.fromJson(thismsg), widget.id);
    _socket.emit('message', {
      'message': _messageInputController.text.trim(),
      'sender': widget.username,
      'room': widget.id
    });
    _messageInputController.clear();
  }

  @override
  void initState() {
    super.initState();
    _socket = widget.socket;
    _provider = widget.provider;
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room,
        style: TextStyle(color: Colors.white),
        ),

        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, 
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ColabPage(username: widget.username),
                ));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MessageProvider>(
              builder: (_, provider, __) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (ctx, index) {
                  final message = provider.getMessages(widget.id)[index];
                  return message.room != widget.id
                      ? Wrap()
                      : Wrap(
                          alignment: message.sender == widget.username
                              ? WrapAlignment.end
                              : WrapAlignment.start,
                          children: [
                            message.sender != widget.username
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(message.sender),
                                  )
                                : Text(""),
                            Card(
                              color: message.sender == widget.username
                                  ? Theme.of(ctx).primaryColorLight
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      message.sender == widget.username
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Text(message.message),
                                    Text(
                                      DateFormat('hh:mm a')
                                          .format(message.sentAt),
                                      style: Theme.of(ctx).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            message.sender == widget.username
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(message.sender),
                                  )
                                : Text(""),
                          ],
                        );
                },
                separatorBuilder: (_, index) => const SizedBox(
                  height: 5,
                ),
                itemCount: provider.getMessages(widget.id).length,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageInputController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_messageInputController.text.trim().isNotEmpty) {
                        _sendMessage();
                      }
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
