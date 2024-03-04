import 'package:flutter/material.dart';

class LoadingAllTasks extends StatefulWidget {
  LoadingAllTasks();

  @override
  _LoadingAllTasksState createState() => _LoadingAllTasksState();
}

class _LoadingAllTasksState extends State<LoadingAllTasks> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child:CircularProgressIndicator());
  }
}