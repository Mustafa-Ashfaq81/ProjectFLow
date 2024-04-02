import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showerrormsg({required String message}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      webBgColor: "linear-gradient(to right, #85240D, #821B05)",
      textColor: const Color(0xfffefbfb),
      fontSize: 16.0);
}

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

void showCustomError(String message,BuildContext context) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.redAccent,
    action: SnackBarAction(
      label: 'Dismiss',
      onPressed: () {
        // Some code to undo the change if needed.
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}