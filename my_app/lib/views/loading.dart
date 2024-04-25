// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class LoadingTask extends StatefulWidget {
  const LoadingTask({super.key});

  @override
  _LoadingTaskState createState() => _LoadingTaskState();
}

class _LoadingTaskState extends State<LoadingTask> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
