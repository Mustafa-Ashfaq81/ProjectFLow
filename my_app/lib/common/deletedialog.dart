import 'package:flutter/material.dart';
  
  void showDeleteConfirmationDialog(BuildContext context, Function deleteTask){
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