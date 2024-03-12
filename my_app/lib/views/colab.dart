import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/controllers/colabrequests.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/views/loadingscreens/loadingcolab.dart';

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

  Future<void> atload(BuildContext context) async {
    if (otherusers.isEmpty) {
      List<String> allusers = await getallUsers();
      for (var user in allusers) {
        if (user != username) {
          otherusers.add(user);
        }
      }
      await Future.delayed(const Duration(
          seconds: 3)); //helps in updating requests if added/declined just now
      reqtasks = await get_ifany_requests(username, otherusers);
    }
    requests = showRequests(context,reqtasks, username);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
        future: atload(context), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingColab();  // Show loading page while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Colab Page'),
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
