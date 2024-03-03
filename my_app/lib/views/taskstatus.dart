import 'package:flutter/material.dart';
import 'package:my_app/pages/task_details.dart';
import 'package:my_app/models/taskmodel.dart';
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
                'description': itemMap['description'], 
              });
            }
          }
        }
        // print(headings);
        if (status == "completed") {
          return completedIdeasView(context, headings, username);
        } else {
          return inprogressIdeasView(context, headings, username);
        } //"progress"
      }
    },
  );
}

Widget completedIdeasView(BuildContext context, List<Map<String, dynamic>> headings, String username) {
  return headings.isEmpty
      ? Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          child: Center(child: Text("No completed task yet")))
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
                              child: Material( // Make the container clickable
    color: Colors.transparent, // Maintain container color
    child: InkWell( // Handle taps
      onTap: () async {
        Map<String,dynamic> thistask = await getTaskbyHeading(task['heading'], username) ;
        // Navigate to another page with task data (replace with your navigation logic)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsPage(username:username, task:thistask), // Pass the task data
          ),
        );
      },
      child: Padding( // Add padding
        padding: const EdgeInsets.all(16.0),
        child: Column( // Arrange heading and description vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align heading to left
          children: [
            Text(
              task['heading'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Adjust font size as needed
              ),
            ),
            const SizedBox(height: 8.0), // Add space between heading and description
            Text(
              task['description'],
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
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
                            child: Material( // Make the container clickable
    color: Colors.transparent, // Maintain container color
    child: InkWell( // Handle taps
      onTap: () async {
        Map<String,dynamic> thistask = await getTaskbyHeading(task['heading'], username) ;
        // Navigate to another page with task data (replace with your navigation logic)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsPage(username:username, task:thistask), // Pass the task data
          ),
        );
      },
      child: Padding( // Add padding
        padding: const EdgeInsets.all(16.0),
        child: Column( // Arrange heading and description vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align heading to left
          children: [
            Text(
              task['heading'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Adjust font size as needed
              ),
            ),
            const SizedBox(height: 8.0), // Add space between heading and description
            Text(
              task['description'],
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    ),
  ),           
                          ),
                  )
                  .toList(),
            ),
          ));
}

Widget inprogressIdeasView(BuildContext context, List<Map<String, dynamic>> headings, String username) {
  return headings.isEmpty
      ? Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          child: Center(child: Text("No task in progress")))
      : Padding(
          padding:
              const EdgeInsets.only(right: 20.0), // Adjust the margin as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: headings
                .map(
                  (task) => headings.indexOf(task) % 2 == 0
                      ? Container(
                          margin: const EdgeInsets.only(left: 30.0, top: 10.0),
                          height: 90.0,
                          width: 450.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFE16C00).withOpacity(0.48),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material( // Make the container clickable
    color: Colors.transparent, // Maintain container color
    child: InkWell( // Handle taps
      onTap: () async {
        Map<String,dynamic> thistask = await getTaskbyHeading(task['heading'], username) ;
        // Navigate to another page with task data (replace with your navigation logic)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsPage(username:username, task:thistask), // Pass the task data
          ),
        );
      },
      child: Padding( // Add padding
        padding: const EdgeInsets.all(16.0),
        child: Column( // Arrange heading and description vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align heading to left
          children: [
            Text(
              task['heading'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Adjust font size as needed
              ),
            ),
            const SizedBox(height: 8.0), // Add space between heading and description
            Text(
              task['description'],
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
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
                          child: Material( // Make the container clickable
    color: Colors.transparent, // Maintain container color
    child: InkWell( // Handle taps
      onTap: () async {
        Map<String,dynamic> thistask = await getTaskbyHeading(task['heading'], username) ;
        // Navigate to another page with task data (replace with your navigation logic)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsPage(username:username, task:thistask), // Pass the task data
          ),
        );
      },
      child: Padding( // Add padding
        padding: const EdgeInsets.all(16.0),
        child: Column( // Arrange heading and description vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align heading to left
          children: [
            Text(
              task['heading'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Adjust font size as needed
              ),
            ),
            const SizedBox(height: 8.0), // Add space between heading and description
            Text(
              task['description'],
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    ),
  ),           
                        ),
                )
                .toList(),
          ),
        );
}
