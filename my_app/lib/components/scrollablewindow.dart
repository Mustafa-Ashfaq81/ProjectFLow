import 'package:flutter/material.dart';

class ScrollableWindow extends StatelessWidget {
  final Widget row; // widget to display as the row

  const ScrollableWindow({Key? key, required this.row}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% width
      margin: const EdgeInsets.symmetric(horizontal: 22.0,vertical:22.0), // Equal padding
      decoration: BoxDecoration(
        color: const Color(0xFFFFE6C9),
        borderRadius: BorderRadius.circular(10.0), // Optional rounded corners
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(215, 90, 89, 88).withOpacity(0.2),
            blurRadius: 5.0, // Optional shadow effect
            spreadRadius: 2.0, // Optional shadow effect
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10.0),
      child: row
    );
  }
}