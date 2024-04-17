import 'package:flutter/material.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/views/loadingscreens/loadingtask.dart';

class CompletedTaskPage extends StatefulWidget {
  final String username;
  final Map<String, dynamic> task;
  const CompletedTaskPage(
      {Key? key, required this.username, required this.task})
      : super(key: key);

  @override
  State<CompletedTaskPage> createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'Completed Project Details',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SlideTransition(
      position: _slideAnimation,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProjectDetails(String label, String content) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final taskheading = task['heading'];
    final taskdesc = task['description'];
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Project Heading'),
            _buildProjectDetails('Heading', taskheading),
            const SizedBox(height: 20),
            _buildSectionTitle('Project Description'),
            _buildProjectDetails('Description', taskdesc),
            const SizedBox(height: 20),
            _buildSectionTitle('Subtasks'),
            _buildSubtasks(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtasks() {
    // Dummy data and example builder. Implement your actual subtask logic here.
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ListTile(
            title: Text('Subtask ${index + 1}'),
            // subtitle: Text('Detail of Subtask ${index + 1}'),
          ),
        );
      },
    );
  }
}
