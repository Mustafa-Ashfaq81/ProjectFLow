import 'package:flutter/material.dart';

class LoadingColab extends StatefulWidget {
  const LoadingColab({super.key});

  @override
  _LoadingColabState createState() => _LoadingColabState();
}

class _LoadingColabState extends State<LoadingColab> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child:CircularProgressIndicator());
  }
}