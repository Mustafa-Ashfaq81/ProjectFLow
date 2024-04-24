// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/repositories/auth/base.dart';
import 'package:my_app/utils/cache_util.dart';
import 'package:my_app/utils/inappmsgs_util.dart';
import 'package:my_app/views/home.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

class AuthRepository implements BaseAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<AppUser> login(LoginProps props) async {
    String username = "";
    String email = props.email;
    String password = props.password;

    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        username = doc['username'];
      }
    });

    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    if (credential.user != null) {
      await TaskService().fetchAndCacheNotesData(username);
      await TaskService().fetchAndCacheColabRequests(username);
    }

    return AppUser(
      email: email,
      username: username,
    );
  }

  @override
  register() {}

// todo : Remove context from here
  Future<void> afterLoginGmail(
      BuildContext context, UserCredential usercred) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Logging in with Gmail ..... '),
      duration: Duration(seconds: 3),
    ));
    var username = usercred.user!.displayName;
    final gmail = usercred.user!.email;
    List<String> allemails = await getallEmails();
    if (allemails.contains(gmail) == false) {
      var allusernames = await getallUsers();
      if (allusernames.contains(username) == true) {
        int suffix =
            1; // To ensure username remains unique, we append a suffix to it if it already exists.
        String newUsername = username!;
        while (allusernames.contains(newUsername)) {
          newUsername = '$username!_${suffix++}';
        }
        username = newUsername;
      }
      // List<Map<String, dynamic>>? mappedtasks = maptasks(get_random_task());
      List<Map<String, dynamic>> mappedtasks = [];
      try {
        createUser(
            UserModel(username: username, email: gmail, tasks: mappedtasks));
        await TaskService().fetchAndCacheNotesData(username!);
        await TaskService().fetchAndCacheColabRequests(username);
      } catch (e) {
        print("Error Occured! While Creating user model. Error: ---> $e");
      }
    } else {
      final userCollection = FirebaseFirestore.instance.collection("users");
      final snapshot =
          await userCollection.where('email', isEqualTo: gmail).get();
      final doc = snapshot.docs.first;
      username = doc.data()['username'];
      await TaskService().fetchAndCacheNotesData(username!);
      await TaskService().fetchAndCacheColabRequests(username);
    }

    if (context.mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              username: username!,
            ),
          ));
    }
  }

  @override
  Future<AppUser?> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser;

      if (kIsWeb) {
        googleUser = await GoogleSignIn(
                clientId:
                    "12273615091-8aa1ois5l7b31tmirhcp6p7lihgmh1hk.apps.googleusercontent.com")
            .signIn();
      } else {
        //Android
        googleUser = await GoogleSignIn().signIn();
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (context.mounted) await afterLoginGmail(context, userCredential);

      return AppUser(
        email: userCredential.user!.email!,
        username: userCredential.user!.displayName!,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  logout(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      showCustomError("User is not logged in", context);
    }
    return null;
  }

  @override
  signOutFromGoogle() async {
    final GoogleSignIn google = GoogleSignIn();
    await google.signOut();
  }


}
