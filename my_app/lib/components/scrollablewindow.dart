// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

/*

  This file contains a custom widget that displays a scrollable window with a given row widget.
  This window is visible on our app's home/landing page once you login.
  The completed projects are wrapped in this window.
  
*/

class ScrollableWindow extends StatelessWidget {
  final Widget row;

  const ScrollableWindow({Key? key, required this.row}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(
            horizontal: 22.0,
            vertical: 22.0), // Ensure equal padding for better UI
        decoration: BoxDecoration(
          color: const Color(0xFFFFE6C9),
          borderRadius: BorderRadius.circular(10.0), // Optional rounded corners
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(215, 90, 89, 88).withOpacity(0.2),
              blurRadius: 5.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: row);
  }
}
