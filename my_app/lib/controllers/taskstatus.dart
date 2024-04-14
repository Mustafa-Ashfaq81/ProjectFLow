// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_app/views/tasks/task.dart';
import 'package:my_app/views/tasks/completedtask.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*

  This file contains the definitions for fetching tasks from Firestore based on their status and user.
  It includes widgets for displaying tasks either as 'completed' or 'in progress'.
  These widgets dynamically create lists of tasks and display them using different styles and interactivity

*/



Widget fetchTasks(String status, String username) 
{
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance.collection('users').get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) 
      {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } 
      else if (snapshot.hasError) 
      {
        return Text('Error: ${snapshot.error}');
      } 
      else 
      {
        List<Object> tasks = snapshot.data!.docs
            .where((doc) => doc['username'] == username)
            .map((doc) {
          final dynamic tsk = doc['tasks'];
          if (tsk is List<dynamic>) 
          {
            return tsk;
          } 
          else if (tsk is String) 
          {
            return tsk;
          }
          return '';
        }).toList();

        List<Map<String, dynamic>> headings = [];
        for (var item in tasks) 
        {
          List<dynamic> itemList = item as List<dynamic>;

          for (var nestedItem in itemList) 
          {
            Map<String, dynamic> itemMap = nestedItem as Map<String, dynamic>;
            if (itemMap['status'] == status) 
            {
              headings.add(
              {
                'heading': itemMap['heading'],
                'description': itemMap['description'],
              });
            }
          }
        }
        if (status == "completed") 
        {
          return completedIdeasView(context, headings, username);
        } 
        else 
        {
          return inprogressIdeasView(context, headings, username);
        }
      }
    },
  );
}

Widget completedIdeasView(BuildContext context, 
    List<Map<String, dynamic>> headings, String username) 
    {
  return headings.isEmpty
      ? const Padding(
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: Center(child: Text("No completed task yet")))
      : SingleChildScrollView(
          scrollDirection: Axis.horizontal, /// Displays tasks in a horizontally scrollable list
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
                              color: const Color(0xFFE16C00).withOpacity(0.48),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async 
                                {
                                  Map<String, dynamic> thistask =
                                      await getTaskbyHeading(
                                          task['heading'], username);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CompletedTaskPage(username: username, task: thistask),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Aligning heading to left
                                    children: [
                                      Text(
                                        task['heading'],
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height:8.0), // Adding space between heading and description
                                      Text(
                                        task['description'],
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ])
                      : Container(
                          margin: const EdgeInsets.only(left: 10.0, top: 10.0),
                          height: 200.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFF141310).withOpacity(0.85),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                Map<String, dynamic> thistask =
                                    await getTaskbyHeading(
                                        task['heading'], username);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CompletedTaskPage(username: username, task: thistask), // Task data will be passed as parameters
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task['heading'],
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      task['description'],
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                )
                .toList(),
          ));
}

Widget inprogressIdeasView(BuildContext context, // Uses similar mapping logic to 'completedIdeasView' but with different styling and data handling
    List<Map<String, dynamic>> headings, String username) 
    {
  return headings.isEmpty
      ? const Padding(
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: Center(child: Text("No task in progress")))
      : Padding(
          padding: const EdgeInsets.only(left: 1.0, right: 30.0),
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
                            color: const Color(0xFFE16C00).withOpacity(0.48),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async 
                              {
                                Map<String, dynamic> thistask =
                                    await getTaskbyHeading(
                                        task['heading'], username);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailsPage(
                                        username: username, task: thistask),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task['heading'],
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Expanded(
                                      child: Text(
                                        task['description'],
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.white70),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(left: 30.0, top: 15.0),
                          height: 90.0,
                          width: 450.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFF141310).withOpacity(0.85),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async 
                              {
                                Map<String, dynamic> thistask =
                                    await getTaskbyHeading(
                                        task['heading'], username);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailsPage(
                                        username: username, task: thistask),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task['heading'],
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Expanded(
                                      child: Text(
                                        task['description'],
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.white70),
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
