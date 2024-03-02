import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showmsg({required String message}) {
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