import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';

class AboutUsPage extends StatelessWidget {
  final String username;

  const AboutUsPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'About Us',
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
              'Idea Enhancer App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'At Idea Enhancer App, our mission is to empower individuals and teams to unleash their creative potential and bring their ideas to life. We strive to provide a user-friendly platform that fosters collaboration, innovation, and productivity.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Story',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Founded in 2022, Idea Enhancer App was born out of a passion for innovation and a desire to make idea management accessible to everyone. Our team of experienced developers and designers came together to create a powerful yet intuitive app that simplifies the process of capturing, organizing, and executing ideas.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Values',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '- Innovation: We believe in pushing boundaries and embracing new ideas to drive progress and growth.\n'
              '- Collaboration: We foster a culture of teamwork and encourage open communication to achieve shared goals.\n'
              '- User-Centric: We put our users at the center of everything we do, constantly striving to improve their experience.\n'
              '- Simplicity: We aim to make complex processes simple and intuitive, enabling users to focus on what matters most.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have any questions, feedback, or suggestions, we\'d love to hear from you. Feel free to reach out to us at:',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Email: info@ideaenhancerapp.com\nPhone: +1 (123) 456-7890\nAddress: 123 Innovation Street, City, Country',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(index: 0, username: username),
    );
  }
}
