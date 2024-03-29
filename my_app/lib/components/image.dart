// ignore_for_file: avoid_print, avoid_single_cascade_in_expression_statements

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');



class ImageSetter extends StatefulWidget {
  final String username;
  const ImageSetter({Key? key, required this.username}) : super(key: key);

  @override
  _ImageSetterState createState() => _ImageSetterState();
}

class _ImageSetterState extends State<ImageSetter> {
  late FirebaseStorage _storage;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    initializeStorage();
  }

  Future<void> initializeStorage() async {
    await dotenv.load();
    String imageBucket = dotenv.env['IMAGE_BUCKET']!;
    _storage = FirebaseStorage.instanceFor(bucket: imageBucket);
    loadSavedImageUrl();
  }

  void _startUpload(XFile selectedImage) async {
    try {
      String filePath = 'images/${widget.username}.png';
      TaskSnapshot snapshot = kIsWeb
          ? await _storage.ref().child(filePath).putData(await selectedImage.readAsBytes())
          : await _storage.ref().child(filePath).putFile(File(selectedImage.path));

      imageUrl = await snapshot.ref.getDownloadURL();
      await SharedPreferences.getInstance()
          ..setString('image_${widget.username}', imageUrl);
      setState(() {});
    } catch (e) {
      print("[ImageSetter] StartUpload: Uploading error $e");
    }
  }

  Future<void> _pickImage() async {
    final XFile? selected = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selected != null) {
      _startUpload(selected);
    }
  }

  Future<void> loadSavedImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('image_${widget.username}');
    if (savedUrl != null && savedUrl.isNotEmpty) {
      setState(() => imageUrl = savedUrl);
    }
  }

  Widget buildImage() {
    bool hasImage = imageUrl.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, top: 15.0),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: hasImage ? NetworkImage(imageUrl) : const AssetImage("pictures/profile.png") as ImageProvider,
          ),
          Positioned(
            bottom: -15,
            right: -10,
            child: IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: _pickImage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty ? buildImage() : const Center(child: CircularProgressIndicator());
  }
}