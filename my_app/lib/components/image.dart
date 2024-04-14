// ignore_for_file: avoid_print, avoid_single_cascade_in_expression_statements, library_private_types_in_public_api, prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ImageCodeException implements Exception {
  final String message;

  ImageCodeException(this.message);

  @override
  String toString() {
    return 'ImageCodeException: $message';
  }
}

/*

 This files contains the implementation of the ImageSetter class. Images are used to display profile pictures in the application
 A StatefulWidget that allows users to upload and view profile images.
 Uses Firebase Storage for storing images and SharedPreferences for caching image URLs

*/

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

class ImageSetter extends StatefulWidget 
{
  final String username;
  const ImageSetter({Key? key, required this.username}) : super(key: key);

  @override
  _ImageSetterState createState() => _ImageSetterState();
}

class _ImageSetterState extends State<ImageSetter> 
{
  late FirebaseStorage _storage;
  String imageUrl = '';
  bool isLoading = false;

  @override
  void initState() 
  {
    super.initState();
    initializeStorage();
  }

  /*

  Firebase Storage is initialized with the bucket specified in the .env file
  Initially an attempt is made to load a previously saved image URL from SharedPreferences

  */

  Future<void> initializeStorage() async 
  {
    await dotenv.load();
    String imageBucket = dotenv.env['IMAGE_BUCKET']!;
    _storage = FirebaseStorage.instanceFor(bucket: imageBucket);
    loadSavedImageUrl();
  }

  Future<Uint8List> _getImageFuture() async 
  {
    try 
    {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) 
      {
        final Uint8List bodyBytes = response.bodyBytes;
        // We can add a simple check for the PNG file header as an example
        // PNG files start with 0x89 0x50 0x4E 0x47 0x0D 0x0A 0x1A 0x0A
        if (bodyBytes.length >= 8 &&
            bodyBytes[0] == 0x89 &&
            bodyBytes[1] == 0x50 &&
            bodyBytes[2] == 0x4E &&
            bodyBytes[3] == 0x47 &&
            bodyBytes[4] == 0x0D &&
            bodyBytes[5] == 0x0A &&
            bodyBytes[6] == 0x1A &&
            bodyBytes[7] == 0x0A) 
            {
          return bodyBytes;
        } 
        else 
        {
          throw ImageCodeException('Unsupported image format.');
        }
      } 
      else 
      {
        throw ImageCodeException(
            'Failed to load image: Server returned status code ${response.statusCode}');
      }
    } 
    catch (e) 
    {
      throw ImageCodeException('Failed to load image: $e');
    }
  }

  /*

  Upon successful upload, shared preferences are used to store the image URL
  Shared preferences in app development allow developers to store small amounts of data in key-value pairs on a user's device

  */

  void _startUpload(XFile selectedImage) async 
  {
    setState(() 
    {
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
      setState(() 
      {
        isLoading = false;
      });
    } 
    catch (e) 
    {
      print("[ImageSetter] StartUpload: Uploading error $e");
      setState(() 
      {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? selected =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (selected != null) {
        _startUpload(selected);
      }
    } catch (e) {
      print('Error picking image: $e');
      // Handle the error gracefully, e.g., show a snackbar or dialog to the user
    }
  }

  


  Future<void> loadSavedImageUrl() async 
  {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('image_${widget.username}');
    if (savedUrl != null && savedUrl.isNotEmpty) 
    {
      setState(() => imageUrl = savedUrl);
    }
  }

  Widget buildImage() 
  {
    bool hasImage = imageUrl.isNotEmpty;
    return GestureDetector(
      onTap: () 
      {
        showModalBottomSheet(   // Includes a clickable image that opens a modal to view or change the image
          context: context,
          builder: (BuildContext context) 
          {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.visibility),
                  title: Text('View Image'),
                  onTap: () 
                  {
                    Navigator.pop(context);
                    _viewImage();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Change Image'),
                  onTap: () 
                  {
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
            child: FutureBuilder(
              future: _getImageFuture(),
              builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } 
                else if (snapshot.hasError) 
                {
                  // If there's an error, display the default image
                  return Image.asset("pictures/profile.png",
                      fit: BoxFit.contain);
                } else if (snapshot.hasData) 
                {
                  return Image.memory(snapshot.data!, fit: BoxFit.contain);
                } 
                else 
                {
                  return Image.asset("pictures/profile.png",
                      fit: BoxFit.contain);
                }
              },
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) 
  {
    return buildImage();
  }
}
