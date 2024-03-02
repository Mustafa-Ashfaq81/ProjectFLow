import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

class ImageSetter extends StatefulWidget {
  final String username;
  //the next line makes this class directly importable as a widget
  const ImageSetter({Key? key, required this.username}) : super(key: key);
  @override
  _ImageSetterState createState() => _ImageSetterState(username: username);
}

class _ImageSetterState extends State<ImageSetter> {
  String username; // Track the username
  _ImageSetterState({required this.username});

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  late FirebaseStorage _storage; //will be initialised later ... and is not NULLABLE

  Future<void> fetchData() async {
    await dotenv.load(); // Load the environment variables
    String imagebucket = dotenv.env['IMAGE_BUCKET']!;
    _storage = FirebaseStorage.instanceFor(bucket: imagebucket);
  }

  String imageUrl = "";
  String downloadUrl = "";
  File _imageFile = File('pictures/profile.png');
  int dp = 0;


  void _startUpload(File imageFile, String imageUrl, XFile selectedImage) async { //uploads image to database
    try {
      String filePath = 'images/$username.png';
      if (kIsWeb) {
        final Uint8List bytes = await selectedImage.readAsBytes();
        _storage.ref().child(filePath).putData(bytes);
        downloadUrl = await _storage.ref().child(filePath).getDownloadURL();
      } else {
        _storage.ref().child(filePath).putFile(imageFile);
      }
      print("successupload");
    } catch (e) {
      print("uploading er $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async { //gets image from gallery
    final ImagePicker picker = ImagePicker();
    XFile? selected = await picker.pickImage(source: source);
    if (selected != null) {
      setState(() {
        _imageFile = File(selected.path);
        imageUrl = selected.path;
        _startUpload(_imageFile, imageUrl, selected);
      });
    }
  }

  Future<String> loadimg() async { //loads image from database
    try {
      final Reference ref = _storage.ref().child('images/$username.png');
      print("getting-url");
      await Future.delayed(const Duration(
          seconds: 3)); //helps in fetching an image if uploaded just now
      String durl = await ref.getDownloadURL();
      print("got-durl");
      return durl;
    } catch (e) {
      print("err $e");
    }
    return "";
  }

  Widget buildImage(String imageUrl, File imageFile, int dp) { //builds the image
    if (dp == 1) {
      if (kIsWeb) {
        return Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 15.0),
            child: Stack(children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(imageUrl, scale: 1.0),
              ),
              Positioned(
                bottom: -15, // Adjust the offset as needed
                right: -10, // Adjust the offset as needed
                child: IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ),
            ]));
      } else {
        return Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 15.0),
            child: Stack(children: [
              CircleAvatar(radius: 24, backgroundImage: FileImage(imageFile)),
              Positioned(
                bottom: -15, // Adjust the offset as needed
                right: -10, // Adjust the offset as needed
                child: IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ),
            ]));
      }
    } else {
      // no profile picture present
      return Padding(
          padding: const EdgeInsets.only(right: 15.0, top: 15.0),
          child: Stack(children: [
            const CircleAvatar(
              backgroundImage:
                  AssetImage("pictures/profile.png"), // Your profile image
              radius: 24, // Adjust as needed
            ),
            Positioned(
              bottom: -15, // Adjust the offset as needed
              right: -10, // Adjust the offset as needed
              child: IconButton(
                icon: const Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ),
          ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadimg(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            downloadUrl = snapshot.data!;
            if (downloadUrl != "") {
              dp = 1;
            }
            return buildImage(downloadUrl, _imageFile, dp);
          } else if (snapshot.hasError) {
            // Handle error
            return (const Text("error"));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
