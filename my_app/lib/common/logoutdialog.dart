import 'package:flutter/material.dart';


/*

This file has a method which displays a confirmation dialog asking the user if they are sure they want to log out.
This dialog is used to confirm the user's intention to log out of the application,
preventing accidental logouts. It returns a Future that completes with a boolean indicating the user's choice

*/


Future<bool> showLogOutDialog(BuildContext context) 
{
  return showDialog<bool>(
    context: context,
    builder: (context) 
    {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () 
              {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () 
              {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out')),
        ],
      );
    },
  ).then(
    (value) => value ?? false,
  );
}
