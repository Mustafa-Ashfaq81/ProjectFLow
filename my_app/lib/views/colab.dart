// // ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/controllers/colabrequests.dart'; // Ensure this contains fetchAndCacheColabRequests
import 'package:my_app/models/groupchatmodel.dart';
import 'package:my_app/utils/cache_util.dart';
import 'package:my_app/views/chatroom.dart';
import 'package:provider/provider.dart';
import 'package:my_app/components/msgprovider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:my_app/utils/inappmsgs_util.dart';


class ColabPage extends StatefulWidget {
  final String username;
  const ColabPage({Key? key, required this.username}) : super(key: key);

  @override
  _ColabPageState createState() => _ColabPageState();
}

class _ColabPageState extends State<ColabPage> {
  final int idx = 4;
  List<Map<String, dynamic>> colabRequests = [];
  List<Map<String, dynamic>> rooms = [];
  String allrooms = '';
  IO.Socket _socket = IO.io('dummy_url'); //to avoid some errors
  late MessageProvider provider;

  @override
  void initState() {
    provider = Provider.of<MessageProvider>(context, listen: false);
    super.initState();
  }
  
  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }


  Future<void> atload() async {
    List<Map<String, dynamic>>? cachedRequests =
        CacheUtil.getData('colabRequests_${widget.username}');
    if (cachedRequests != null && cachedRequests.isNotEmpty) { // Use cached data if available
        colabRequests = cachedRequests;
    } else {  // Fetch and cache colab requests if not in cache
      await TaskService().fetchAndCacheColabRequests(widget.username);
      List<Map<String, dynamic>>? newlyFetchedRequests =
          CacheUtil.getData('colabRequests_${widget.username}');
      if (newlyFetchedRequests != null) {
          colabRequests = newlyFetchedRequests;
      }
    }
    //fetch group chats / rooms for that user
    rooms = await fetchroomsforuser(widget.username);
    if (rooms.isNotEmpty){
      allrooms = rooms.fold('', (previousValue, element) {
        final heading = element['room_id'] as String;
        return previousValue.isEmpty ? heading : '$previousValue, $heading';
      });
      handleSocket();
    }
  }

  void handleSocket(){
    List<String> ids = [];
    for (var room in rooms) {
        var id = room['room_id'];
        ids.add(id);
    }
    provider.setRoomIds(ids);
    
    _socket = IO.io(
      'http://localhost:3000',
      IO.OptionBuilder().setTransports(['websocket']).setQuery(
          {'username': widget.username, 'rooms':allrooms}).build(),
    );
    _socket.onConnect((data) => print('Connection established'));
    _socket.onDisconnect((data) => print('Connection terminated'));
    _socket.onConnectError((data) { 
    print('Connect Error: $data');
    showCustomError("Connection Error: The server isn't active as of now", context);
    _socket.disconnect();
    _socket.dispose();
    });
   _socket.on('message', (data) { 
    if (data['sender'] != widget.username){
          provider.addNewMessage(Message.fromJson(data),data['room']); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
          future: atload(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),); // Show loading page while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text('Colab Page', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.black,
                ),
                body: colabRequests.isEmpty
                    ? SingleChildScrollView( 
                      scrollDirection: Axis.vertical,
                      child: Column( 
                        children :[
                          Center(child: Text("No requests for collaboration yet"), ) ,
                           _Chatrooms() ,
                        ]
                      ),
                    ): SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [ 
                            Center(child:Text("Pending requests")) ,
                            Column(children: colabRequests.map((request) {
                              return ListTile(
                                title: Text(request['task'].toString(),
                                   style: TextStyle(color: Colors.black)),
                                subtitle: Text("From: ${request['sender']}",
                                  style: TextStyle(color: const Color.fromARGB(255, 95, 92, 92))),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min, // Ensure buttons fit within ListTile
                                    children: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Accepting request and creating group chats ... '),duration: Duration(seconds: 4),));
                                            await acceptreq(context,request, widget.username);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ColabPage(username: widget.username),
                                            ));
                                          },
                                          child: const Text("Accept request"),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                          onPressed: () async {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Declining collaboration request ... '),duration: Duration(seconds: 3),));
                                            await rejectreq(context,request, widget.username);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ColabPage(username: widget.username),
                                            ));
                                          },
                                          child: const Text("Decline request"),
                                      ),
                                    ]
                                  ),
                            );
                          }).toList(),
                        ), 
                        _Chatrooms(),
                      ]
                      ),
                  ),
                bottomNavigationBar: Footer(index: idx, username: widget.username),
              );
            }
           }
        );
     });
  }
  Widget _Chatrooms(){
   return rooms.isEmpty ? Center(child: Text("No projects in collaboration yet"), )
      :  SizedBox( // Wrap ListView with SizedBox
          height: 200.0, // Set a fixed height (adjust as needed)
          child: ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, indexx) {
            final room = rooms[indexx];
            final roomname = room['heading'] as String; // Cast to String
            return ListTile(
              title: Text('Task: ' + roomname),
              subtitle: Text("Enter group chat"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(username: widget.username, room: roomname,socket: _socket, id: room['room_id'], provider: provider),
                ));
              },
            );
          },
      ) 
    );
  }
}



