// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../common/toast.dart';
import 'package:my_app/utils/cache_util.dart';

class FirebaseAuthService  // Manages authentication operations with Firebase.
{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registeracc(String email, String password) async 
  {
    try 
    {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) 
    {
      showerrormsg(message: "${e.message}");
      // showerrormsg is a built-in function defined in toast.dart. It prints errors in large red text boxes
    }
    return null;
  }

  // If login is successful, it caches notes data and collaboration requests for the [username].

  Future<User?> loginacc(String email, String password, String username) async 
  {
    try 
    {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) 
      {
        await TaskService().fetchAndCacheNotesData(username);
        await TaskService().fetchAndCacheColabRequests(username);
      }
      return credential.user;
    } on FirebaseAuthException catch (e) 
    {
      showerrormsg(message: "${e.message}");
    }

    return null;
  }

  Future<User?> logout() async 
  {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) 
    {
      await FirebaseAuth.instance.signOut();
    } 
    else 
    {
      showerrormsg(message: " user is not logged in ");
    }
    return null;
  }

    Future<UserCredential?> signInWithGoogle() async 
    { // Returns [UserCredential] if the sign-in is successful; otherwise, null.

    try 
    {
      final GoogleSignInAccount? googleUser;

      if (kIsWeb)   // Handle Google sign-in for web using a specified client ID.
      {
        googleUser = await GoogleSignIn(
          clientId: "12273615091-8aa1ois5l7b31tmirhcp6p7lihgmh1hk.apps.googleusercontent.com").signIn();
      } 
      else
      {  //Android
         googleUser = await GoogleSignIn().signIn();   // Default Google sign-in flow for Android.
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =  await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential;
    } on FirebaseAuthException catch (e) 
    {
      showerrormsg(message: e.message.toString());
    }
    return null; 
  }

  Future<void> signOutFromGoogle() async 
  {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
  }

}