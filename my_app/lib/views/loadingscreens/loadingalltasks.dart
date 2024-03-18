// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class LoadingAllTasks extends StatefulWidget {
  const LoadingAllTasks({super.key});

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
    return const Center(child:CircularProgressIndicator());
  }
}