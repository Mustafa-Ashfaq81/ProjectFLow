// ignore_for_file: avoid_print, avoid_single_cascade_in_expression_statements, library_private_types_in_public_api, prefer_const_constructors

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
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });

    try {
      String filePath = 'images/${widget.username}.png';
      TaskSnapshot snapshot = kIsWeb
          ? await _storage
              .ref()
              .child(filePath)
              .putData(await selectedImage.readAsBytes())
          : await _storage
              .ref()
              .child(filePath)
              .putFile(File(selectedImage.path));

      imageUrl = await snapshot.ref.getDownloadURL();
      await SharedPreferences.getInstance()
        ..setString('image_${widget.username}', imageUrl);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("[ImageSetter] StartUpload: Uploading error $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? selected =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.visibility),
                  title: Text('View Image'),
                  onTap: () {
                    Navigator.pop(context);
                    _viewImage();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Change Image'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0, top: 15.0),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: hasImage
                  ? NetworkImage(imageUrl)
                  : AssetImage("pictures/profile.png") as ImageProvider,
              child: isLoading ? CircularProgressIndicator() : null,
            ),
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.photo_library,
                  size: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('View Image'),
          ),
          body: Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildImage();
  }
}
