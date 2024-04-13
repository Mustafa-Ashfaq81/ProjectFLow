// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/foundation.dart';

/*

Represents a single message within a chat application feature implemented on our app
Each message is associated with a sender, the room where it was sent, and the time it was sent

*/

class Message 
{
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

  /*

  Factory constructor to create a new Message instance from a JSON object

  [message] A map containing keys for message, sender, room, and sentAt

  The 'sentAt' is expected to be a timestamp in milliseconds since epoch

  In a computing context, an *epoch* is the date and time relative to which a computer's clock and timestamp values are determined
  
  */


  factory Message.fromJson(Map<String, dynamic> message) 
  {
    return Message(
      message: message['message'],
      sender: message['sender'],
      room: message['room'],
      sentAt: DateTime.fromMillisecondsSinceEpoch(message['sentAt']),
    );
  }
}

// Maintains a list of messages and rooms, allowing for adding new messages and fetching messages per room

class MessageProvider extends ChangeNotifier 
{
  final List<Map<String, dynamic>> _messages = [];

  setRoomIds(List<String> ids) 
  {
    for (var id in ids) 
    {
      List<Message> empty = [];
      _messages.add({'id': id, 'messages': empty});
    }
  }

  getMessages(String id)    // Retrieves messages for a specific room by its identifier.
  {
    for (var room_msg in _messages) 
    {
      if (room_msg['id'] == id) 
      {
        return room_msg["messages"];
      }
    }
  }

  addNewMessage(Message message, String id) 
  {
    try 
    {
      for (var room_msg in _messages) 
      {
        if (room_msg['id'] == id) 
        {
          final room_msgs = room_msg["messages"] as List<Message>;
          if (room_msgs.isEmpty) 
          {
            room_msgs.add(message);
            room_msg['messages'] = room_msgs;
          } 
          else 
          {
            final lastmsg = room_msgs.last;
            if (lastmsg.sentAt != message.sentAt &&
                lastmsg.message != message.message) 
            {
              room_msgs.add(message);
              room_msg['messages'] = room_msgs;
            }
          }
        }
      }
    } 
    catch (e) 
    {
      print("ignore_this_exception_for_now $e");
    }
    notifyListeners();
    return;
  }
}
