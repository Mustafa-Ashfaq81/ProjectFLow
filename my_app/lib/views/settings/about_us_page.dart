import 'package:flutter/material.dart';
import 'package:my_app/components/footer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_app/config/config.dart'; 

class AboutUsPage extends StatelessWidget {
  final String username;

  const AboutUsPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> teamMembers = [
      {
        'name': 'Adeen Ali Khan',
        'image': 'pictures/adeen.png',
        'linkedin': AppConfig.linkedinURLs['Adeen Ali Khan']!,
      },
      {
        'name': 'Essa Shahid Arshad',
        'image': 'pictures/essa.png',
        'linkedin': AppConfig.linkedinURLs['Essa Shahid Arshad']!,
      },
      {
        'name': 'Muhammad Hurraira Anwer',
        'image': 'pictures/hurraira.png',
      },
      {
        'name': 'Muhammad Mehdi Changezi',
        'image': 'pictures/mehdi.png',
        'linkedin': AppConfig.linkedinURLs['Muhammad Mehdi Changezi']!,
      },
      {
        'name': 'Mustafa Ashfaq',
        'image': 'pictures/mustafa.png',
        'linkedin': AppConfig.linkedinURLs['Mustafa Ashfaq']!,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,

          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ProjectFlow App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'At ProjectFlow, our mission is to empower individuals and teams to unleash their creative potential and bring their ideas to life. We strive to provide a user-friendly platform that fosters collaboration, innovation, and productivity.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Story',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Founded in 2024, ProjectFlow was born out of a passion for innovation and a desire to make idea management accessible to everyone. Our team of experienced developers and designers came together to create a powerful yet intuitive app that simplifies the process of capturing, organizing, and executing ideas.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Values',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
          const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '- ',
                  ),
                  TextSpan(
                    text: 'Innovation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          ': We believe in pushing boundaries and embracing new ideas to drive progress and growth.\n'),
                  TextSpan(
                    text: '- ',
                  ),
                  TextSpan(
                    text: 'Collaboration',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          ': We foster a culture of teamwork and encourage open communication to achieve shared goals.\n'),
                  TextSpan(
                    text: '- ',
                  ),
                  TextSpan(
                    text: 'User-Centric',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          ': We put our users at the center of everything we do, constantly striving to improve their experience.\n'),
                  TextSpan(
                    text: '- ',
                  ),
                  TextSpan(
                    text: 'Simplicity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        ': We aim to make complex processes simple and intuitive, enabling users to focus on what matters most.',
                  ),
                ],
              ),
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have any questions, feedback, or suggestions, we\'d love to hear from you. Feel free to reach out to us at:',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Email: info@projectflow.com\nPhone: +92 3056781234 \nAddress: 123 Innovation Street, City, Country',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Team',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            CarouselSlider(
              items: teamMembers.map((member) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (member['linkedin'] != null) {
                                final url = member['linkedin']!;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }
                            },
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage(member['image']!),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            member['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 200,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(index: 0, username: username),
    );
  }
}
