import 'package:flutter/material.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/views/tasks/task.dart';

/*

This file has a method which displays a confirmation dialog to ensure the user intends to delete a task.
This dialog provides an additional layer of confirmation to prevent accidental deletion of tasks.

*/

void showDeleteConfirmationDialog(BuildContext context, Function deleteTask,
    String username, dynamic thisTask) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Are you sure you want to delete this Task?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Delete the task and pop back to the previous screen
              await deleteTask();
              // Navigator.of(context).pop();
              if (thisTask == null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(username: username),
                    ));
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TaskDetailsPage(username: username, task: thisTask),
                  ),
                );
              }
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}
