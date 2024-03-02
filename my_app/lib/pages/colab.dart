import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/views/colabrequests.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ColabPage extends StatefulWidget {
  final String username;
  ColabPage({required this.username});
  @override
  _ColabPageState createState() => _ColabPageState(username: username);
}

class _ColabPageState extends State<ColabPage> {
  String username;
  final int idx = 4;
  _ColabPageState({required this.username});

  Widget requests = Text("at-init-state");
  List<Map<String, dynamic>> reqtasks = [];
  List<String> otherusers = [];

  @override
  void initState() {
    super.initState();
    // print("init-state-sync");
    //instantiate this data only once (at page load)
    // atload();
  }

  Future<void> atload() async {
    if (otherusers.isEmpty) {
      List<String> allusers = await getallUsers();
      for (var user in allusers) {
        if (user != username) {
          otherusers.add(user);
        }
      }
      reqtasks = await getreq(username, otherusers);
    }
    requests = fetchRequests(reqtasks, username);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
        future: atload(), // Call atload() directly here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Show loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Colab Page'),
              ),
              // body: Center(
              //   child: Text(
              //       'This is where you get your collaboration requests and your messages.'),
              // ),
              body: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      sendColabreq(["dbz"]);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Text('Send  req'),
                  ),
                  SizedBox(height: 20),
                  requests,
                ],
              ),
              bottomNavigationBar: Footer(context, idx, username),
            );
          }
        },
      );
    });
  }

  void sendColabreq(List<String> usernames) async {
    print('sending req...');
    try {
      final colabCollection = FirebaseFirestore.instance.collection('colab');
      final index = await getTaskindex("t_three", username);
      Map<String, dynamic> data = {
        'req_recv': usernames,
        'req_sender': username,
        'req_task': index
      };
      print(data);
      await colabCollection.add(data);
      print('Colab req sent successfully.');
    } catch (e) {
      print('Error sending req: $e');
    }
  }
}
