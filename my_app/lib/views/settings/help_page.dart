import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class HelpPage extends StatelessWidget {
  final String username;

  const HelpPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Help',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildFAQItem(
              question: 'How do I create a new task?',
              answer:
                  'To create a new task, tap on the "+" button in the bottom navigation bar. Fill in the task details and tap "Save" to add the task to your list.',
            ),
            _buildFAQItem(
              question: 'Can I collaborate with others on tasks?',
              answer:
                  'Yes, you can collaborate with others by sharing tasks with them. Open the task details and tap on the "Share" button to invite collaborators.',
            ),
            _buildFAQItem(
              question: 'How can I mark a task as completed?',
              answer:
                  'To mark a task as completed, simply tap on the checkbox next to the task in your task list. The task will be moved to the "Completed" section.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'If you have any further questions or need assistance, please contact our support team:',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Email: support@ideaenhancerapp.com',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Phone: +1 (123) 456-7890',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Read our privacy policy to understand how we collect, use, and protect your personal information.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Navigate to privacy policy page
                // Implement navigation to privacy policy page here
              },
              child: const Text(
                'View Privacy Policy',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(index: 0, username: username),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          answer,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
