import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/views/colabrequests.dart';
import 'package:my_app/models/usermodel.dart';

class ColabPage extends StatefulWidget {
  final String username;
  const ColabPage({super.key, required this.username});
  @override
  _ColabPageState createState() => _ColabPageState(username: username);
}

class _ColabPageState extends State<ColabPage> {
  String username;
  final int idx = 4;
  _ColabPageState({required this.username});

  Widget requests = const Text("at-init-state");
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
      reqtasks = await get_ifany_requests(username, otherusers);
    }
    requests = showRequests(reqtasks, username);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
        future: atload(), // Call atload() directly here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Colab Page',
                style: TextStyle(color: Colors.white),),
                centerTitle: true, 
                backgroundColor: Colors.black,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              body: Column(
                children: [requests],
              ),
              bottomNavigationBar: Footer(context, idx, username),
            );
          }
        },
      );
    });
  }
}
