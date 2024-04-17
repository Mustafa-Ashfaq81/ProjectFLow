import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*

This file contains methods which are used to display error messages to the user and general information messages respectively
A third method displays a custom error message in a SnackBar within the provided [context].

In this context, a snackbar is a lightweight message that briefly informs users when certain actions occur, such as when a task is deleted or when an error occurs.

*/

// Displays an error message using the Fluttertoast plugin

void showerrormsg({required String message}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.redAccent,
      webBgColor: "linear-gradient(to right, #85240D, #821B05)",
      textColor: const Color(0xfffefbfb),
      fontSize: 16.0);
}

/// Displays a general information message using Fluttertoast.

void showmsg({required String message}) {
  Fluttertoast.showToast(
      msg: " ✓ $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      webBgColor: "green",
      textColor: const Color(0xfffefbfb),
      fontSize: 16.0);
}

// Displays a custom error message
void showCustomError(String message, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.redAccent,
    action: SnackBarAction(
      label: 'Dismiss',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
