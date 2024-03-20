// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api, use_build_context_synchronously

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
             appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBar(
              centerTitle: true, // Aligns the title to the center
              backgroundColor: Colors.black, // Set background color to black
              title: Text(
                'Colab Page',
                style: TextStyle(color: Colors.white), // Set text color to white
                  ),
            ),
                ),
              body: Column(
                children: [requests],
              ),
                  bottomNavigationBar: Footer(index: idx, username: username),
            );
          }
        },
      );
    });
  }
}
