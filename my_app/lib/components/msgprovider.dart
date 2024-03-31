import 'package:flutter/foundation.dart';

class Message {
  final String message;
  final String sender;
  final String room;
  final DateTime sentAt;

  Message({
    required this.message,
    required this.sender,
    required this.room,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> message) {
    return Message(
      message: message['message'],
      sender: message['sender'],
      room: message['room'],
      sentAt: DateTime.fromMillisecondsSinceEpoch(message['sentAt']),
    );
  }
}

class MessageProvider extends ChangeNotifier {
  final List<Map<String,dynamic>> _messages = [];

  setRoomIds(List<String> ids) { 
    for(var id in ids){
      _messages.add({'id':id,'messages':[]});
    }
  }

  getMessages(String id){
    for(var room_msg in _messages){
        if(room_msg['id'] == id){
          return room_msg["messages"]; 
        }
    }
  }

  addNewMessage(Message message, String id) {
      for(var room_msg in _messages){
        if(room_msg['id'] == id){
          room_msg['messages'].add(message); 
          notifyListeners();
          return; 
        }
      }
  }
}