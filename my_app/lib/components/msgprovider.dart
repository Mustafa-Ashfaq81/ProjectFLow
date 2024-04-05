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
      List<Message> empty = [];
      _messages.add({'id':id,'messages':empty});
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
      // print("adding new message ${message.message} sent at ${message.sentAt} for room $id");
      try{
        for(var room_msg in _messages){
          if(room_msg['id'] == id){
            // print("match id $id");
            final room_msgs = room_msg["messages"] as List<Message>;
            if(room_msgs.isEmpty) {
              room_msgs.add(message); 
              room_msg['messages'] = room_msgs;
            } else {
              final lastmsg = room_msgs.last;
              if(lastmsg.sentAt != message.sentAt && lastmsg.message != message.message){
                room_msgs.add(message); 
                room_msg['messages'] = room_msgs;
              }
            }
          }
        }
      } catch(e) {
        print("ignore_this_exception_for_now $e");
      }
      notifyListeners();
      return; 
  }
}