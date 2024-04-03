import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../common/toast.dart';
import 'package:my_app/utils/cache_util.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registeracc(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      showerrormsg(message: "${e.message}");
    }
    return null;
  }

  Future<User?> loginacc(String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        await TaskService().fetchAndCacheNotesData(username);
        await TaskService().fetchAndCacheColabRequests(username);
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      showerrormsg(message: "${e.message}");
    }

    return null;
  }

  Future<User?> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      showerrormsg(message: " user is not logged in ");
    }
    return null;
  }

    Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      print("HELLO GOOGLE");
      final GoogleSignInAccount? googleUser;
      if (kIsWeb){
        googleUser = await GoogleSignIn(
          clientId: "12273615091-8aa1ois5l7b31tmirhcp6p7lihgmh1hk.apps.googleusercontent.com").signIn();
      } else{  //Android
         googleUser = await GoogleSignIn().signIn();
      }
      // print("GOOGLE USER: $googleUser");

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =  await googleUser?.authentication;
      // print("GOOGLE AUTH: $googleAuth");

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // print("CREDENTIAL: $credential");

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      // print("USER CREDENTIAL: $userCredential");

      // Once signed in, return the UserCredential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      showerrormsg(message: e.message.toString());
    }
    print("ret-null-from-sign-in-with-google");
    return null; 
  }

  Future<void> signOutFromGoogle() async {
    print("LOGGING OUT GMAIL");
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    print("LOGGED OUT gmail");
  }

}



  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn(
  //             clientId: "12273615091-8aa1ois5l7b31tmirhcp6p7lihgmh1hk.apps.googleusercontent.com")
  //         .signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     showerrormsg(message: "Some error occured with Google Sign In Api");
  //     return null;
  //   }
  // }



