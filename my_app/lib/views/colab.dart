// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/controllers/colabrequests.dart'; // Ensure this contains fetchAndCacheColabRequests
import 'package:my_app/utils/cache_util.dart';

class ColabPage extends StatefulWidget 
{
  final String username;

  const ColabPage({Key? key, required this.username}) : super(key: key);

  @override
  _ColabPageState createState() => _ColabPageState();
}

class _ColabPageState extends State<ColabPage> {
  final int idx = 4;
  List<Map<String, dynamic>> colabRequests = [];

  @override
  void initState() {
    super.initState();
    _loadColabRequests();
  }

  void _loadColabRequests() async {
    List<Map<String, dynamic>>? cachedRequests =
        CacheUtil.getData('colabRequests_${widget.username}');
    if (cachedRequests != null && cachedRequests.isNotEmpty) {
      // Use cached data if available
      setState(() {
        colabRequests = cachedRequests;
      });
    } else {
      // Fetch and cache colab requests if not in cache
      await fetchAndCacheColabRequests(widget.username);
      List<Map<String, dynamic>>? newlyFetchedRequests =
          CacheUtil.getData('colabRequests_${widget.username}');
      if (newlyFetchedRequests != null) {
        setState(() {
          colabRequests = newlyFetchedRequests;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Colab Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: colabRequests.isEmpty
          ? Center(child: Text("No requests for collaboration yet"))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: colabRequests.map((request) {
                  return ListTile(
                    title: Text(request['task'],
                        style: TextStyle(color: Colors.black)),
                    subtitle: Text("From: ${request['sender']}",
                        style: TextStyle(color: Colors.grey)),
                    onTap: () 
                    {
                      // Handle tap if needed, for example, to view request details
                    },
                  );
                }).toList(),
              ),
            ),
      bottomNavigationBar: Footer(index: idx, username: widget.username),
    );
  }
}
