import 'package:flutter/material.dart';

/*

This file has a method which displays a confirmation dialog to ensure the user intends to delete a task.
This dialog provides an additional layer of confirmation to prevent accidental deletion of tasks.

*/


void showDeleteConfirmationDialog(BuildContext context, Function deleteTask) {
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
            onPressed: () {
              // Delete the task and pop back to the previous screen
              deleteTask();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}
