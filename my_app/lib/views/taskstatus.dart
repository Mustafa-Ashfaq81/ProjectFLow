import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



Widget fetchTasks(String status, String username) {
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance.collection('users').get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // Show loading indicator while fetching data
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        List<Object> tasks = snapshot.data!.docs
            .where((doc) => doc['username'] == username)
            .map((doc) {
          final dynamic tsk = doc['tasks'];
          if (tsk is List<dynamic>) {
            return tsk;
          } else if (tsk is String) {
            return tsk;
          }
          return ''; // Return empty string as fallback
        }).toList();

        // print(tasks[0]);
        List<Map<String, dynamic>> headings = [];
        for (var item in tasks) {
          List<dynamic> itemList = item as List<dynamic>;

          for (var nestedItem in itemList) {
            Map<String, dynamic> itemMap = nestedItem as Map<String, dynamic>;
            if (itemMap['status'] == status) {
              headings.add({
                'heading': itemMap['heading'],
                // 'duedate' :  itemMap['duedate'],
                // 'duehour' :  itemMap['duehour'],
                //'subtasks': itemMap['subtasks'], //run another loop that further gets string from map
              });
            }
          }
        }
        // print(headings);
        if (status == "completed") {
          return completedIdeasView(headings);
        } else {
          return inprogressIdeasView(headings);
        } //"progress"
      }
    },
  );
}

Widget completedIdeasView(List<Map<String, dynamic>> headings) {
  return headings.isEmpty
      ? Text("No completed task yet")
      : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: headings
                  .map(
                    (task) => headings.indexOf(task) % 2 == 0
                        ? Row(children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10.0, top: 10.0),
                              height: 200.0,
                              width: 200.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFE16C00).withOpacity(0.48),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  task['heading'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ])
                        : Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, top: 10.0),
                            height: 200.0,
                            width: 200.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF141310),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                task['heading'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  )
                  .toList(),
            ),
          ));
}


Widget inprogressIdeasView(List<Map<String, dynamic>> headings) {
  return headings.isEmpty
      ? Text("No task in progress")
      : Padding(
          padding:
              const EdgeInsets.only(right: 20.0), // Adjust the margin as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: headings.map((task) => headings.indexOf(task) % 2 == 0
                      ? Container(
                          margin: const EdgeInsets.only(left: 30.0, top: 10.0),
                          height: 90.0,
                          width: 450.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFE16C00).withOpacity(0.48),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              task['heading'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      :
                      // SizedBox(width: 20.0), // Adjust the space between the containers
                      Container(
                          margin: const EdgeInsets.only(left: 30.0, top: 15.0),
                          height: 90.0,
                          width: 450.0,
                          decoration: BoxDecoration(
                            color: Color(0xFF141310),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              task['heading'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ),
                )
                .toList(),
        ),
    );
}
