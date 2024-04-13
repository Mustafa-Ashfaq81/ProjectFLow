import 'package:flutter/material.dart';
  
  void showCompleteConfirmationDialog(BuildContext context, Function completeTask){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to mark this subtask as completed?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Complete the task and pop back to the previous screen
                completeTask();
                Navigator.of(context).pop();
              },
              child: const Text("Save progress"),
            ),
          ],
        );
      },
    );
  }