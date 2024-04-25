// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CompletedSubtaskPage extends StatefulWidget {
  final Map<String, dynamic> subtask;
  const CompletedSubtaskPage({Key? key, required this.subtask})
      : super(key: key);

  @override
  State<CompletedSubtaskPage> createState() => _CompletedSubtaskPageState();
}

class _CompletedSubtaskPageState extends State<CompletedSubtaskPage>
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
        'Completed Subtask Details',
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

  Widget _buildSubtaskDetails(String label, String content) {
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
    final subtask = widget.subtask;
    final subtaskheading = subtask['subheading'];
    final subtaskcontent = subtask['content'];
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Subtask Heading'),
            _buildSubtaskDetails('Heading', subtaskheading),
            const SizedBox(height: 20),
            _buildSectionTitle('Subtask Content'),
            _buildSubtaskDetails('Content', subtaskcontent),
          ],
        ),
      ),
    );
  }
}
